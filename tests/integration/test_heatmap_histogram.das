options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Headless regression for heatmap_histogram: spawn the tutorial and assert both the
//! HEAT plot (plot_heatmap grid) and the HIST plot (1D histogram of a sample array)
//! register and draw. Covers the two statistical 2D / distribution items through the
//! v2 snapshot scope, as a tutorial counterpart to the test_stats_items smoke.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/heatmap_histogram.das"

[test]
def test_heatmap_histogram(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let heat = implot_open(d, "PLOT_WIN/HEAT")
        var hsnap = implot_wait_visible(heat, 15.0f)
        t |> success(hsnap != null && plot_visible(hsnap, heat),
                     "HEAT plot (plot_heatmap) rendered")

        let hist = implot_open(d, "PLOT_WIN/HIST")
        var gsnap = implot_wait_visible(hist, 6.0f)
        t |> success(gsnap != null && plot_visible(gsnap, hist),
                     "HIST plot (histogram) rendered")
    }
}
