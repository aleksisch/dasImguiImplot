options gen2

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: heatmap_histogram — the two statistical 2D / distribution items.
//
//   plot_heatmap(id, values, rows, cols, lo, hi, fmt)  — a rows×cols grid (row-major)
//       mapped through the active colormap. lo==hi auto-scales; fmt="" hides labels.
//   histogram(id, values, bins)                        — bin a sample array into a
//       1D histogram; returns the largest bin count. `bins` is a count or an
//       ImPlotBin method (Sturges / Sqrt / Rice / Scott) cast to int.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/heatmap_histogram.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/heatmap_histogram.das
// =============================================================================

let ROWS = 14
let COLS = 18
let NSAMP = 600

var g_ctx : ImPlotContext?
var g_heat : array<double>
var g_samples : array<double>

[export]
def init() {
    harness_init("dasImguiImplot — heatmap_histogram", 1280, 720)
    g_ctx = implot::CreateContext()
    // A smooth 2D gradient (row-major, ROWS*COLS).
    g_heat <- [for (idx in range(ROWS * COLS));
               double(sin(float(idx / COLS) * 0.45f) * cos(float(idx % COLS) * 0.35f))]
    // A roughly bell-shaped sample set (sum of sines spreads values around 0).
    g_samples <- [for (i in range(NSAMP));
                  double(sin(float(i) * 1.3f) + sin(float(i) * 0.7f) + sin(float(i) * 2.1f))]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1240.0, 680.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "heatmap & histogram", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("plot_heatmap maps a grid through the colormap; histogram bins a sample array.")
        plot(HEAT, (title = "heatmap", size = float2(560.0f, 560.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("col", "row")
            plot_heatmap("vals", g_heat, ROWS, COLS, 0.0lf, 0.0lf, "")
        }
        same_line()
        plot(HIST, (title = "histogram", size = float2(-1.0f, 560.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("value", "count")
            histogram("samples", g_samples, int(ImPlotBin.Sturges))
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
