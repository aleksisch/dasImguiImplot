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

//! Headless regression for the colormap wrappers: spawn colormaps_and_style and assert
//! both colormap-scoped plots register and draw — the Viridis HEAT plot (heatmap +
//! colorbar) and the Spectral LINES plot (6 auto-colored series). Proves with_colormap /
//! colormap_scale render crash-free under a pushed colormap and snapshot like any plot.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/colormaps_and_style.das"

[test]
def test_colormaps(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let heat = implot_open(d, "PLOT_WIN/HEAT")
        var hsnap = implot_wait_visible(heat, 15.0f)
        t |> success(hsnap != null && plot_visible(hsnap, heat),
                     "HEAT plot (Viridis heatmap + colorbar) rendered")

        let lines = implot_open(d, "PLOT_WIN/LINES")
        var lsnap = implot_wait_visible(lines, 6.0f)
        t |> success(lsnap != null && plot_visible(lsnap, lines),
                     "LINES plot (Spectral auto-colored series) rendered")
    }
}
