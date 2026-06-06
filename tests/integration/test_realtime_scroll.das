options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require daslib/json public
require daslib/json_boost public

//! Headless regression for realtime_scroll: spawn the tutorial and assert the x axis
//! actually scrolls. The example pins x to [t-HISTORY, t] (Always) and advances t each
//! frame, so the window's left edge must eventually pass 0 — the gate that proves the
//! rolling buffer feeds data in real time (not just a static plot).

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/realtime_scroll.das"

[test]
def test_realtime_scroll(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/SCROLL")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null && plot_visible(snap, s), "scrolling plot rendered")
        if (snap == null) return

        // x_min = t - HISTORY, and t advances every frame, so the left edge must climb
        // past 0 — proof the window is scrolling, not fixed.
        var moved = wait_until(d, 600) $(var sn) {
            return plot_axis_limits(sn, s).x_min > 0.5lf
        }
        t |> success(moved != null, "x window scrolled (x_min advanced past 0.5)")
    }
}
