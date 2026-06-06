options gen2

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

// Headless smoke for the v2 `plot` snapshot hook: render a plot with KNOWN axis
// limits, query imgui_snapshot, and assert the serialized payload matches.
// Run: daslang.exe -load_module .../dasImgui -load_module .../dasImguiImplot \
//        tests/integration/test_plot_snapshot.das -- --headless --headless-frames 12

[export]
def main : int {
    harness_init("implot snapshot smoke", 900, 640)
    var ctx = implot::CreateContext()
    let sin_data <- [for (i in range(200)); double(sin(float(i) * 0.05f))]
    var rc = 1
    var checked = false
    while (harness_begin_frame()) {
        harness_new_frame()
        window(W, (text = "snap", closable = false, flags = ImGuiWindowFlags.None)) {
            plot(WAVES, (title = "waves", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) {
                setup_axes("sample", "value")
                setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
                plot_line("sin", sin_data)
            }
        }
        harness_end_frame()
        if (!checked && harness_frame_count() >= 4) {
            checked = true
            var snap = imgui_snapshot(null)
            // The plot is nested under window W, so the snapshot path key is "W/WAVES".
            let key = "W/WAVES"
            let x_min = widget_payload_field(snap, key, "x_min") ?? 9.0e9lf
            let x_max = widget_payload_field(snap, key, "x_max") ?? 9.0e9lf
            let y_min = widget_payload_field(snap, key, "y_min") ?? 9.0e9lf
            let y_max = widget_payload_field(snap, key, "y_max") ?? 9.0e9lf
            let visible = widget_payload_field(snap, key, "visible") ?? false
            let ok = (abs(x_min - 0.0lf) < 1.0e-6lf && abs(x_max - 200.0lf) < 1.0e-6lf &&
                      abs(y_min + 1.5lf) < 1.0e-6lf && abs(y_max - 1.5lf) < 1.0e-6lf && visible)
            if (ok) {
                print("PASS: {key} payload axis limits = x[{x_min},{x_max}] y[{y_min},{y_max}] visible={visible}\n")
                rc = 0
            } else {
                print("FAIL: {key} x[{x_min},{x_max}] y[{y_min},{y_max}] visible={visible}\n")
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
