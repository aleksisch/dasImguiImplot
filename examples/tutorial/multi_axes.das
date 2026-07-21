options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: multi_axes — two y axes with different scales on one plot.
//
//   setup_axis(ImAxis.Y2, label, ImPlotAxisFlags.AuxDefault)  — enable a 2nd y axis.
//   setup_axis_limits(ImAxis.Y2, ...)                         — range it independently.
//   set_axis(ImAxis.Y2)                                       — route the NEXT items to it.
//
// Temperature (0..30) lives on the left Y1; pressure (~1000 hPa) on the right Y2 —
// wildly different ranges that would be unreadable sharing one axis.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/multi_axes.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/multi_axes.das
// =============================================================================

let N = 100

var g_ctx : ImPlotContext?
var g_temp : array<double>      // small range, Y1
var g_press : array<double>     // large range, Y2

[export]
def init() {
    harness_init("dasImguiImplot — multi_axes", 1100, 720)
    g_ctx = implot::CreateContext()
    g_temp  <- [for (i in range(N)); 17.0lf + 6.0lf * double(sin(float(i) * 0.10f))]
    g_press <- [for (i in range(N)); 1000.0lf + 30.0lf * double(cos(float(i) * 0.07f))]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 680.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "multi axes", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("Temperature on Y1 (left), pressure on Y2 (right). set_axis routes an item to Y2.")
        plot(CHART, (title = "weather", size = float2(-1.0f, 600.0f),
                     flags = ImPlotFlags.None)) {
            setup_axes("hour", "temp (C)")
            setup_axis(ImAxis.Y2, "pressure (hPa)", ImPlotAxisFlags.AuxDefault)
            setup_axis_limits(ImAxis.X1, 0.0lf, double(N))
            setup_axis_limits(ImAxis.Y1, 0.0lf, 30.0lf)
            setup_axis_limits(ImAxis.Y2, 950.0lf, 1050.0lf)
            // Temperature on the default Y1.
            next_line_style(float4(1.00f, 0.55f, 0.20f, 1.00f), 2.0f)
            plot_line("temp", g_temp)
            // Route the next item to Y2, then plot pressure against it.
            set_axis(ImAxis.Y2)
            next_line_style(float4(0.35f, 0.75f, 1.00f, 1.00f), 2.0f)
            plot_line("pressure", g_press)
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
