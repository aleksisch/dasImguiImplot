options gen2
options _comment_hygiene = true
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require math
require daslib/json public
require daslib/json_boost public

//! Driver: record subplots.apng - a 2x2 grid of plots (sin / cos / damped / bars), each cell
//! its own plot. The interaction this tutorial teaches is the BOX-SELECT ZOOM: right-drag a box
//! inside a cell to zoom into it. The grid uses ImPlotSubplotFlags.None (no linked axes), so the
//! point is that only the boxed cell zooms - the others stay put. Voiced and self-verifying: the
//! boxed cell's range must shrink (wait_for_axis_limit_changed on x_max) while a neighbour cell's
//! range is unchanged, so a no-op or a zoom that bled across cells aborts at teardown. The
//! headless regression is test_subplots.das.

let GRID = "PLOT_WIN/GRID"
let SIN = "PLOT_WIN/GRID/P_SIN"
let COS = "PLOT_WIN/GRID/P_COS"
let LEAD_MS = 800u
let HOLD_TOL = 0.5lf   // a non-boxed cell's range must not drift more than this (data units)

// Box-select zoom is a RIGHT-button drag (ImPlot's default Select binding): press inside the cell,
// drag a box, release -> the cell zooms to the box. Unlike a pan the box is press-corner to
// release-corner, not io.MouseDelta integrated; the waypoints just make the rubber band visible.
def box_zoom(app : ImguiApp; from_pt : tuple<float; float>; to_pt : tuple<float; float>) {
    let steps = 5
    let dur = 130
    let endt = 120 + steps * dur
    var ev <- [
        JV((t_ms = 0,   kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 100, kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 120, kind = "button", button = 1, action = "press"))]
    ev |> reserve(length(ev) + steps + 2)
    for (i in range(1, steps + 1)) {
        let f = float(i) / float(steps)
        ev |> push(JV((t_ms = 120 + i * dur, kind = "move",
                       x = from_pt._0 + (to_pt._0 - from_pt._0) * f,
                       y = from_pt._1 + (to_pt._1 - from_pt._1) * f)))
    }
    ev |> push(JV((t_ms = endt + 80,  kind = "button", button = 1, action = "release")))
    ev |> push(JV((t_ms = endt + 180, kind = "move", x = to_pt._0, y = to_pt._1)))
    post_command(app, "imgui_mouse_play", JV((events = ev)))
    wait_for_mouse_idle(app)
    unsafe { delete ev; }
}

[export]
def main {
    with_implot_recording_app("examples/tutorial/subplots.das", "subplots.apng", 45) $(app) {
        let grid = implot_open(app, GRID)
        let sin = implot_open(app, SIN)
        let cos = implot_open(app, COS)
        var snap = wait_for_widget(app, SIN, 15.0f)
        if (snap == null) {
            panic("{SIN} never rendered - wrong app running?")
        }
        let center = plot_center(snap, sin)

        // ---- Beat 1: the grid ----
        move_to(app, center, 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, SIN, true)
        record_check_rendered(app, COS, true)
        say(app, "four plots in one grid", SIN,
            [voice = "Subplots put several plots in one grid. Here a two by two grid of trig curves. Sine, co-sine, a damped wave, and a bar chart. Each cell is its own plot."])

        // ---- Beat 2: box-select zoom in one cell (right-drag) ----
        // Baselines + the box corners off ONE snapshot, so the pair is from a single frame.
        var b = snapshot(app)
        let sin_x0 = plot_axis_limit(b, sin, "x_max")
        let cos_x0 = plot_axis_limit(b, cos, "x_max")
        let sp = plot_payload(b, sin)
        let px = sp?["pos"]?["x"] ?? 0.0f
        let py = sp?["pos"]?["y"] ?? 0.0f
        let pw = sp?["plot_size"]?["x"] ?? 0.0f
        let ph = sp?["plot_size"]?["y"] ?? 0.0f
        let from_pt = (px + pw * 0.20f, py + ph * 0.25f)
        let to_pt = (px + pw * 0.75f, py + ph * 0.80f)
        let d_zoom = say_begin(app, "right drag a box to zoom one cell", SIN,
            [voice = "Right drag a box inside any cell to zoom into it. Because these cells are not linked, only that cell zooms. The others stay exactly where they were."])
        let t_zoom = record_frame_count(app)
        hold_content(app, LEAD_MS)
        box_zoom(app, from_pt, to_pt)
        var dz = wait_for_axis_limit_changed(sin, "x_max", sin_x0)
        record_check(app, "sin cell zoomed in by the box drag (x_max moved)", dz != null)
        // Independence: the neighbour cell's range is untouched, read on the same frame.
        record_check(app, "cos cell unchanged by the box zoom (cells are independent)",
                     abs(plot_axis_limit(dz, cos, "x_max") - cos_x0) < HOLD_TOL)
        hold_remainder_content(app, d_zoom, t_zoom)
    }
}
