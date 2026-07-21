options gen2
options _comment_hygiene = true
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record query_and_hover.apng - a plot that reads the cursor LIVE. While the
//! pointer is over the plot the example draws a vertical crosshair at the cursor x and a
//! (x, y) label in DATA coords (GetPlotMousePos). The interaction this tutorial teaches
//! is the HOVER: move the cursor and the readout follows, every frame. Driven with a REAL
//! synthetic cursor glide, voiced and self-verifying - each beat waits for `hovered` to
//! flip true, then asserts GetPlotMousePos resolved into the band the cursor was aimed at
//! (and that it moved between beats), so a dead hover or a frozen readout aborts at
//! teardown. The headless regression is test_query_and_hover.das.

let CHART = "PLOT_WIN/CHART"

[export]
def main {
    with_implot_recording_app("examples/tutorial/query_and_hover.das", "query_and_hover.apng", 45) $(app) {
        let s = implot_open(app, CHART)
        var snap = wait_for_widget(app, CHART, 15.0f)
        if (snap == null) {
            panic("{CHART} never rendered - wrong app running?")
        }
        // Data area geometry (GetPlotPos / GetPlotSize) - maps screen fractions to data x.
        let p = plot_payload(snap, s)
        let px = p?["pos"]?["x"] ?? 0.0f
        let py = p?["pos"]?["y"] ?? 0.0f
        let pw = p?["plot_size"]?["x"] ?? 0.0f
        let ph = p?["plot_size"]?["y"] ?? 0.0f

        // ---- Beat 1: the live readout ----
        move_to(app, (px + pw * 0.5f, py + ph * 0.5f), 700)
        var hc = wait_for_hovered(s, true)
        record_check(app, "the plot reports hovered while the cursor is over it", hc != null)
        say(app, "hover to read the plot", CHART,
            [voice = "This plot reads the cursor live. While you hover over it, it draws a crosshair at the cursor and labels its position in data coordinates."])

        // ---- Beat 2: the readout follows the cursor (glide to the left third) ----
        let d_l = say_begin(app, "the readout follows the cursor", CHART,
            [voice = "Move the cursor and the readout follows. Here, near the left, the label shows the x and y under the pointer, updated every frame."])
        let t_l = record_frame_count(app)
        move_to(app, (px + pw * 0.22f, py + ph * 0.42f), 900)
        wait_for_mouse_idle(app)
        var hl = wait_for_hovered(s, true)
        let mx_l = mouse_x(hl, s)
        record_check(app, "readout tracks the cursor near the left (x in [8,40], got {mx_l})",
                     mx_l >= 8.0lf && mx_l <= 40.0lf)
        hold_remainder_content(app, d_l, t_l)

        // ---- Beat 3: read any point (glide across to the right third) ----
        let d_r = say_begin(app, "read any point", CHART,
            [voice = "Glide across to the right and the crosshair and the label track right along with it. You can read off the value at any point on the plot."])
        let t_r = record_frame_count(app)
        move_to(app, (px + pw * 0.74f, py + ph * 0.58f), 1100)
        wait_for_mouse_idle(app)
        var hr = wait_for_hovered(s, true)
        let mx_r = mouse_x(hr, s)
        record_check(app, "readout tracks the cursor near the right (x in [60,92], got {mx_r})",
                     mx_r >= 60.0lf && mx_r <= 92.0lf)
        record_check(app, "the readout moved right with the cursor (left {mx_l} < right {mx_r})",
                     mx_r > mx_l + 20.0lf)
        hold_remainder_content(app, d_r, t_r)
    }
}

def mouse_x(var snap : JsonValue?; s : PlotSession) : double {
    return plot_mouse_pos(snap, s)._0
}
