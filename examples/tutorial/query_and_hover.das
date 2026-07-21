options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math
require strings

// =============================================================================
// TUTORIAL: query_and_hover — read the cursor's plot position live and annotate it.
//
//   IsPlotHovered()                       — is the cursor over the plot area?
//   GetPlotMousePos(ImAxis.X1, ImAxis.Y1) — the cursor in DATA coords (valid in-scope).
//   plot_inf_lines(id, [x])               — a vertical reference line at data-x.
//   plot_text(text, x, y, pix_offset)     — a label anchored at a data point.
//
// The v2 `plot` scope ALSO serializes hovered + mouse-plot-pos into its snapshot,
// so a headless test can move the synthetic cursor onto the plot and assert on them.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/query_and_hover.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/query_and_hover.das
// =============================================================================

let N = 100

var g_ctx : ImPlotContext?
var g_wave : array<double>
var g_cursor_x : array<double>   // 1-element, reused each frame for the crosshair

[export]
def init() {
    harness_init("dasImguiImplot — query_and_hover", 1100, 720)
    g_ctx = implot::CreateContext()
    g_wave <- [for (i in range(N)); double(sin(float(i) * 0.12f)) * 0.9lf]
    g_cursor_x <- [0.0lf]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 680.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "query & hover", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("Hover the plot: it reads GetPlotMousePos live and annotates the cursor.")
        plot(CHART, (title = "hover me", size = float2(-1.0f, 600.0f),
                     flags = ImPlotFlags.None)) {
            setup_axes("x", "y")
            setup_axes_limits(0.0lf, double(N), -1.2lf, 1.2lf)
            next_line_style(float4(0.40f, 0.70f, 1.00f, 1.00f), 2.0f)
            plot_line("signal", g_wave)
            // Live query: while hovered, draw a crosshair + label at the cursor.
            if (IsPlotHovered()) {
                let mp = GetPlotMousePos(ImAxis.X1, ImAxis.Y1)
                g_cursor_x[0] = mp.x
                next_line_style(float4(1.00f, 1.00f, 1.00f, 0.50f), 1.0f)
                plot_inf_lines("cursor", g_cursor_x)
                plot_text("({mp.x:.1f}, {mp.y:.2f})", mp.x, mp.y, float2(10.0f, 10.0f))
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
