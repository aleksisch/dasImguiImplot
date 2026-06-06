options gen2

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
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
// state shows up under the IDENT in `imgui_snapshot`. Built on the dasImgui
// harness, so it runs standalone (windowed), headless (--headless), and live.
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
    harness_init("dasImguiImplot — multi_series", 1280, 860)
    g_ctx = implot::CreateContext()
    g_sin <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    g_cos <- [for (i in range(200)); double(cos(float(i) * 0.05f))]
    g_pts_x <- [for (i in range(20)); double(i) * 10.0lf]
    g_pts_y <- [for (i in range(20)); double(sin(float(i) * 0.5f)) * 0.8lf]
    g_bars <- [for (i in range(10)); i % 5]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1240.0, 820.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "multi series", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("v2 plot scope: snapshot-registered, multi-type items, per-item styling.")
        plot(WAVES, (title = "waves", size = float2(-1.0f, 480.0f), flags = ImPlotFlags.None)) {
            setup_axes("sample", "value")
            setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
            next_line_style(float4(0.30f, 0.70f, 1.00f, 1.00f), 2.0f)
            plot_line("sin", g_sin)
            plot_line("cos", g_cos)
            next_marker_style(ImPlotMarker.Circle, 4.0f)
            plot_scatter("samples", g_pts_x, g_pts_y)
        }
        plot(BARS, (title = "bars (int data)", size = float2(-1.0f, 240.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("bucket", "count")
            plot_bars("counts", g_bars)
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
