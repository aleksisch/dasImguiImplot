options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record shaded_and_stairs.apng - the filled-area item families, a display tour.
//! On top a confidence BAND (plot_shaded_between fills between a lower and an upper curve,
//! widening to the right, with the mean line drawn over it); below a STAIRS plot
//! (plot_stairs holds each sample, plot_shaded fills the area beneath it to the baseline).
//! No interaction to teach here beyond the shapes, so the cursor traces the widening band
//! then glides down to the steps while the voice names each area shape. Self-verifying:
//! both plots must render at every beat, so a dead frame or wrong window aborts at
//! teardown. The headless regression is test_shaded_and_stairs.das.

let BAND = "PLOT_WIN/BAND"
let STAIRS = "PLOT_WIN/STAIRS"

[export]
def main {
    with_implot_recording_app("examples/tutorial/shaded_and_stairs.das", "shaded_and_stairs.apng", 45) $(app) {
        let band = implot_open(app, BAND)
        let stairs = implot_open(app, STAIRS)
        var snap = wait_for_widget(app, BAND, 15.0f)
        if (snap == null) {
            panic("{BAND} never rendered - wrong app running?")
        }
        // BAND data area geometry - maps screen fractions to a glide across the band.
        let p = plot_payload(snap, band)
        let bx = p?["pos"]?["x"] ?? 0.0f
        let by = p?["pos"]?["y"] ?? 0.0f
        let bw = p?["plot_size"]?["x"] ?? 0.0f
        let bh = p?["plot_size"]?["y"] ?? 0.0f

        // ---- Beat 1: both filled-area plots ----
        move_to(app, plot_center(snap, band), 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, BAND, true)
        record_check_rendered(app, STAIRS, true)
        say(app, "two filled-area plots", BAND,
            [voice = "Two filled-area plots. On top, a confidence band. Below, a step plot with the area beneath it filled."])

        // ---- Beat 2: trace the widening band ----
        let d_band = say_begin(app, "a band fills between two curves", BAND,
            [voice = "The band fills the region between a lower and an upper curve. It widens to the right, the way a confidence interval grows, and the mean line is drawn on top."])
        let t_band = record_frame_count(app)
        // Glide along the band, left to right, at mid-height to trace the widening fill.
        move_to(app, (bx + bw * 0.08f, by + bh * 0.5f), 300)
        wait_for_mouse_idle(app)
        move_to(app, (bx + bw * 0.92f, by + bh * 0.5f), 1200)
        wait_for_mouse_idle(app)
        record_check_rendered(app, BAND, true)
        hold_remainder_content(app, d_band, t_band)

        // ---- Beat 3: down to the step plot ----
        let d_stairs = say_begin(app, "stairs hold each sample", STAIRS,
            [voice = "Below, the step plot holds each sample until the next, drawing piecewise-constant data, and the shaded fill runs from the steps down to the baseline."])
        let t_stairs = record_frame_count(app)
        var ssnap = snapshot(app)
        move_to(app, plot_center(ssnap, stairs), 900)
        wait_for_mouse_idle(app)
        record_check_rendered(app, STAIRS, true)
        hold_remainder_content(app, d_stairs, t_stairs)
    }
}
