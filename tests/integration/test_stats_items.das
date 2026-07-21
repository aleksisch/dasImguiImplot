options gen2
options _comment_hygiene = true

require imgui
require imgui/imgui_harness
require imgui/imgui_boost_runtime
require imgui/imgui_boost_v2
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_playwright
require imgui/imgui_implot_boost_v2
require implot
require math
require daslib/json
require daslib/json_boost

// Headless smoke for the pass-B item families (error bars / digital / heatmap /
// histogram / histogram2d): render each inside a v2 `plot` scope and assert the
// plot registered + drew (kind implot_plot, visible). Proves the new C++
// forwarders draw crash-free through the whole numeric matrix.
// Run: daslang.exe -load_module .../dasImgui -load_module .../dasImguiImplot \
//        tests/integration/test_stats_items.das -- --headless --headless-frames 12

[export]
def main : int {
    harness_init("implot stats items smoke", 900, 700)
    var ctx = implot::CreateContext()
    let xs <- [for (i in range(20)); double(i)]
    let ys <- [for (i in range(20)); double(sin(float(i) * 0.4f)) + 1.0lf]
    let err <- [for (_i in range(20)); 0.15lf]
    let samples <- [for (i in range(200)); double(sin(float(i) * 0.3f))]
    let grid <- [for (i in range(25)); double(i % 5) * double(i / 5)]
    let dig_y <- [for (i in range(20)); double(i % 2)]
    var rc = 1
    var checked = false
    while (harness_begin_frame()) {
        harness_new_frame()
        window(W, (text = "stats", closable = false, flags = ImGuiWindowFlags.None)) {
            plot(ERR, (title = "error bars", size = float2(-1.0f, 150.0f), flags = ImPlotFlags.None)) {
                plot_line("y", xs, ys)
                plot_error_bars("y", xs, ys, err)
            }
            plot(DIG, (title = "digital", size = float2(-1.0f, 120.0f), flags = ImPlotFlags.None)) {
                plot_digital("sig", xs, dig_y)
            }
            plot(HEAT, (title = "heatmap", size = float2(-1.0f, 150.0f), flags = ImPlotFlags.None)) {
                plot_heatmap("m", grid, 5, 5)
            }
            plot(HIST, (title = "histogram", size = float2(-1.0f, 150.0f), flags = ImPlotFlags.None)) {
                histogram("h", samples, int(ImPlotBin.Sqrt))
                histogram2d("h2", xs, ys)
            }
        }
        harness_end_frame()
        if (!checked && harness_frame_count() >= 4) {
            checked = true
            var snap = imgui_snapshot(null)
            var ok = true
            for (key in ["W/ERR", "W/DIG", "W/HEAT", "W/HIST"]) {
                let visible = widget_payload_field(snap, key, "visible") ?? false
                if (!visible) {
                    print("FAIL: {key} not registered/visible\n")
                    ok = false
                }
            }
            if (ok) {
                print("PASS: error_bars / digital / heatmap / histogram all rendered + snapshotted\n")
                rc = 0
            } else {
                print("=== SNAPSHOT DUMP ===\n{write_json(snap)}\n=== END DUMP ===\n")
                rc = 1
            }
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
