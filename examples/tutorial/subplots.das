options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: subplots — a grid of linked plots sharing one region.
//
//   subplots(IDENT, rows, cols, size, flags) { ... }  — a rows×cols grid; each
//       `plot` inside fills the NEXT cell (the cell's size is managed by the grid,
//       so the per-plot size arg is ignored). Both the grid and every cell register
//       in the snapshot rail: the grid as IDENT, each cell nested under IDENT.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/subplots.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/subplots.das
// =============================================================================

let N = 100

var g_ctx : ImPlotContext?
var g_sin : array<double>
var g_cos : array<double>
var g_damp : array<double>
var g_bars : array<int>

[export]
def init() {
    harness_init("dasImguiImplot — subplots", 1100, 760)
    g_ctx = implot::CreateContext()
    g_sin  <- [for (i in range(N)); double(sin(float(i) * 0.12f))]
    g_cos  <- [for (i in range(N)); double(cos(float(i) * 0.12f))]
    g_damp <- [for (i in range(N)); double(sin(float(i) * 0.25f) * exp(-float(i) * 0.02f))]
    g_bars <- [for (i in range(12)); (i * 3) % 7]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 720.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "subplots", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("A 2x2 grid: each plot fills the next cell. The grid and every cell snapshot independently.")
        subplots(GRID, (title = "trig grid", rows = 2, cols = 2,
                        size = float2(-1.0f, 640.0f), flags = ImPlotSubplotFlags.None)) {
            plot(P_SIN, (title = "sin", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
                plot_line("sin", g_sin)
            }
            plot(P_COS, (title = "cos", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
                plot_line("cos", g_cos)
            }
            plot(P_DAMP, (title = "damped", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
                plot_line("damped", g_damp)
            }
            plot(P_BARS, (title = "bars", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
                plot_bars("bars", g_bars)
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
