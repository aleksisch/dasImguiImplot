options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require implot
require daslib/json public
require daslib/json_boost public

//! Driver: record drag_tools.apng - one plot carrying three DRAG TOOLS: a draggable
//! point, a draggable vertical threshold line, and a draggable rectangle region. The
//! interaction this tutorial teaches is the GRAB-AND-DRAG: press on a handle and move
//! it, and its bound value updates live every frame (point x/y, line position, rect
//! bounds). Taught beat by beat - drag the point, drag the line, then the region's TWO
//! modes: grab its body to MOVE the whole rect, grab a corner to RESIZE it. Each is a
//! REAL synthetic grab from the handle's registered screen bbox (center for the body,
//! the bbox corner for resize). Voiced and self-verifying: drag_through_voice asserts
//! each drag CHANGED the bound payload field (record_check_changed), so a missed grab
//! or a frozen handle aborts at teardown. The headless regression is test_drag_tools.das.

let PLOT = "PLOT_WIN/WAVES"

[export]
def main {
    with_implot_recording_app("examples/tutorial/drag_tools.das", "drag_tools.apng", 60) $(app) {
        let s = implot_open(app, PLOT)
        var snap = wait_for_widget(app, PLOT, 15.0f)
        if (snap == null) {
            panic("{PLOT} never rendered - wrong app running?")
        }

        // ---- Beat 1: the three handles ----
        move_to(app, plot_center(snap, s), 700)
        wait_for_mouse_idle(app)
        record_check_rendered(app, PLOT, true)
        say(app, "three draggable handles", PLOT,
            [voice = "This plot carries three draggable handles. A point, a vertical threshold line, and a rectangle region. Grab any one and its value updates live."])

        // ---- Beat 2: drag the POINT (p0) - x and y follow the cursor ----
        let p0 = handle_path(s, "p0")
        var sp = snapshot(app)
        record_check(app, "the point handle registered a bbox", widget_exists(sp, p0))
        let pc = widget_click_point(sp, p0)
        move_to(app, pc, 600)
        wait_for_mouse_idle(app)
        let d_pt = say_begin(app, "drag the point", PLOT,
            [voice = "Grab the yellow point and drag it. Its x and y follow the cursor, and the bound value updates every frame as it moves."])
        drag_through_voice(app, d_pt, p0, (pc._0 - 160.0f, pc._1 - 70.0f), 0, "x")

        // ---- Beat 3: drag the THRESHOLD line (thresh) - slides along x ----
        let thr = handle_path(s, "thresh")
        var sl = snapshot(app)
        let lc = widget_click_point(sl, thr)
        move_to(app, lc, 600)
        wait_for_mouse_idle(app)
        let d_ln = say_begin(app, "drag the threshold line", PLOT,
            [voice = "Now the green threshold line. Drag it sideways and its position slides along the x axis, the way you would move a cutoff or a marker."])
        drag_through_voice(app, d_ln, thr, (lc._0 + 130.0f, lc._1), 0, "value")

        // ---- Beat 4: drag the REGION BODY (roi) - the whole rect moves ----
        let roi = handle_path(s, "roi")
        var sr = snapshot(app)
        let rc = widget_click_point(sr, roi)   // bbox center == the rect's body
        move_to(app, rc, 600)
        wait_for_mouse_idle(app)
        let d_mv = say_begin(app, "drag the body to move it", PLOT,
            [voice = "And the magenta region. It has two modes. Grab its body, near the center, and the whole rectangle slides, carrying all four bounds together."])
        drag_through_voice(app, d_mv, roi, (rc._0 + 100.0f, rc._1 - 90.0f), 0, "x_min")

        // ---- Beat 5: drag a CORNER (roi) - only that corner moves, the rect resizes ----
        // A DragRect corner is its own grab; pressing the body would only move it again, so
        // target the bbox's bottom-right corner (z,w) = (x_max, y_min in screen px) directly.
        var sr2 = snapshot(app)
        let bb = find_widget(sr2, roi)?["bbox"]
        let crn = (bb?["z"] ?? 0.0f, bb?["w"] ?? 0.0f)
        move_to(app, crn, 600)
        wait_for_mouse_idle(app)
        let d_rs = say_begin(app, "drag a corner to resize", PLOT,
            [voice = "Grab a corner instead, and only that corner moves. The rectangle resizes, the way you would reshape a region of interest."])
        drag_through_voice(app, d_rs, roi, (crn._0 + 80.0f, crn._1 + 70.0f), 0, "x_max")
    }
}
