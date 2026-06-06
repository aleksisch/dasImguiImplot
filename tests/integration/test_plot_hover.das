options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Headless regression for the SYNTHETIC-INPUT path: spawn multi_series, move the
//! synth cursor onto the WAVES plot, and assert the snapshot reflects it — hovered
//! flips true and GetPlotMousePos resolves to DATA coords inside the axis range
//! ([0,200] x [-1.5,1.5]). Proves synth input drains through the harness into ImPlot.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/multi_series.das"

[test]
def test_plot_hover(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/WAVES")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null, "WAVES plot rendered")
        if (snap == null) return

        // Before any move the headless cursor is off-window → not hovered.
        t |> success(!plot_hovered(snap, s), "not hovered before the synth move")

        // Move the synth cursor to the plot-area center and wait for hovered to flip.
        let center = plot_center(snap, s)
        move_to(d, center)
        var hsnap = wait_for_hovered(s, true)
        t |> success(hsnap != null, "synth move onto the plot center → hovered")
        if (hsnap == null) return

        // mouse-plot-pos is now valid: it must resolve to data coords within the axes.
        let m = plot_mouse_pos(hsnap, s)
        t |> success(m._0 >= 0.0lf && m._0 <= 200.0lf, "mouse-plot-x inside [0,200] (got {m._0})")
        t |> success(m._1 >= -1.5lf && m._1 <= 1.5lf, "mouse-plot-y inside [-1.5,1.5] (got {m._1})")
    }
}
