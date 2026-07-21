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

//! Headless regression for subplots: spawn the tutorial and assert the subplot GRID
//! registers + drew (BeginSubplots returned true), and that an individual cell nests
//! under it (PLOT_WIN/GRID/P_SIN) and drew too. Proves the grid container and its
//! per-cell `plot` scopes snapshot independently along the nested widget path.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/subplots.das"

[test]
def test_subplots(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let grid = implot_open(d, "PLOT_WIN/GRID")
        var gsnap = implot_wait_visible(grid, 15.0f)
        t |> success(gsnap != null && plot_visible(gsnap, grid),
                     "subplot GRID rendered (BeginSubplots true)")

        let cell = implot_open(d, "PLOT_WIN/GRID/P_SIN")
        var csnap = implot_wait_visible(cell, 6.0f)
        t |> success(csnap != null && plot_visible(csnap, cell),
                     "first cell (P_SIN) nested under the grid + drew")
    }
}
