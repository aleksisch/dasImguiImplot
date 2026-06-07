options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record colormaps_and_style.apng - colormaps, a display tour. On the left a
//! Viridis HEAT plot with its colorbar (a sequential colormap reads as a smooth ramp - the
//! heatmap_histogram forward reference); on the right six series auto-colored from a
//! Spectral colormap (each plot_line takes the next color in the map, no per-series color
//! set). No interaction to teach here beyond what a colormap does - changing it live can't
//! recolor existing auto-colored items, since ImPlot caches an item's color by id - so the
//! cursor traces the colorbar then glides to the auto-colored series while the voice names
//! each. Self-verifying with REAL synth input: both plots must render at every beat, so a
//! dead frame or wrong window aborts at teardown. The headless regression is
//! test_colormaps.das.

let HEAT = "PLOT_WIN/HEAT"
let LINES = "PLOT_WIN/LINES"

// Hold a beat's caption for the remainder of its voice dwell, measuring real elapsed
// work (glide + verify) so the next say_begin can't fire early and overlap the voice.
def hold_remainder(dwell : uint; t0 : int64) {
    let elapsed = uint(get_time_usec(t0) / 1000)
    if (dwell > elapsed) {
        sleep(dwell - elapsed)
    }
}

[export]
def main {
    with_implot_recording_app("examples/tutorial/colormaps_and_style.das", "colormaps_and_style.apng", 45) $(app) {
        let heat = implot_open(app, HEAT)
        let lines = implot_open(app, LINES)
        var snap = wait_for_widget(app, HEAT, 15.0f)
        if (snap == null) {
            panic("{HEAT} never rendered - wrong app running?")
        }
        // HEAT data area geometry - lets the cursor gesture toward the colorbar on its right.
        let p = plot_payload(snap, heat)
        let hx = p?["pos"]?["x"] ?? 0.0f
        let hy = p?["pos"]?["y"] ?? 0.0f
        let hw = p?["plot_size"]?["x"] ?? 0.0f
        let hh = p?["plot_size"]?["y"] ?? 0.0f

        // ---- Beat 1: what a colormap is ----
        move_to(app, plot_center(snap, heat), 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, HEAT, true)
        record_check_rendered(app, LINES, true)
        say(app, "colormaps", HEAT,
            [voice = "Colormaps. A colormap turns a value into a color. On the left, a heatmap and its colorbar use Viridis. On the right, six series, each auto-colored from a colormap."])

        // ---- Beat 2: the colorbar reads as a smooth ramp (the sequential map) ----
        let d_heat = say_begin(app, "a sequential map reads as a ramp", HEAT,
            [voice = "Viridis is a sequential colormap, so the colorbar beside the heatmap reads as a smooth ramp from low to high. That is the natural fit for a heatmap."])
        let t_heat = ref_time_ticks()
        // Drift toward the colorbar on the heatmap's right edge.
        move_to(app, (hx + hw * 0.96f, hy + hh * 0.5f), 900)
        wait_for_mouse_idle(app)
        record_check_rendered(app, HEAT, true)
        hold_remainder(d_heat, t_heat)

        // ---- Beat 3: auto-colored series ----
        let d_lines = say_begin(app, "series auto-color from the map", LINES,
            [voice = "On the right, six series in one colormap scope. Each line takes the next color from the map, so a family of related series stays consistent with no per-series color set."])
        let t_lines = ref_time_ticks()
        var lsnap = snapshot(app)
        move_to(app, plot_center(lsnap, lines), 900)
        wait_for_mouse_idle(app)
        record_check_rendered(app, LINES, true)
        hold_remainder(d_lines, t_lines)
    }
}
