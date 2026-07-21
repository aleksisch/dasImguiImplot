options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: colormaps_and_style — push a colormap so items + heatmaps auto-color
// from it, and draw the matching colorbar legend.
//
//   with_colormap(cmap) { ... }      — RAII colormap scope; items inside sample it.
//   colormap_scale(label, lo, hi)    — a colorbar for the CURRENT (pushed) colormap.
//   sample_colormap(t, cmap)         — sample a color at t in [0,1] (not shown here).
//
// `cmap` is the ImPlotColormap enum: Deep / Dark / Viridis / Plasma / Jet / Spectral
// / Greys / … Push one and every auto-colored item (each plot_line takes the next
// color) and heatmap inside the scope draws from it.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/colormaps_and_style.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/colormaps_and_style.das
// =============================================================================

let ROWS = 12
let COLS = 16
let SERIES = 6

var g_ctx : ImPlotContext?
var g_heat : array<double>
var g_series : array<array<double>>

[export]
def init() {
    harness_init("dasImguiImplot — colormaps_and_style", 1280, 760)
    g_ctx = implot::CreateContext()
    // A smooth 2D gradient (row-major, ROWS*COLS), values in [0,1].
    g_heat <- [for (idx in range(ROWS * COLS));
               double(sin(float(idx / COLS) * 0.5f) * cos(float(idx % COLS) * 0.4f)) * 0.5lf + 0.5lf]
    // SERIES sine waves at increasing phase — each plot_line auto-takes the next color.
    g_series |> reserve(SERIES)
    for (k in range(SERIES)) {
        var s <- [for (i in range(100)); double(sin(float(i) * 0.1f + float(k) * 0.6f))]
        g_series |> emplace(s)
    }
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1240.0, 720.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "colormaps", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("Push a colormap; items + heatmaps sample from it. colormap_scale draws the colorbar.")
        // Heatmap colored by Viridis, with its matching colorbar on the same line.
        with_colormap(ImPlotColormap.Viridis) {
            plot(HEAT, (title = "heatmap (Viridis)", size = float2(560.0f, 480.0f),
                        flags = ImPlotFlags.None)) {
                setup_axes("col", "row")
                plot_heatmap("vals", g_heat, ROWS, COLS, 0.0lf, 1.0lf, "")
            }
            same_line()
            colormap_scale("scale", 0.0lf, 1.0lf, ImPlotColormap.Viridis, float2(80.0f, 480.0f))
        }
        same_line()
        // Six sine series auto-colored by the Spectral colormap.
        with_colormap(ImPlotColormap.Spectral) {
            plot(LINES, (title = "auto-colored series (Spectral)", size = float2(-1.0f, 480.0f),
                         flags = ImPlotFlags.None)) {
                setup_axes_limits(0.0lf, 100.0lf, -1.2lf, 1.2lf)
                for (k in range(SERIES)) {
                    plot_line("series {k}", g_series[k])
                }
            }
        }
    }

    harness_end_frame()
}

[export]
def shutdown() {
    if (g_ctx != null) {
        DestroyContext(g_ctx)
    }
    harness_shutdown()
}

[export]
def main() {
    init()
    while (!exit_requested()) {
        update()
    }
    shutdown()
}
