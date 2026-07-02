options gen2
options indenting = 4

module imgui_implot_playwright public

// ImPlot test helpers, layered on dasImgui's imgui_playwright. The v2 `plot`
// container serializes a plot's per-frame state (geometry, axis limits, hovered,
// mouse-plot-pos) into its snapshot payload; these helpers wrap the common
// reads/waits so a test reads as intent ("wait for the X axis to converge to
// [0,200]", "move onto the plot, expect hovered") rather than JSON plumbing.

require imgui/imgui_playwright public
require implot
require math
require daslib/json public
require daslib/json_boost public

struct PlotSession {
    app  : ImguiApp
    plot : string         //! snapshot path of the plot, e.g. "PLOT_WIN/WAVES"
}

struct AxisLimits {
    x_min : double
    x_max : double
    y_min : double
    y_max : double
}

struct DragRectValue {
    x_min : double
    y_min : double
    x_max : double
    y_max : double
}

def public implot_open(app : ImguiApp; plot_path : string; timeout_sec : float = 15.0f) : PlotSession {
    //! Wait for `plot_path` to render, returning a session bundling {app, plot}. ImPlot is
    //! stateless (no editor handle to capture) — the session is just the (app, path) pair
    //! the reads/waits below key off.
    wait_for_widget(app, plot_path, timeout_sec)
    return PlotSession(app = app, plot = plot_path)
}

// ===== one-shot reads =====

def public implot_snapshot(s : PlotSession) : JsonValue? {
    //! Fetch a fresh widget snapshot from the live app.
    return snapshot(s.app)
}

def public plot_payload(var snap : JsonValue?; s : PlotSession) : JsonValue? {
    //! The plot's snapshot payload (pos / plot_size / x_min..y_max / hovered / mouse_*).
    return find_widget(snap, s.plot)?["payload"]
}

def public plot_visible(var snap : JsonValue?; s : PlotSession) : bool {
    //! True iff BeginPlot returned true this frame (the plot drew, not clipped/collapsed).
    return plot_payload(snap, s)?["visible"] ?? false
}

def public plot_hovered(var snap : JsonValue?; s : PlotSession) : bool {
    //! IsPlotHovered() from the last snapshot — the cursor is over the plot area.
    return plot_payload(snap, s)?["hovered"] ?? false
}

def public plot_axis_limits(var snap : JsonValue?; s : PlotSession) : AxisLimits {
    //! The plot's current axis limits (data coords) from the snapshot. All zero if absent.
    let p = plot_payload(snap, s)
    return AxisLimits(x_min = p?["x_min"] ?? 0.0lf, x_max = p?["x_max"] ?? 0.0lf,
                      y_min = p?["y_min"] ?? 0.0lf, y_max = p?["y_max"] ?? 0.0lf)
}

def public plot_axis_limit(var snap : JsonValue?; s : PlotSession; field : string) : double {
    //! One axis-limit field of the plot payload by name (DATA coords) — the reader for SECONDARY
    //! axes the typed `plot_axis_limits` (X1/Y1 only) does not cover: e.g. "y2_max" / "x2_min".
    //! 0 if absent (axis not enabled, or the `@optional`-zero trap on an exactly-zero limit).
    return plot_payload(snap, s)?[field] ?? 0.0lf
}

def public plot_mouse_pos(var snap : JsonValue?; s : PlotSession) : tuple<double; double> {
    //! GetPlotMousePos() in DATA coords (only meaningful while plot_hovered is true).
    let p = plot_payload(snap, s)
    return (p?["mouse_x"] ?? 0.0lf, p?["mouse_y"] ?? 0.0lf)
}

def public plot_bbox(var snap : JsonValue?; s : PlotSession) : float4 {
    //! The plot area's screen-space bbox [x0,y0,x1,y1] — target synthetic mouse moves here.
    let b = find_widget(snap, s.plot)?["bbox"]
    return float4(b?["x"] ?? 0.0f, b?["y"] ?? 0.0f, b?["z"] ?? 0.0f, b?["w"] ?? 0.0f)
}

def public plot_center(var snap : JsonValue?; s : PlotSession) : tuple<float; float> {
    //! Screen-space center of the plot area — a convenient synthetic-move / hover target
    //! (the tuple form `move_to` expects).
    let bb = plot_bbox(snap, s)
    return ((bb.x + bb.z) * 0.5f, (bb.y + bb.w) * 0.5f)
}

// ===== axis drag (pan one axis) =====

let private AXIS_GUTTER_PX = 18.0f   // into the tick-label strip just outside the data area
let private AXIS_DRAG_STEPS = 6

def private continuous_axis_drag(app : ImguiApp; from_pt : tuple<float; float>; to_pt : tuple<float; float>) {
    // ImPlot integrates io.MouseDelta per frame, so a pan needs a CONTINUOUS multi-waypoint drag (a
    // single from->to jump does not move the axis). Walk the cursor across waypoints, button held.
    let dur = 120
    let endt = 120 + AXIS_DRAG_STEPS * dur
    var ev <- [
        JV((t_ms = 0,   kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 100, kind = "move",   x = from_pt._0, y = from_pt._1)),
        JV((t_ms = 120, kind = "button", button = 0, action = "press"))]
    ev |> reserve(length(ev) + AXIS_DRAG_STEPS + 2)
    for (i in range(1, AXIS_DRAG_STEPS + 1)) {
        let f = float(i) / float(AXIS_DRAG_STEPS)
        ev |> push(JV((t_ms = 120 + i * dur, kind = "move",
                       x = from_pt._0 + (to_pt._0 - from_pt._0) * f,
                       y = from_pt._1 + (to_pt._1 - from_pt._1) * f)))
    }
    ev |> push(JV((t_ms = endt + 80,  kind = "button", button = 0, action = "release")))
    ev |> push(JV((t_ms = endt + 180, kind = "move", x = to_pt._0, y = to_pt._1)))
    post_command(app, "imgui_mouse_play", JV((events = ev)))
    wait_for_mouse_idle(app)
    unsafe { delete ev; }
}

def public drag_axis(s : PlotSession; axis : ImAxis; delta_px : float) {
    //! Continuous drag along ONE axis's gutter (the tick-label strip just outside the data area),
    //! panning ONLY that axis — the multi-axis "rescale just this one" gesture, distinct from a
    //! plot-body pan (which moves every axis at once). Locates the gutter from the plot geometry
    //! (pos / plot_size) in the snapshot: Y axes drag vertically by `delta_px`, X axes horizontally.
    //! Supports the X1 / X2 / Y1 / Y2 gutters (primary + first auxiliary). Silent no-op when the plot
    //! isn't visible or `axis` is unsupported — gate the effect with `wait_for_axis_limit_changed` /
    //! `record_check_changed` on the axis's range field (e.g. "y2_max").
    var snap = snapshot(s.app)
    let p = plot_payload(snap, s)
    return if (!(p?["visible"] ?? false))
    let px = p?["pos"]?["x"] ?? 0.0f
    let py = p?["pos"]?["y"] ?? 0.0f
    let pw = p?["plot_size"]?["x"] ?? 0.0f
    let ph = p?["plot_size"]?["y"] ?? 0.0f
    let cx = px + pw * 0.5f
    let cy = py + ph * 0.5f
    if (axis == ImAxis.Y1) {
        continuous_axis_drag(s.app, (px - AXIS_GUTTER_PX, cy), (px - AXIS_GUTTER_PX, cy + delta_px))
    } elif (axis == ImAxis.Y2) {
        continuous_axis_drag(s.app, (px + pw + AXIS_GUTTER_PX, cy), (px + pw + AXIS_GUTTER_PX, cy + delta_px))
    } elif (axis == ImAxis.X1) {
        continuous_axis_drag(s.app, (cx, py + ph + AXIS_GUTTER_PX), (cx + delta_px, py + ph + AXIS_GUTTER_PX))
    } elif (axis == ImAxis.X2) {
        continuous_axis_drag(s.app, (cx, py - AXIS_GUTTER_PX), (cx + delta_px, py - AXIS_GUTTER_PX))
    }
}

// ===== drag-tool handles =====
//
// A drag tool registers under `<plot>/<id>` with the handle's screen bbox, so the
// generic `drag(app, handle_path(s, id), dx, dy)` presses its center and drags it.
// These readers pull the bound VALUE out of the handle's payload; `wait_for_point_moved`
// gates a synthetic drag landing (value moved off its baseline) before asserting.

def public handle_path(s : PlotSession; id : string) : string {
    //! Snapshot path of a drag handle declared as `<id>` inside this session's plot.
    return "{s.plot}/{id}"
}

def private handle_payload(var snap : JsonValue?; path : string) : JsonValue? {
    return find_widget(snap, path)?["payload"]
}

def public drag_point_value(var snap : JsonValue?; path : string) : tuple<double; double> {
    //! A `drag_point` handle's bound (x, y) in DATA coords. (0,0) if the path is absent.
    let p = handle_payload(snap, path)
    return (p?["x"] ?? 0.0lf, p?["y"] ?? 0.0lf)
}

def public drag_line_value(var snap : JsonValue?; path : string) : double {
    //! A `drag_line_x` / `drag_line_y` handle's bound position on its axis (DATA coords).
    return handle_payload(snap, path)?["value"] ?? 0.0lf
}

def public drag_rect_value(var snap : JsonValue?; path : string) : DragRectValue {
    //! A `drag_rect` handle's bound bounds (DATA coords). All zero if the path is absent.
    let p = handle_payload(snap, path)
    return DragRectValue(x_min = p?["x_min"] ?? 0.0lf, y_min = p?["y_min"] ?? 0.0lf,
                         x_max = p?["x_max"] ?? 0.0lf, y_max = p?["y_max"] ?? 0.0lf)
}

def public drag_held(var snap : JsonValue?; path : string) : bool {
    //! True iff the handle was grabbed / dragged on the snapshot's frame.
    return handle_payload(snap, path)?["held"] ?? false
}

def public wait_for_point_moved(s : PlotSession; id : string; from : tuple<double; double>;
                                tol : double = 1.0e-6lf; max_frames : int = 300) : JsonValue? {
    //! Poll until the `<id>` drag-point's value moves off `from` by more than `tol` on either
    //! axis — the gate for a synthetic `drag` actually moving the handle. Snapshot or null.
    let path = handle_path(s, id)
    return wait_until(s.app, max_frames) $(var snap) {
        let v = drag_point_value(snap, path)
        return (abs(v._0 - from._0) > tol || abs(v._1 - from._1) > tol)
    }
}

// ===== waits (snapshot-polled) =====

def public implot_wait_visible(s : PlotSession; timeout_sec : float = 6.0f) : JsonValue? {
    //! Poll until the plot is present AND drew this frame. Returns the snapshot or null.
    return wait_for_visible(s.app, s.plot, timeout_sec)
}

def public wait_for_axis_limits(s : PlotSession; x_min : double; x_max : double;
                                y_min : double; y_max : double;
                                tol : double = 1.0e-3lf; max_frames : int = 300) : JsonValue? {
    //! Poll until all four axis limits converge to the targets within `tol` — the gate for
    //! an axis change (SetupAxisLimits / zoom / fit) actually landing. Returns the matching
    //! snapshot or null on timeout.
    return wait_until(s.app, max_frames) $(var snap) {
        let l = plot_axis_limits(snap, s)
        return (abs(l.x_min - x_min) < tol && abs(l.x_max - x_max) < tol &&
                abs(l.y_min - y_min) < tol && abs(l.y_max - y_max) < tol)
    }
}

def public wait_for_axis_limit_changed(s : PlotSession; field : string; before : double;
                                       tol : double = 1.0e-6lf; max_frames : int = 300) : JsonValue? {
    //! Poll until the plot's `field` axis-limit (e.g. "y2_max") moves off `before` by more than
    //! `tol` — the gate for a `drag_axis` actually panning that axis. Returns the snapshot or null.
    return wait_until(s.app, max_frames) $(var snap) {
        return abs(plot_axis_limit(snap, s, field) - before) > tol
    }
}

def public wait_for_hovered(s : PlotSession; expected : bool = true; max_frames : int = 300) : JsonValue? {
    //! Poll until the plot's hovered state equals `expected` (gate a synthetic mouse move
    //! onto the plot before reading mouse_plot_pos). Returns the matching snapshot or null.
    return wait_until(s.app, max_frames) $(var snap) {
        return plot_hovered(snap, s) == expected
    }
}

// ===== legend entries =====
//
// The v2 `plot` scope serializes its per-series legend (label / shown / clickable rect) into
// `payload.legend`. These helpers find an entry by series label so a test reads as intent
// ("toggle the cos series, expect it hidden") and a recording drives a REAL synthetic click at
// the exact rect ImPlot hit-tests — clicking a legend entry hides / shows that series.

struct LegendEntryView {
    found : bool          //! a legend entry with this label was present in the snapshot
    shown : bool          //! series currently visible (false after a legend-toggle hide)
    hovered : bool        //! legend entry hovered this frame (the sync gate for legend_toggle)
    rect  : float4        //! clickable button rect [x0,y0,x1,y1], screen px
}

def public legend_entry(var snap : JsonValue?; s : PlotSession; series : string) : LegendEntryView {
    //! Find the `series`-labelled legend entry in the plot snapshot. `found` is false (rest zero)
    //! when the plot isn't visible or has no such series. (`series`, not `label` — reserved word.)
    let leg = plot_payload(snap, s)?["legend"]
    if (leg != null && leg.value is _array) {
        for (e in leg.value as _array) {
            if ((e?["series"] ?? "") == series) {
                return LegendEntryView(found = true, shown = e?["shown"] ?? false,
                    hovered = e?["hovered"] ?? false,
                    rect = float4(e?["x0"] ?? 0.0f, e?["y0"] ?? 0.0f, e?["x1"] ?? 0.0f, e?["y1"] ?? 0.0f))
            }
        }
    }
    return LegendEntryView(found = false, shown = false, hovered = false,
                           rect = float4(0.0f, 0.0f, 0.0f, 0.0f))
}

def public legend_entry_center(var snap : JsonValue?; s : PlotSession; series : string) : tuple<float; float> {
    //! Screen-space center of the `series` legend entry — the synthetic click / move target.
    //! (0,0) when absent; gate on `legend_entry().found` / `wait_for_series_shown` first.
    let r = legend_entry(snap, s, series).rect
    return ((r.x + r.z) * 0.5f, (r.y + r.w) * 0.5f)
}

def public series_shown(var snap : JsonValue?; s : PlotSession; series : string) : bool {
    //! True iff the `series` is currently visible (its legend entry is not toggled off).
    //! False when the series is hidden OR absent — pair with `legend_entry().found` to distinguish.
    return legend_entry(snap, s, series).shown
}

def public legend_toggle(s : PlotSession; series : string) {
    //! Synthesize a REAL left-click on the `series` legend entry, toggling its visibility
    //! (ImPlot hides / shows the series). Moves the cursor onto the entry, waits until it reports
    //! hovered (so the press can't batch ahead of HoveredId — the windowed-vsync press-before-hover
    //! race), then clicks in place and blocks until the gesture settles. Silently no-ops when the
    //! entry is absent OR hover never registers — the caller MUST gate the effect with
    //! `wait_for_series_shown`.
    var snap = snapshot(s.app)
    let v = legend_entry(snap, s, series)
    return if (!v.found)
    let center = ((v.rect.x + v.rect.z) * 0.5f, (v.rect.y + v.rect.w) * 0.5f)
    move_to(s.app, center)
    // Click only once hover registers; on timeout bail rather than click blind (a dropped press
    // or a stale target) — the caller's wait_for_series_shown gate then fails loudly.
    return if (wait_for_legend_hover(s, series) == null)
    var events : array<JsonValue?>
    click_at(events, 0, center)
    post_command(s.app, "imgui_mouse_play", JV((events = events)))
    unsafe { delete events; }
    wait_for_mouse_idle(s.app)
}

def public wait_for_legend_hover(s : PlotSession; series : string; expected : bool = true;
                                 max_frames : int = 300) : JsonValue? {
    //! Poll until the `series` legend entry's hover state equals `expected` — the sync gate for
    //! `legend_toggle`: after `move_to` onto the entry, this confirms ImPlot registered the hover
    //! before the press, so the click can't batch ahead of `HoveredId` (the windowed-vsync
    //! press-before-hover race). Bounded; returns the matching snapshot or null on timeout.
    return wait_until(s.app, max_frames) $(var snap) {
        return legend_entry(snap, s, series).hovered == expected
    }
}

def public wait_for_series_shown(s : PlotSession; series : string; expected : bool;
                                 max_frames : int = 300) : JsonValue? {
    //! Poll until the `series`' legend entry is PRESENT and its visibility equals `expected` — the
    //! gate for a `legend_toggle` actually landing. Requiring presence is deliberate: `series_shown`
    //! reads false for both hidden AND absent, so gating on it alone would let "wait for hidden"
    //! pass on a missing series (telemetry gone / wrong path) — a false-positive gate. Returns the
    //! matching snapshot or null on timeout.
    return wait_until(s.app, max_frames) $(var snap) {
        let e = legend_entry(snap, s, series)
        return e.found && e.shown == expected
    }
}
