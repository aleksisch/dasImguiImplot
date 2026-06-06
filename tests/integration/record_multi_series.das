options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record multi_series.apng - several styled series in one plot (sine / cosine
//! lines + a scatter), a second plot of integer bars, and the new interaction for this
//! tutorial: the LEGEND TOGGLE. Click a series' legend entry to hide it, click again to
//! show it. Voiced and self-verifying - each toggle must flip the series' `shown` flag
//! (record_check on wait_for_series_shown), so a no-op aborts at teardown. The headless
//! regression is test_multi_series.das.

let PLOT = "PLOT_WIN/WAVES"
let BARS = "PLOT_WIN/BARS"
let SERIES = "cos"
let LEAD_MS = 800u

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
    with_implot_recording_app("examples/tutorial/multi_series.das", "multi_series.apng", 45) $(app) {
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
        record_check_rendered(app, BARS, true)
        say(app, "several series, styled per item", PLOT,
            [voice = "This plot holds several series at once. Sine and co-sine as lines, and a scatter of sample points, each with its own style. A second plot below shows integer bars."])

        // ---- Beat 2: legend toggle - hide ----
        let d_hide = say_begin(app, "click a legend entry to hide", PLOT,
            [voice = "Every series has a legend entry. Click one to hide that series. Here the co-sine curve disappears."])
        let t_hide = ref_time_ticks()
        sleep(LEAD_MS)
        legend_toggle(s, SERIES)
        record_check(app, "{SERIES} hidden after legend click", wait_for_series_shown(s, SERIES, false) != null)
        hold_remainder(d_hide, t_hide)

        // ---- Beat 3: legend toggle - show ----
        let d_show = say_begin(app, "click again to show", PLOT,
            [voice = "Click the same entry again and the series comes right back."])
        let t_show = ref_time_ticks()
        sleep(LEAD_MS)
        legend_toggle(s, SERIES)
        record_check(app, "{SERIES} shown after second legend click", wait_for_series_shown(s, SERIES, true) != null)
        hold_remainder(d_show, t_show)
    }
}
