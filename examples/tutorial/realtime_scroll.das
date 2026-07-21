options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: realtime_scroll — a rolling buffer plotted against a moving x window.
//
//   Each frame appends a sample to a capped buffer (oldest dropped past MAX_POINTS)
//   and re-pins the x axis to [t - HISTORY, t] with ImPlotCond.Always, so the plot
//   scrolls as data streams in. The y axis stays locked.
//
//   setup_axes_limits(..., ImPlotCond.Always)  — re-apply the range EVERY frame
//                                                 (vs Once, which lets the user pan).
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/realtime_scroll.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/realtime_scroll.das
// =============================================================================

let HISTORY = 5.0lf     // seconds of data kept on screen
let DT = 0.1lf          // sim seconds advanced per frame
let MAX_POINTS = 70     // buffer cap (~ HISTORY / DT + margin)

var g_ctx : ImPlotContext?
var g_t : double = 0.0lf
var g_xs : array<double>
var g_fast : array<double>
var g_slow : array<double>

[export]
def init() {
    harness_init("dasImguiImplot — realtime_scroll", 1100, 720)
    g_ctx = implot::CreateContext()
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    // Advance the clock and append one sample of each signal.
    g_t += DT
    g_xs |> push(g_t)
    g_fast |> push(double(sin(float(g_t) * 2.0f)))
    g_slow |> push(double(sin(float(g_t) * 2.0f + 1.5f)) * 0.6lf)
    // Drop the oldest sample once the buffer is full — a fixed-width rolling window.
    if (length(g_xs) > MAX_POINTS) {
        g_xs |> erase(0)
        g_fast |> erase(0)
        g_slow |> erase(0)
    }

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1060.0, 680.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "realtime", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("A rolling buffer: each frame appends a sample and the x axis is pinned to [t-HISTORY, t].")
        plot(SCROLL, (title = "scrolling signals", size = float2(-1.0f, 600.0f),
                      flags = ImPlotFlags.None)) {
            setup_axes("time (s)", "value")
            // Re-pin the x window every frame so it scrolls; lock y.
            setup_axes_limits(g_t - HISTORY, g_t, -1.2lf, 1.2lf, ImPlotCond.Always)
            plot_line("fast", g_xs, g_fast)
            plot_line("slow", g_xs, g_slow)
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
