options gen2

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: drag_tools — interactive draggable handles inside a v2 `plot` scope.
//
//   drag_point(state, id, col)   — a draggable (x,y) point.
//   drag_line_x(state, id, col)  — a draggable vertical line (e.g. a threshold).
//   drag_rect(state, id, col)    — a draggable rectangle region (e.g. an ROI).
//
// Each tool owns a PERSISTENT state struct (a global): its value updates in place
// as you drag, and serializes into the snapshot under `<plot>/<id>` — so a test can
// read the handle's bbox, synth-drag it, and assert the bound value moved. Built on
// the dasImgui harness: runs standalone (windowed), headless (--headless), and live.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/drag_tools.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/drag_tools.das
// =============================================================================

var g_ctx : ImPlotContext?
var g_sin : array<double>
var g_pt : DragPointState
var g_thresh : DragLineState
var g_roi : DragRectState

[export]
def init() {
    harness_init("dasImguiImplot — drag_tools", 1100, 760)
    g_ctx = implot::CreateContext()
    g_sin <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    // Keep the three handles spatially separated so their grab rects never overlap
    // (an overlapping grab rect steals the active-id and the wrong tool moves).
    g_pt = DragPointState(x = 150.0lf, y = 0.0lf, held = false)
    g_thresh = DragLineState(value = 100.0lf, held = false)
    g_roi = DragRectState(x_min = 20.0lf, y_min = -0.9lf, x_max = 70.0lf, y_max = -0.3lf,
                          held = false)
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 720.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "drag tools", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("Drag the yellow point, the green threshold line, or the magenta ROI box.")
        plot(WAVES, (title = "interactive", size = float2(-1.0f, 620.0f),
                     flags = ImPlotFlags.None)) {
            setup_axes("sample", "value")
            setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
            plot_line("sin", g_sin)
            // Drawn back-to-front so the point sits on top and grabs first.
            drag_rect(g_roi, "roi", float4(1.0f, 0.0f, 1.0f, 0.35f))
            drag_line_x(g_thresh, "thresh", float4(0.2f, 1.0f, 0.3f, 1.0f), 2.0f)
            drag_point(g_pt, "p0", float4(1.0f, 0.9f, 0.1f, 1.0f), 6.0f)
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
