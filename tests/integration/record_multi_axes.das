options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require implot
require math
require daslib/json public
require daslib/json_boost public

//! Driver: record multi_axes.apng - one plot, two y axes with very different scales
//! (temperature 0..30 on the left Y1, pressure ~1000 on the right Y2). The interaction
//! this tutorial teaches is the INDEPENDENT-AXIS PAN: grab a single axis' gutter and drag
//! to pan ONLY that axis, while the other stays put - distinct from a plot-body pan that
//! moves every axis at once. Taught symmetrically (drag the left axis, then the right) to
//! drive the point home. Voiced and self-verifying - each drag must move its own axis'
//! range (wait_for_axis_limit_changed) AND leave the other within tolerance, so a no-op or
//! a both-axes pan aborts at teardown. The headless regression is test_multi_axes.das.

let PLOT = "PLOT_WIN/CHART"
let LEAD_MS = 800u
let HOLD_TOL = 1.0lf   // an untouched axis' range must not drift more than this (data units)

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
    with_implot_recording_app("examples/tutorial/multi_axes.das", "multi_axes.apng", 45) $(app) {
        let s = implot_open(app, PLOT)
        var snap = wait_for_widget(app, PLOT, 15.0f)
        if (snap == null) {
            panic("{PLOT} never rendered - wrong app running?")
        }
        let center = plot_center(snap, s)

        // ---- Beat 1: the chart ----
        move_to(app, center, 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, PLOT, true)
        say(app, "two y axes, two scales", PLOT,
            [voice = "This plot carries two y axes. Temperature on the left, from zero to thirty. Pressure on the right, near one thousand. Two very different scales side by side on one plot."])

        // ---- Beat 2: drag the LEFT axis (temperature / Y1) ----
        let b2_y1 = plot_axis_limit(snapshot(app), s, "y_max")
        let b2_y2 = plot_axis_limit(snapshot(app), s, "y2_max")
        let d_left = say_begin(app, "drag the left axis to pan temperature alone", PLOT,
            [voice = "Grab the left temperature axis and drag it. Only temperature pans. Pressure on the right does not move."])
        let t_left = ref_time_ticks()
        sleep(LEAD_MS)
        drag_axis(s, ImAxis.Y1, -110.0f)
        var dleft = wait_for_axis_limit_changed(s, "y_max", b2_y1)
        record_check(app, "temperature (Y1) panned by the left-axis drag", dleft != null)
        record_check(app, "pressure (Y2) held steady while Y1 dragged",
                     abs(plot_axis_limit(snapshot(app), s, "y2_max") - b2_y2) < HOLD_TOL)
        hold_remainder(d_left, t_left)

        // ---- Beat 3: drag the RIGHT axis (pressure / Y2) ----
        let b3_y1 = plot_axis_limit(snapshot(app), s, "y_max")
        let b3_y2 = plot_axis_limit(snapshot(app), s, "y2_max")
        let d_right = say_begin(app, "drag the right axis to pan pressure alone", PLOT,
            [voice = "Now the right pressure axis. Drag it, and only pressure pans. Temperature on the left stays put. Each axis moves on its own."])
        let t_right = ref_time_ticks()
        sleep(LEAD_MS)
        drag_axis(s, ImAxis.Y2, 120.0f)
        var dright = wait_for_axis_limit_changed(s, "y2_max", b3_y2)
        record_check(app, "pressure (Y2) panned by the right-axis drag", dright != null)
        record_check(app, "temperature (Y1) held steady while Y2 dragged",
                     abs(plot_axis_limit(snapshot(app), s, "y_max") - b3_y1) < HOLD_TOL)
        hold_remainder(d_right, t_right)
    }
}
