options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record line_plot.apng - the first chart, plus ImPlot's built-in view
//! navigation taught once for the whole series: PAN (left drag), ZOOM (scroll wheel),
//! FIT (double click). Voiced and self-verifying - each gesture must move the plot's
//! axis limits (record_check_changed on x_max), so a no-op aborts at teardown. The
//! headless regression is test_line_plot.das.

let PLOT = "PLOT_WIN/WAVES"
let LEAD_MS = 800u

def field_json(var snap : JsonValue?; ident : string; field : string) : string {
    return write_json(widget_payload_field(snap, ident, field))
}

// Pan needs a CONTINUOUS multi-waypoint drag: ImPlot integrates io.MouseDelta per
// frame, so a single from->to jump (what drag/drag_along post) does not pan. Walk the
// cursor across several waypoints with the button held.
def pan_drag(app : ImguiApp; from_pt : tuple<float; float>; to_pt : tuple<float; float>) {
    let steps = 6
    let dur = 140
    let endt = 120 + steps * dur
    var ev <- [
        JV((t_ms = 0,   kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 100, kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 120, kind = "button", button = 0, action = "press"))]
    reserve(ev, 3 + steps + 2)
    for (i in range(1, steps + 1)) {
        let f = float(i) / float(steps)
        ev |> push(JV((t_ms = 120 + i * dur, kind = "move",
                       x = from_pt._0 + (to_pt._0 - from_pt._0) * f,
                       y = from_pt._1 + (to_pt._1 - from_pt._1) * f)))
    }
    ev |> push(JV((t_ms = endt + 80,  kind = "button", button = 0, action = "release")))
    ev |> push(JV((t_ms = endt + 180, kind = "move", x = to_pt._0, y = to_pt._1)))
    post_command(app, "imgui_mouse_play", JV((events = ev)))
    wait_for_mouse_idle(app)
}

def scroll_zoom(app : ImguiApp; notches : int) {
    post_command(app, "imgui_mouse_scroll", JV((x = 0, y = notches)))
}

def double_click(app : ImguiApp; pt : tuple<float; float>) {
    var ev <- [
        JV((t_ms = 0,   kind = "move",   x = pt._0, y = pt._1)),
        JV((t_ms = 1,   kind = "move",   x = pt._0, y = pt._1)),
        JV((t_ms = 2,   kind = "button", button = 0, action = "press")),
        JV((t_ms = 40,  kind = "button", button = 0, action = "release")),
        JV((t_ms = 80,  kind = "button", button = 0, action = "press")),
        JV((t_ms = 120, kind = "button", button = 0, action = "release")),
        JV((t_ms = 160, kind = "move", x = pt._0, y = pt._1))]
    post_command(app, "imgui_mouse_play", JV((events = ev)))
    wait_for_mouse_idle(app)
}

// Hold a beat's caption for the remainder of its voice dwell, measuring real elapsed
// work (gesture + verify) so the next say_begin can't fire early and overlap the voice.
def hold_remainder(dwell : uint; t0 : int64) {
    let elapsed = uint(get_time_usec(t0) / 1000)
    if (dwell > elapsed) {
        sleep(dwell - elapsed)
    }
}

[export]
def main {
    with_implot_recording_app("examples/tutorial/line_plot.das", "line_plot.apng", 50) $(app) {
        let s = implot_open(app, PLOT)
        var snap = wait_for_widget(app, PLOT, 15.0f)
        if (snap == null) {
            panic("{PLOT} never rendered - wrong app running?")
        }
        let center = plot_center(snap, s)
        let left = (center._0 - 200.0f, center._1)

        // ---- Beat 1: the chart ----
        move_to(app, center, 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, PLOT, true)
        say(app, "line plot: sine and cosine", PLOT,
            [voice = "This is a line plot. Two series, sine and co-sine, drawn across two hundred samples."])

        // ---- Beat 2: pan (left drag) ----
        let before_pan = field_json(snapshot(app), PLOT, "x_max")
        let d_pan = say_begin(app, "drag to pan", PLOT,
            [voice = "Hold the left button inside the plot and drag to pan. The whole view slides with the cursor."])
        let t_pan = ref_time_ticks()
        sleep(LEAD_MS)
        pan_drag(app, center, left)
        record_check_changed(app, PLOT, "x_max", before_pan)
        hold_remainder(d_pan, t_pan)

        // ---- Beat 3: zoom (scroll wheel) ----
        let before_zoom = field_json(snapshot(app), PLOT, "x_max")
        let d_zoom = say_begin(app, "scroll to zoom", PLOT,
            [voice = "Scroll the wheel over the plot to zoom. It zooms in around the cursor, toward the data under it."])
        let t_zoom = ref_time_ticks()
        sleep(LEAD_MS)
        move_to(app, center, 300)
        wait_for_mouse_idle(app)
        for (_b in range(3)) {
            scroll_zoom(app, 2)
            sleep(260u)
        }
        record_check_changed(app, PLOT, "x_max", before_zoom)
        hold_remainder(d_zoom, t_zoom)

        // ---- Beat 4: fit (double click) ----
        let before_fit = field_json(snapshot(app), PLOT, "x_max")
        let d_fit = say_begin(app, "double click to fit", PLOT,
            [voice = "Double click anywhere in the plot to fit the axes back to the data. One gesture resets the view."])
        let t_fit = ref_time_ticks()
        sleep(LEAD_MS)
        double_click(app, center)
        record_check_changed(app, PLOT, "x_max", before_fit)
        hold_remainder(d_fit, t_fit)
    }
}
