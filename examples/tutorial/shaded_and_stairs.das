options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot
require math

// =============================================================================
// TUTORIAL: shaded_and_stairs — filled areas and step plots.
//
//   plot_shaded_between(id, xs, lo, hi)  — fill the area BETWEEN two y series
//                                          (a confidence / envelope band).
//   plot_shaded(id, values, yref)        — fill the area between a series and a
//                                          horizontal baseline yref (default 0).
//   plot_stairs(id, values)              — a step plot (sample-and-hold).
//   next_fill_style / next_line_style    — color the NEXT shaded / line item.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/shaded_and_stairs.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/shaded_and_stairs.das
// =============================================================================

let N = 120
let STEPS = 16

var g_ctx : ImPlotContext?
var g_x : array<double>        // shared x for the band
var g_mid : array<double>      // mean curve
var g_lo : array<double>       // band lower edge
var g_hi : array<double>       // band upper edge
var g_steps : array<double>    // coarse step levels

[export]
def init() {
    harness_init("dasImguiImplot — shaded_and_stairs", 1280, 860)
    g_ctx = implot::CreateContext()
    g_x   <- [for (i in range(N)); double(i)]
    g_mid <- [for (i in range(N)); double(sin(float(i) * 0.08f))]
    // A band whose width grows with x, to show plot_shaded_between clearly.
    g_lo  <- [for (i in range(N)); double(sin(float(i) * 0.08f)) - (0.15lf + double(i) / double(N) * 0.4lf)]
    g_hi  <- [for (i in range(N)); double(sin(float(i) * 0.08f)) + (0.15lf + double(i) / double(N) * 0.4lf)]
    g_steps <- [for (i in range(STEPS)); double((i * 7) % 5)]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1240.0, 820.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "shaded & stairs", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("plot_shaded_between draws a band; plot_shaded fills to a baseline; plot_stairs steps.")
        // A confidence band (area between lo and hi) with the mean line on top.
        plot(BAND, (title = "confidence band", size = float2(-1.0f, 420.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("x", "value")
            setup_axes_limits(0.0lf, double(N), -1.6lf, 1.6lf)
            next_fill_style(float4(0.30f, 0.65f, 1.00f, 0.35f))
            plot_shaded_between("band", g_x, g_lo, g_hi)
            next_line_style(float4(0.20f, 0.55f, 1.00f, 1.00f), 2.0f)
            plot_line("mean", g_x, g_mid)
        }
        // A step series with the area under it filled.
        plot(STAIRS, (title = "stairs + fill", size = float2(-1.0f, 300.0f),
                      flags = ImPlotFlags.None)) {
            setup_axes("bucket", "level")
            setup_axes_limits(0.0lf, double(STEPS), 0.0lf, 5.0lf)
            next_fill_style(float4(1.00f, 0.70f, 0.25f, 0.30f))
            plot_shaded("fill", g_steps)
            next_line_style(float4(1.00f, 0.55f, 0.10f, 1.00f), 2.0f)
            plot_stairs("steps", g_steps)
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
