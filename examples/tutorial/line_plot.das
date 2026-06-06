options gen2

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost
require implot
require math

// =============================================================================
// TUTORIAL: line_plot — the simplest ImPlot chart (v1 thin wrapper).
//
//   with_plot(TITLE, size) { ... }   — RAII plot scope; EndPlot can't be skipped.
//   setup_axes(x, y)                 — label the axes.
//   setup_axes_limits(...)           — fix the visible data range.
//   plot_line(LABEL, ys)             — draw a y-series (x = sample index).
//   plot_line(LABEL, xs, ys)         — or an explicit x/y series.
//
// The ImPlot context is created once after the ImGui context (init) and destroyed
// at shutdown. ImPlot shares dasImgui's ImGui context — nothing else to wire up.
// Built on the dasImgui harness: runs standalone (windowed), headless, and live.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/line_plot.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/line_plot.das
// =============================================================================

var g_ctx : ImPlotContext?
var g_sin : array<double>
var g_cos : array<double>

[export]
def init() {
    harness_init("dasImguiImplot — line_plot", 1100, 760)
    g_ctx = implot::CreateContext()
    g_sin <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    g_cos <- [for (i in range(200)); double(cos(float(i) * 0.05f))]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 720.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "line plot", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("with_plot scopes the chart; each plot_line draws one series.")
        with_plot("waves", float2(-1.0f, 620.0f)) {
            setup_axes("sample", "value")
            setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
            plot_line("sin", g_sin)
            plot_line("cos", g_cos)
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
