options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Headless regression for line_plot: spawn the tutorial and assert the WAVES plot
//! (v2 plot container) renders and seeds the axis limits set by setup_axes_limits.
//! The view-nav gestures (pan / zoom / fit) are driven and self-verified by the
//! recording driver, record_line_plot.das; this just guards the render in CI.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/line_plot.das"

[test]
def test_line_plot(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let waves = implot_open(d, "PLOT_WIN/WAVES")
        var snap = implot_wait_visible(waves, 15.0f)
        t |> success(snap != null && plot_visible(snap, waves),
                     "WAVES plot (plot_line sin/cos) rendered")
        // setup_axes_limits(0, 200, -1.5, 1.5) seeds the view on the first frame.
        var lsnap = wait_for_axis_limits(waves, 0.0lf, 200.0lf, -1.5lf, 1.5lf)
        t |> success(lsnap != null, "WAVES axis limits seeded to the configured range")
    }
}
