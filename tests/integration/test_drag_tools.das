options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

require dastest/testing_boost public
require imgui/imgui_implot_app public
require imgui/imgui_implot_playwright public
require math
require daslib/json public
require daslib/json_boost public

//! Headless regression for the v2 DRAG-TOOL value snapshot + the SYNTHETIC drag path:
//! spawn drag_tools, read the drag-point's baseline (x,y), synth-drag its handle by a
//! screen delta, and assert the bound value moved off its baseline and stayed inside the
//! axes. Proves the handle registers a targetable bbox (computed from PlotToPixels, not
//! GetItemRect) and that the dragged value round-trips back through the snapshot.

let SUBJECT = "modules/dasImguiImplot/examples/tutorial/drag_tools.das"

[test]
def test_drag_tools(t : T?) {
    with_implot_app(SUBJECT) $(d) {
        let s = implot_open(d, "PLOT_WIN/WAVES")
        var snap = implot_wait_visible(s, 15.0f)
        t |> success(snap != null, "WAVES plot rendered")
        if (snap == null) return

        // The point handle registers under <plot>/p0 with a real screen bbox.
        let hpath = handle_path(s, "p0")
        t |> success(widget_exists(snap, hpath), "drag-point handle registered at {hpath}")

        let before = drag_point_value(snap, hpath)
        t |> success(abs(before._0 - 150.0lf) < 1.0e-3lf, "point starts at x=150 (got {before._0})")
        t |> success(abs(before._1 - 0.0lf) < 1.0e-3lf, "point starts at y=0 (got {before._1})")

        // Drag the handle left + down on screen; the bound value must move off its baseline.
        let res = drag(d, hpath, -60.0f, 40.0f)
        t |> success((res?["ok"] ?? false), "drag dispatched onto the handle")
        var moved = wait_for_point_moved(s, "p0", before)
        t |> success(moved != null, "drag-point value moved off its baseline")
        if (moved == null) return

        // The new value is a real data coordinate still inside the axes ([0,200] x [-1.5,1.5]).
        let after = drag_point_value(moved, hpath)
        t |> success((after._0 != before._0 || after._1 != before._1), "point value changed")
        t |> success((after._0 >= 0.0lf && after._0 <= 200.0lf), "point x stays in [0,200] (got {after._0})")
        t |> success((after._1 >= -1.5lf && after._1 <= 1.5lf), "point y stays in [-1.5,1.5] (got {after._1})")
    }
}
