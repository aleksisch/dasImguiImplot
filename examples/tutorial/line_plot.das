options gen2

require imgui
require imgui_app
require glfw/glfw_boost
require opengl/opengl_boost
require live/glfw_live
require live/live_api
require live/live_commands
require live/live_vars
require live/opengl_live
require live_host
require imgui/imgui_live
require imgui/imgui_boost_runtime
require imgui/imgui_boost_v2
require imgui/imgui_widgets_builtin
require imgui/imgui_containers_builtin
require imgui/imgui_implot_boost
require implot
require math

// =============================================================================
// TUTORIAL: line_plot — the simplest ImPlot chart.
//
//   with_plot(TITLE, size) { ... }   — RAII plot scope; EndPlot can't be skipped.
//   setup_axes(x, y)                 — label the axes.
//   setup_axes_limits(...)           — fix the visible data range.
//   plot_line(LABEL, ys)             — draw a y-series (x = sample index).
//   plot_line(LABEL, xs, ys)         — or an explicit x/y series.
//
// The ImPlot context is created once after the ImGui context (init) and destroyed
// at shutdown. ImPlot shares dasImgui's ImGui context — nothing else to wire up.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/line_plot.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/line_plot.das
// =============================================================================

var g_ctx : ImPlotContext?
var g_sin : array<double>
var g_cos : array<double>

[export]
def init() {
    live_create_window("dasImguiImplot — line_plot", 800, 600)
    live_imgui_init(live_window)
    var io & = unsafe(GetIO())
    io.FontGlobalScale = 1.4
    g_ctx = implot::CreateContext()
    g_sin <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    g_cos <- [for (i in range(200)); double(cos(float(i) * 0.05f))]
}

[export]
def update() {
    if (!live_begin_frame()) return
    begin_frame()
    ImGui_ImplOpenGL3_NewFrame()
    ImGui_ImplGlfw_NewFrame()
    NewFrame()

    SetNextWindowPos(ImVec2(20.0f, 20.0f), ImGuiCond.Always)
    SetNextWindowSize(ImVec2(760.0f, 560.0f), ImGuiCond.Always)
    window(PLOT_WIN, (text = "line plot", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("with_plot scopes the chart; each plot_line draws one series.")
        with_plot("waves", float2(-1.0f, -1.0f)) {
            setup_axes("sample", "value")
            setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
            plot_line("sin", g_sin)
            plot_line("cos", g_cos)
        }
    }

    end_of_frame()
    Render()
    var w, h : int
    live_get_framebuffer_size(w, h)
    glViewport(0, 0, w, h)
    glClearColor(0.10f, 0.10f, 0.12f, 1.0f)
    glClear(GL_COLOR_BUFFER_BIT)
    ImGui_ImplOpenGL3_RenderDrawData(GetDrawData())
    live_end_frame()
}

[export]
def shutdown() {
    if (g_ctx != null) {
        DestroyContext(g_ctx)
    }
    live_imgui_shutdown()
    live_destroy_window()
}

[export]
def main() {
    init()
    while (!exit_requested()) {
        update()
    }
    shutdown()
}
