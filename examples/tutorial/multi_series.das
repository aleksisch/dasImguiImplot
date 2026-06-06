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
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: multi_series — the v2 `plot` snapshot scope + multi-type items.
//
//   plot(IDENT, (title, size, flags)) { ... }  — v2 RAII plot scope that ALSO
//       serializes its per-frame state (geometry, axis limits, hovered,
//       mouse-plot-pos) into the dasImgui snapshot rail, so a test/playwright
//       layer can assert on it. EndPlot can't be skipped.
//   setup_axes / setup_axes_limits             — label + fix the visible range.
//   next_line_style / next_marker_style        — style the NEXT item.
//   plot_line / plot_scatter / plot_bars       — OR-typed: float | double | int.
//
// vs v1's `with_plot`, the v2 `plot` is a snapshot-registered container — its
// state shows up under the IDENT in `imgui_snapshot`.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/multi_series.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/multi_series.das
// =============================================================================

var g_ctx : ImPlotContext?
var g_sin : array<double>
var g_cos : array<double>
var g_pts_x : array<double>
var g_pts_y : array<double>
var g_bars : array<int>

[export]
def init() {
    live_create_window("dasImguiImplot — multi_series", 900, 640)
    live_imgui_init(live_window)
    var io & = unsafe(GetIO())
    io.FontGlobalScale = 1.4
    g_ctx = implot::CreateContext()
    g_sin <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    g_cos <- [for (i in range(200)); double(cos(float(i) * 0.05f))]
    g_pts_x <- [for (i in range(20)); double(i) * 10.0lf]
    g_pts_y <- [for (i in range(20)); double(sin(float(i) * 0.5f)) * 0.8lf]
    g_bars <- [for (i in range(10)); i % 5]
}

[export]
def update() {
    if (!live_begin_frame()) return
    begin_frame()
    ImGui_ImplOpenGL3_NewFrame()
    ImGui_ImplGlfw_NewFrame()
    NewFrame()

    SetNextWindowPos(ImVec2(20.0f, 20.0f), ImGuiCond.Always)
    SetNextWindowSize(ImVec2(860.0f, 600.0f), ImGuiCond.Always)
    window(PLOT_WIN, (text = "multi series", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("v2 plot scope: snapshot-registered, multi-type items, per-item styling.")
        plot(WAVES, (title = "waves", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
            setup_axes("sample", "value")
            setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
            next_line_style(float4(0.30f, 0.70f, 1.00f, 1.00f), 2.0f)
            plot_line("sin", g_sin)
            plot_line("cos", g_cos)
            next_marker_style(ImPlotMarker.Circle, 4.0f)
            plot_scatter("samples", g_pts_x, g_pts_y)
        }
        plot(BARS, (title = "bars (int data)", size = float2(-1.0f, 200.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("bucket", "count")
            plot_bars("counts", g_bars)
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
