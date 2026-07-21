options gen2
options _comment_hygiene = true
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require implot
require math
require daslib/json public
require daslib/json_boost public

//! Headless regression for multi_axes + the secondary-axis rail: spawn the tutorial, assert the
//! primary axes converge (X1 [0,100], Y1/temp [0,30]) AND that Y2 (pressure) is captured at
//! ~[950,1050]. Then drive the rail's interaction — drag ONLY the Y2 gutter — and verify pressure's
//! range moves while Y1 (temp) and X1 stay put: the independent-axis pan the tutorial teaches. Also
//! guards the legend-label fix (the Y2-routed "pressure" series' label is captured). The recording
//! driver record_multi_axes.das narrates the same gesture.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/multi_axes.das"

[test]
def test_multi_axes(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/CHART")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null && plot_visible(snap, s), "multi-axis plot rendered")
        if (snap == null) return

        // Primary axes converge to what the example pinned.
        var m = wait_for_axis_limits(s, 0.0lf, 100.0lf, 0.0lf, 30.0lf)
        t |> success(m != null, "X1 -> [0,100], Y1 (temp) -> [0,30]")
        if (m == null) return

        // Secondary-axis telemetry: Y2 (pressure) is captured, ranging ~[950,1050], independent of Y1.
        t |> success(abs(plot_axis_limit(m, s, "y2_max") - 1050.0lf) < 1.0lf, "Y2 (pressure) max captured ~1050")
        // The Y2-routed series' legend label resolves (the first-frame label fix). Poll, don't
        // one-shot: ImPlot can resolve the label a few frames after the item registers. Runs on all
        // platforms — issue #9 (macOS empty/garbage label) is fixed in the LegendEntryLabel forwarder.
        t |> success(wait_for_series_shown(s, "pressure", true) != null, "pressure series present in legend (Y2 label captured)")

        // Drag ONLY the Y2 gutter: pressure's range must move while temp (Y1) and X1 stay put — the
        // independent-axis pan the tutorial teaches, distinct from a whole-plot body pan (moves all).
        let y2_before = plot_axis_limit(m, s, "y2_max")
        drag_axis(s, ImAxis.Y2, 120.0f)
        var dsnap = wait_for_axis_limit_changed(s, "y2_max", y2_before)
        t |> success(dsnap != null, "dragging the Y2 gutter pans pressure (y2_max moved)")
        if (dsnap == null) return

        let lim = plot_axis_limits(dsnap, s)
        t |> success(abs(lim.y_max - 30.0lf) < 0.5lf, "Y1 (temp) unchanged by the Y2 drag")
        t |> success(abs(lim.x_max - 100.0lf) < 0.5lf, "X1 unchanged by the Y2 drag")
    }
}
