options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require implot
require daslib/json public
require daslib/json_boost public

//! Driver: record realtime_scroll.apng - a streaming chart whose x window is pinned to
//! [t-HISTORY, t] with ImPlotCond.Always and re-applied every frame, so it auto-scrolls as
//! samples stream in (no input - the animation IS the subject). Voiced and self-verifying:
//! the plot must render, then over the narration window the x axis must actually advance
//! (x_min climbs by a clear margin), so a frozen / non-streaming plot aborts at teardown.
//! The headless regression is test_realtime_scroll.das.

let SCROLL = "PLOT_WIN/SCROLL"
let SCROLL_MARGIN = 2.0lf   // x_min must advance at least this far over the narration (data units)

// Hold a beat's caption for the remainder of its voice dwell, measuring real elapsed
// work so the next say_begin can't fire early and overlap the voice. For this tutorial the
// hold doubles as the observation window: the plot keeps streaming while the caption holds.
def hold_remainder(dwell : uint; t0 : int64) {
    let elapsed = uint(get_time_usec(t0) / 1000)
    if (dwell > elapsed) {
        sleep(dwell - elapsed)
    }
}

[export]
def main {
    with_implot_recording_app("examples/tutorial/realtime_scroll.das", "realtime_scroll.apng", 45) $(app) {
        let s = implot_open(app, SCROLL)
        var snap = wait_for_widget(app, SCROLL, 15.0f)
        if (snap == null) {
            panic("{SCROLL} never rendered - wrong app running?")
        }
        let center = plot_center(snap, s)

        // ---- Beat 1: the streaming chart ----
        move_to(app, center, 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, SCROLL, true)
        say(app, "a streaming chart", SCROLL,
            [voice = "This is a streaming chart. Every frame appends a new sample, and the x axis is pinned to a fixed five second window that ends at now."])

        // ---- Beat 2: watch the window scroll ----
        // No gesture - the animation is the subject. Capture x_min, hold the caption for the
        // voice dwell (the streaming runs throughout), then assert the window advanced.
        let x0 = plot_axis_limits(snapshot(app), s).x_min
        let d_scroll = say_begin(app, "the window scrolls with time", SCROLL,
            [voice = "Watch it scroll. As time advances the window slides to the right. New samples push in on the right while the oldest ones drop off the left."])
        let t_scroll = ref_time_ticks()
        hold_remainder(d_scroll, t_scroll)
        let x1 = plot_axis_limits(snapshot(app), s).x_min
        record_check(app, "x window scrolled forward (x_min advanced over the narration)",
                     x1 > x0 + SCROLL_MARGIN)
    }
}
