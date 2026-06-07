options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record bar_groups_and_pie.apng - the two CATEGORICAL items side by side: a
//! grouped bar chart (three series clustered into four quarters) and a pie chart (one
//! slice per labelled value). A display tour with one real interaction - the LEGEND
//! TOGGLE on the grouped bars: clicking a series hides it across EVERY group at once
//! (distinct from a single line series), then a second click restores it. Voiced and
//! self-verifying: the toggle must flip the series' `shown` flag both ways
//! (wait_for_series_shown), and both plots must render, so a no-op aborts at teardown.
//! The headless regression is test_bar_groups_and_pie.das.

let BARS = "PLOT_WIN/BARS"
let PIE = "PLOT_WIN/PIE"
let SERIES = "industrial"
let LEAD_MS = 800u

[export]
def main {
    with_implot_recording_app("examples/tutorial/bar_groups_and_pie.das", "bar_groups_and_pie.apng", 45) $(app) {
        let bars = implot_open(app, BARS)
        let pie = implot_open(app, PIE)
        var snap = wait_for_widget(app, BARS, 15.0f)
        if (snap == null) {
            panic("{BARS} never rendered - wrong app running?")
        }

        // ---- Beat 1: two categorical charts ----
        move_to(app, plot_center(snap, bars), 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, BARS, true)
        record_check_rendered(app, PIE, true)
        say(app, "two categorical charts", BARS,
            [voice = "Two categorical charts side by side. On the left, grouped bars: three series clustered into four quarters. On the right, a pie chart splitting a budget into slices."])

        // ---- Beat 2: legend toggle on the grouped bars (hide across all groups, then restore) ----
        let d_leg = say_begin(app, "toggle a series in the legend", BARS,
            [voice = "Each cluster shares one legend. Click a series to hide it across every group at once, then click again to bring it back."])
        let t_leg = record_frame_count(app)
        hold_content(app, LEAD_MS)
        legend_toggle(bars, SERIES)
        record_check(app, "{SERIES} hidden across all groups after the legend click",
                     wait_for_series_shown(bars, SERIES, false) != null)
        hold_content(app, 900u)   // dwell so the whole-series-gone state reads before restoring
        legend_toggle(bars, SERIES)
        record_check(app, "{SERIES} restored after the second click",
                     wait_for_series_shown(bars, SERIES, true) != null)
        hold_remainder_content(app, d_leg, t_leg)

        // ---- Beat 3: the pie chart ----
        let d_pie = say_begin(app, "a pie splits the whole", PIE,
            [voice = "The pie chart splits a single whole into slices, each labelled with its share as a percentage. A different shape from the same simple call."])
        let t_pie = record_frame_count(app)
        var psnap = snapshot(app)
        move_to(app, plot_center(psnap, pie), 900)
        wait_for_mouse_idle(app)
        record_check_rendered(app, PIE, true)
        hold_remainder_content(app, d_pie, t_pie)
    }
}
