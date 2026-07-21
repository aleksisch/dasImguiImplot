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

//! Headless regression for shaded_and_stairs: spawn the tutorial and assert both
//! filled-area plots register and draw — the BAND plot (plot_shaded_between band +
//! mean line) and the STAIRS plot (plot_stairs steps over plot_shaded fill). Proves
//! the area/step item families render crash-free under the v2 snapshot scope.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/shaded_and_stairs.das"

[test]
def test_shaded_and_stairs(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let band = implot_open(d, "PLOT_WIN/BAND")
        var bsnap = implot_wait_visible(band, 15.0f)
        t |> success(bsnap != null && plot_visible(bsnap, band),
                     "BAND plot (shaded-between + mean line) rendered")

        let stairs = implot_open(d, "PLOT_WIN/STAIRS")
        var ssnap = implot_wait_visible(stairs, 6.0f)
        t |> success(ssnap != null && plot_visible(ssnap, stairs),
                     "STAIRS plot (stairs + shaded fill) rendered")
    }
}
