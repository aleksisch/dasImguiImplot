options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Driver: record heatmap_histogram.apng - the two statistical 2D / distribution items,
//! a display tour. On the left a HEAT plot (plot_heatmap maps a rows x cols grid through
//! the active colormap); on the right a HIST plot (histogram bins a flat sample array into
//! a 1D distribution). No interaction to teach here beyond the shapes - and colormap
//! scaling belongs to colormaps_and_style - so the cursor traces across the grid then
//! glides to the histogram while the voice names each item. Self-verifying with REAL synth
//! input: both plots must render at every beat, and the cursor must actually land hovered
//! over the heatmap grid, so a dead frame or a missed cursor aborts at teardown. The
//! headless regression is test_heatmap_histogram.das.

let HEAT = "PLOT_WIN/HEAT"
let HIST = "PLOT_WIN/HIST"

[export]
def main {
    with_implot_recording_app("examples/tutorial/heatmap_histogram.das", "heatmap_histogram.apng", 45) $(app) {
        let heat = implot_open(app, HEAT)
        let hist = implot_open(app, HIST)
        var snap = wait_for_widget(app, HEAT, 15.0f)
        if (snap == null) {
            panic("{HEAT} never rendered - wrong app running?")
        }
        // HEAT data area geometry - maps screen fractions to a glide across the grid.
        let p = plot_payload(snap, heat)
        let hx = p?["pos"]?["x"] ?? 0.0f
        let hy = p?["pos"]?["y"] ?? 0.0f
        let hw = p?["plot_size"]?["x"] ?? 0.0f
        let hh = p?["plot_size"]?["y"] ?? 0.0f

        // ---- Beat 1: both statistical plots ----
        move_to(app, plot_center(snap, heat), 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, HEAT, true)
        record_check_rendered(app, HIST, true)
        say(app, "two statistical plots", HEAT,
            [voice = "Two statistical plots. On the left, a heatmap: a grid of cells colored by value. On the right, a histogram of a sample set."])

        // ---- Beat 2: trace the heatmap grid ----
        let d_heat = say_begin(app, "a heatmap colors a grid by value", HEAT,
            [voice = "The heatmap draws a rows by columns grid, and each cell takes its color from its value through the active colormap, so the structure in the data shows up as a pattern of colors."])
        let t_heat = record_frame_count(app)
        // Glide diagonally across the grid so the cursor sweeps the gradient.
        move_to(app, (hx + hw * 0.1f, hy + hh * 0.15f), 300)
        wait_for_mouse_idle(app)
        move_to(app, (hx + hw * 0.9f, hy + hh * 0.85f), 1200)
        wait_for_mouse_idle(app)
        record_check(app, "the cursor lands hovered over the heatmap grid",
                     wait_for_hovered(heat, true) != null)
        record_check_rendered(app, HEAT, true)
        hold_remainder_content(app, d_heat, t_heat)

        // ---- Beat 3: the histogram ----
        let d_hist = say_begin(app, "a histogram bins a sample set", HIST,
            [voice = "The histogram bins a flat array of samples into bars, showing the shape of the distribution. Here, a count per bin, with the bin count picked automatically from the sample size."])
        let t_hist = record_frame_count(app)
        var gsnap = snapshot(app)
        move_to(app, plot_center(gsnap, hist), 900)
        wait_for_mouse_idle(app)
        record_check_rendered(app, HIST, true)
        hold_remainder_content(app, d_hist, t_hist)
    }
}
