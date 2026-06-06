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

//! Headless regression for query_and_hover: spawn the tutorial, move the synth cursor
//! onto the plot, and assert the live query reflects it — hovered flips true and
//! GetPlotMousePos resolves to DATA coords inside the axis range ([0,100] x [-1.2,1.2]).
//! The same path the example annotates with plot_text / plot_inf_lines on hover.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/query_and_hover.das"

[test]
def test_query_and_hover(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/CHART")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null, "chart rendered")
        if (snap == null) return

        // Off-window before the move → not hovered.
        t |> success(!plot_hovered(snap, s), "not hovered before the synth move")

        // Move onto the plot center and wait for hovered to flip.
        let center = plot_center(snap, s)
        move_to(d, center)
        var hsnap = wait_for_hovered(s, true)
        t |> success(hsnap != null, "synth move onto the plot center → hovered")
        if (hsnap == null) return

        let m = plot_mouse_pos(hsnap, s)
        t |> success(m._0 >= 0.0lf && m._0 <= 100.0lf, "mouse-plot-x inside [0,100] (got {m._0})")
        t |> success(m._1 >= -1.2lf && m._1 <= 1.2lf, "mouse-plot-y inside [-1.2,1.2] (got {m._1})")
    }
}
