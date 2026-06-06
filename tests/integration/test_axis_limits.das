options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require math
require daslib/json public
require daslib/json_boost public

//! Headless regression for the v2 `plot` snapshot hook over the LIVE pipeline:
//! spawn the multi_series tutorial via daslang-live, then assert the WAVES plot's
//! serialized axis limits match what `setup_axes_limits(0,200,-1.5,1.5)` set, and
//! that the second (BARS) plot scope registers independently under the same window.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/multi_series.das"

[test]
def test_axis_limits(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/WAVES")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null, "WAVES plot rendered")
        if (snap == null) return

        let lim = plot_axis_limits(snap, s)
        t |> success(abs(lim.x_min - 0.0lf) < 1.0e-3lf, "x_min == 0 (got {lim.x_min})")
        t |> success(abs(lim.x_max - 200.0lf) < 1.0e-3lf, "x_max == 200 (got {lim.x_max})")
        t |> success(abs(lim.y_min + 1.5lf) < 1.0e-3lf, "y_min == -1.5 (got {lim.y_min})")
        t |> success(abs(lim.y_max - 1.5lf) < 1.0e-3lf, "y_max == 1.5 (got {lim.y_max})")

        // The second plot scope (BARS) registers independently under the same window.
        let bars = implot_open(d, "PLOT_WIN/BARS")
        var bsnap = implot_wait_visible(bars, 6.0f)
        t |> success(bsnap != null && plot_visible(bsnap, bars), "BARS plot also registered + visible")
    }
}
