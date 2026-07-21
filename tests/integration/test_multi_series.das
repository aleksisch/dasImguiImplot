options gen2
options _comment_hygiene = true
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Headless regression for multi_series + the legend-toggle rail: spawn the tutorial, assert both
//! v2 plot scopes render, then drive a REAL synthetic click on the WAVES "cos" legend entry and
//! verify the series hides and shows again. This exercises ImPlot's built-in legend toggle through
//! the plot snapshot's per-series telemetry (label / shown / clickable rect). The recording driver
//! record_multi_series.das narrates the same gesture; this guards it in CI.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/multi_series.das"

[test]
def test_multi_series(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let waves = implot_open(d, "PLOT_WIN/WAVES")
        var snap = implot_wait_visible(waves, 15.0f)
        t |> success(snap != null && plot_visible(snap, waves), "WAVES plot (sin/cos/scatter) rendered")

        let bars = implot_open(d, "PLOT_WIN/BARS")
        var bsnap = implot_wait_visible(bars, 15.0f)
        t |> success(bsnap != null && plot_visible(bsnap, bars), "BARS plot (int data) rendered")

        // Legend telemetry: entries surface once ImPlot has rendered the legend (>=1 EndPlot),
        // so wait for cos's shown=true to settle, then assert the entry + its clickable rect.
        var lsnap = wait_for_series_shown(waves, "cos", true)
        let cos = legend_entry(lsnap, waves, "cos")
        t |> success(cos.found, "cos legend entry present in WAVES snapshot")
        t |> success(cos.shown, "cos series initially shown")
        // Validates the whole chain: vendor patch -> forwarder -> serialize -> playwright read.
        t |> success(cos.rect.z > cos.rect.x && cos.rect.w > cos.rect.y,
                     "cos legend entry has a non-empty clickable rect")

        // Hover telemetry + the sync gate: moving onto the entry must make it report hovered
        // (the signal legend_toggle waits on so the press can't land before hover registers).
        move_to(d, legend_entry_center(lsnap, waves, "cos"))
        t |> success(wait_for_legend_hover(waves, "cos") != null, "cos legend entry reports hovered on cursor-over")

        // Hide cos by clicking its legend entry; verify the series goes hidden.
        legend_toggle(waves, "cos")
        var hsnap = wait_for_series_shown(waves, "cos", false)
        t |> success(hsnap != null, "cos series hidden after legend click")
        // The toggle is per-series — sin stays shown.
        t |> success(series_shown(hsnap, waves, "sin"), "sin series unaffected by cos toggle")

        // Click again; verify cos comes back.
        legend_toggle(waves, "cos")
        var rsnap = wait_for_series_shown(waves, "cos", true)
        t |> success(rsnap != null, "cos series shown again after second legend click")
    }
}
