options gen2

require imgui
require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_implot_boost
require implot
require math

// Headless smoke for the v1 (imgui_implot_boost) RAII scope wrappers. v1 has no
// snapshot hook, so there is nothing to query — instead this exercises every paired
// scope (Begin/End and Push/Pop) for several frames and passes iff it renders
// crash-free: an unbalanced Push/Pop or a missed End would trip an ImGui assert.
// Run: daslang.exe -load_module .../dasImgui -load_module .../dasImguiImplot \
//        tests/integration/test_v1_scopes.das -- --headless --headless-frames 12

[export]
def main : int {
    harness_init("implot v1 scopes smoke", 900, 700)
    var ctx = implot::CreateContext()
    let sin_data <- [for (i in range(120)); double(sin(float(i) * 0.05f))]
    let cos_data <- [for (i in range(120)); double(cos(float(i) * 0.05f))]
    var rc = 1
    var done = false
    while (harness_begin_frame()) {
        harness_new_frame()
        window(W, (text = "v1 scopes", closable = false, flags = ImGuiWindowFlags.None)) {
            // Push/Pop style scopes wrap a group of axis-aligned plots (Begin/End scope).
            with_style_var(ImPlotStyleVar.LineWeight, 2.0f) {
                with_aligned_plots("aligned") {
                    with_plot("p1", float2(-1.0f, 280.0f), ImPlotFlags.None) {
                        setup_axes("x", "y")
                        with_colormap(ImPlotColormap.Viridis) {
                            plot_line("sin", sin_data)
                        }
                        with_style_color(ImPlotCol.Line, float4(1.0f, 0.5f, 0.2f, 1.0f)) {
                            plot_line("cos", cos_data)
                        }
                        with_plot_clip_rect() {
                            plot_scatter("pts", sin_data)
                        }
                        // Conditional scopes: Begin returns false headless (no input), so the
                        // body is skipped and End is correctly not called — exercises the guard.
                        with_legend_popup("##leg") {}
                        with_drag_drop_source_item("src") {}
                        with_drag_drop_source_plot() {}
                        with_drag_drop_source_axis(ImAxis.X1) {}
                        with_drag_drop_target_plot() {}
                        with_drag_drop_target_axis(ImAxis.X1) {}
                        with_drag_drop_target_legend() {}
                    }
                    with_plot("p2", float2(-1.0f, 280.0f), ImPlotFlags.None) {
                        setup_axes("x", "y")
                        plot_bars("bars", cos_data)
                    }
                }
            }
        }
        harness_end_frame()
        if (!done && harness_frame_count() >= 6) {
            done = true
            print("PASS: v1 scope wrappers rendered crash-free for {harness_frame_count()} frames\n")
            rc = 0
            request_exit()
        }
    }
    harness_shutdown()
    unsafe {
        if (ctx != null) {
            DestroyContext(ctx)
        }
    }
    return rc
}
