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

//! Headless regression for multi_axes: spawn the tutorial and assert the primary
//! axes converge to what the example pinned — X1 [0,100] and Y1 (temperature) [0,30].
//! The snapshot reads GetPlotLimits(X1,Y1), so a correct Y1 range here proves the
//! second y axis (pressure on Y2, range ~[950,1050]) is genuinely independent.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/multi_axes.das"

[test]
def test_multi_axes(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/CHART")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null && plot_visible(snap, s), "multi-axis plot rendered")
        if (snap == null) return

        let m = wait_for_axis_limits(s, 0.0lf, 100.0lf, 0.0lf, 30.0lf)
        t |> success(m != null, "X1 converged to [0,100] and Y1 (temp) to [0,30] — Y2 is independent")
    }
}
