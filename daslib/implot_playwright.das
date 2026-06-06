options gen2
options indenting = 4

module imgui_implot_playwright public

// ImPlot test helpers, layered on dasImgui's imgui_playwright. The v2 `plot`
// container serializes a plot's per-frame state (geometry, axis limits, hovered,
// mouse-plot-pos) into its snapshot payload; these helpers wrap the common
// reads/waits so a test reads as intent ("wait for the X axis to converge to
// [0,200]", "move onto the plot, expect hovered") rather than JSON plumbing.

require imgui/imgui_playwright public
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

def public wait_for_hovered(s : PlotSession; expected : bool = true; max_frames : int = 300) : JsonValue? {
    //! Poll until the plot's hovered state equals `expected` (gate a synthetic mouse move
    //! onto the plot before reading mouse_plot_pos). Returns the matching snapshot or null.
    return wait_until(s.app, max_frames) $(var snap) {
        return plot_hovered(snap, s) == expected
    }
}
