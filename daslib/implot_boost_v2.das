options gen2
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

module imgui_implot_boost_v2 shared

require imgui public
require implot public
require imgui/imgui_boost_runtime public      // WidgetEntry / stateless_finalize / [container] machinery
require imgui/imgui_boost_v2 public            // [container] / [widget] annotations

// v2 "proper" DSL over the implot native binding. Adds over v1 (imgui_implot_boost):
//   - `plot` / `subplots` [container] scopes that serialize the plot's per-frame
//     state (geometry, axis limits, hovered, mouse-plot-pos) into the dasImgui
//     snapshot rail — the hook the playwright/test layer asserts on.
//   - OR-typed item wrappers (float | double | int) over the type-overloaded
//     native forwarders, so call sites stay one line regardless of element type.
//   - SetNext* styling and Setup* axis/legend wrappers with auto-sentinel defaults.
//   - Drag tools, statistical / 2D items (heatmap, histogram, error-bars, digital),
//     and the categorical / labelled families (bar-groups, pie) over their forwarders.

// Container finalize that reflects the state struct into the snapshot payload
// (addr + TypeInfo → sprint_json_at at snapshot time). Mirrors dasImgui's
// stateless_finalize without dragging in the whole imgui_containers_builtin module.
def private finalize_state(widget_ident : string; kind : string; var state : auto(ST); box : float4) {
    var entry : WidgetEntry
    capture_item_bbox(entry, box)
    unsafe {
        container_finalize(widget_ident, kind, entry, addr(state),
                           reinterpret<TypeInfo const?>(typeinfo rtti_typeinfo(type<ST>)))
    }
}

// ===== Plot scope snapshot =====

struct LegendEntry {
    //! One legend entry of a `plot` scope, captured per frame into `PlotScopeState.legend`.
    //! Lets a test / recording target a synthetic legend-toggle click (`legend_toggle`) at the
    //! exact rect ImPlot hit-tests, and verify the series hid / showed (`shown`). The rect is
    //! screen-space pixels `[x0,y0]`–`[x1,y1]`; entries are in legend (submission) order.
    series : string                 //! series label (the `label_id` passed to plot_line / etc.); `label` is a reserved word
    shown : bool                    //! series currently visible (false after a legend-toggle hide)
    x0 : float                      //! clickable button rect, screen px — left
    y0 : float                      //! top
    x1 : float                      //! right
    y1 : float                      //! bottom
}

struct PlotScopeState {
    //! Per-frame snapshot of a `plot` scope, pasted into the widget's snapshot
    //! payload by `stateless_finalize`. Geometry is screen-space pixels;
    //! limits / mouse are in plot DATA coordinates. Everything but `visible` is
    //! captured between BeginPlot/EndPlot — the only window where ImPlot's query
    //! functions are valid — so the fields are absent on a clipped/collapsed plot.
    @optional pos : float2          //! plot area top-left, screen px
    @optional plot_size : float2    //! plot area size, screen px
    @optional x_min : double        //! X axis lower limit (data coords)
    @optional x_max : double        //! X axis upper limit
    @optional y_min : double        //! Y axis lower limit
    @optional y_max : double        //! Y axis upper limit
    @optional hovered : bool        //! IsPlotHovered() this frame
    @optional mouse_x : double      //! GetPlotMousePos().x (data coords)
    @optional mouse_y : double      //! GetPlotMousePos().y
    visible : bool                  //! BeginPlot returned true (plot drew this frame)
    legend : array<LegendEntry>     //! per-series legend entries (label / shown / clickable rect), legend order; empty when not visible
}

def private capture_legend(var state : PlotScopeState) {
    // Read the current plot's legend (valid only between BeginPlot/EndPlot) into the snapshot.
    // Labels come from ImPlot as a fresh string per call, so we (re)build them only when the
    // entry set changes — rebuilding every frame would churn the heap. Rects / shown are scalars,
    // refreshed every frame. (A relabel with no count change would read stale — exotic for a
    // steady plot, and the rect / shown stay live regardless.)
    let n = LegendEntryCount()
    if (length(state.legend) != n) {
        state.legend |> clear()
        state.legend |> reserve(n)
        for (i in range(n)) {
            state.legend |> emplace(LegendEntry(series = LegendEntryLabel(i)))
        }
    }
    for (i in range(n)) {
        let r = LegendEntryRect(i)
        state.legend[i].shown = LegendEntryShown(i)
        state.legend[i].x0 = r.x
        state.legend[i].y0 = r.y
        state.legend[i].x1 = r.z
        state.legend[i].y1 = r.w
    }
}

[container]
def plot(var state : PlotScopeState; title : string; size : float2; flags : ImPlotFlags; blk : block) {
    //! `BeginPlot(title, size, flags)` / `EndPlot()` — only-on-true pairing, so the
    //! body and the state capture run iff the plot is visible. Registers as kind
    //! "implot_plot"; the snapshot payload mirrors PlotState (geometry + axis limits
    //! + hovered + mouse-plot-pos), captured in-scope where ImPlot's queries are valid.
    //! Items submitted in the body nest under this plot's snapshot path.
    let im_open = BeginPlot(title, size, flags)
    state.visible = im_open
    var box = float4(0.0f, 0.0f, 0.0f, 0.0f)
    if (im_open) {
        invoke(blk)
        capture_legend(state)
        let ppos = GetPlotPos()
        let psz = GetPlotSize()
        let lim = GetPlotLimits(ImAxis.X1, ImAxis.Y1)
        state.pos = ppos
        state.plot_size = psz
        state.x_min = lim.X.Min
        state.x_max = lim.X.Max
        state.y_min = lim.Y.Min
        state.y_max = lim.Y.Max
        state.hovered = IsPlotHovered()
        // mouse-plot-pos is a projection of io.MousePos — meaningless when the
        // cursor isn't on screen (headless / off-window), where it reads as the
        // ±FLT_MAX sentinel. Only capture it when the mouse position is valid.
        if (IsMousePosValid(null)) {
            let mp = GetPlotMousePos(ImAxis.X1, ImAxis.Y1)
            state.mouse_x = mp.x
            state.mouse_y = mp.y
        }
        box = float4(ppos.x, ppos.y, ppos.x + psz.x, ppos.y + psz.y)
        EndPlot()
    } else {
        state.legend |> clear()
    }
    finalize_state(widget_ident, "implot_plot", state, box)
}

struct SubplotScopeState {
    //! Per-frame snapshot of a `subplots` grid. ImPlot owns per-cell geometry
    //! (each cell is its own BeginPlot inside the body), so the grid itself only
    //! reports its layout + visibility; cells register as nested `plot` entries.
    rows : int                      //! row count passed to BeginSubplots
    cols : int                      //! column count
    visible : bool                  //! BeginSubplots returned true
}

[container]
def subplots(var state : SubplotScopeState; title : string; rows : int; cols : int;
             size : float2; flags : ImPlotSubplotFlags; blk : block) {
    //! `BeginSubplots(title, rows, cols, size, flags)` / `EndSubplots()` —
    //! only-on-true pairing. The body issues `rows*cols` `plot` scopes (one per
    //! cell). Registers as kind "implot_subplots"; payload mirrors SubplotState.
    state.rows = rows
    state.cols = cols
    let im_open = BeginSubplots(title, rows, cols, size, flags, null, null)
    state.visible = im_open
    if (im_open) {
        invoke(blk)
        EndSubplots()
    }
    finalize_state(widget_ident, "implot_subplots", state, float4(0.0f, 0.0f, 0.0f, 0.0f))
}

// ===== Axis / legend setup =====

def public setup_axes(x_label : string; y_label : string;
                      x_flags : ImPlotAxisFlags = ImPlotAxisFlags.None;
                      y_flags : ImPlotAxisFlags = ImPlotAxisFlags.None) {
    //! `SetupAxes(x_label, y_label, x_flags, y_flags)` — label and configure both
    //! axes in one call. Must run before any item is plotted in the scope.
    SetupAxes(x_label, y_label, x_flags, y_flags)
}

def public setup_axis(axis : ImAxis; axis_label : string;
                      flags : ImPlotAxisFlags = ImPlotAxisFlags.None) {
    //! `SetupAxis(axis, label, flags)` — configure one axis (e.g. enable a second
    //! Y axis with `setup_axis(ImAxis.Y2, "rhs", ImPlotAxisFlags.AuxDefault)`).
    SetupAxis(axis, axis_label, flags)
}

def public setup_axes_limits(x_min : double; x_max : double; y_min : double; y_max : double;
                             cond : ImPlotCond = ImPlotCond.Once) {
    //! `SetupAxesLimits(...)` — fix the initial visible range of both axes.
    //! `cond` defaults to Once so the user can still pan/zoom afterwards.
    SetupAxesLimits(x_min, x_max, y_min, y_max, cond)
}

def public setup_axis_limits(axis : ImAxis; v_min : double; v_max : double;
                             cond : ImPlotCond = ImPlotCond.Once) {
    //! `SetupAxisLimits(axis, v_min, v_max, cond)` — fix one axis's range.
    SetupAxisLimits(axis, v_min, v_max, cond)
}

def public setup_legend(location : ImPlotLocation;
                        flags : ImPlotLegendFlags = ImPlotLegendFlags.None) {
    //! `SetupLegend(location, flags)` — place / configure the plot legend.
    SetupLegend(location, flags)
}

def public set_axis(axis : ImAxis) {
    //! `SetAxis(axis)` — route the items submitted AFTER this call to `axis` (e.g.
    //! `set_axis(ImAxis.Y2)` before a `plot_line` puts it on the second y axis set up
    //! by `setup_axis(ImAxis.Y2, ...)`). Affects only the current y (or x) selection.
    SetAxis(axis)
}

def public set_axes(x_axis : ImAxis; y_axis : ImAxis) {
    //! `SetAxes(x_axis, y_axis)` — route subsequent items to this x/y axis PAIR in one
    //! call (the two-axis form of `set_axis`).
    SetAxes(x_axis, y_axis)
}

// ===== Next-item styling (SetNext*) =====
//
// Auto-sentinels mirror ImPlot's defaults: weight/size/alpha = -1 ("auto"),
// color = float4(0,0,0,-1) (IMPLOT_AUTO_COL). Pass an explicit value to override.

def public next_line_style(col : float4; weight : float = -1.0f) {
    //! `SetNextLineStyle(col, weight)` — stroke color/width of the NEXT line item.
    SetNextLineStyle(col, weight)
}

def public next_fill_style(col : float4; alpha_mod : float = -1.0f) {
    //! `SetNextFillStyle(col, alpha_mod)` — fill color/alpha of the NEXT shaded /
    //! bar / pie item.
    SetNextFillStyle(col, alpha_mod)
}

def public next_marker_style(marker : ImPlotMarker; size : float = -1.0f;
                             fill : float4 = float4(0.0f, 0.0f, 0.0f, -1.0f);
                             weight : float = -1.0f;
                             outline : float4 = float4(0.0f, 0.0f, 0.0f, -1.0f)) {
    //! `SetNextMarkerStyle(marker, size, fill, weight, outline)` — marker glyph /
    //! size / colors of the NEXT scatter / line item.
    SetNextMarkerStyle(marker, size, fill, weight, outline)
}

def public next_axes_limits(x_min : double; x_max : double; y_min : double; y_max : double;
                            cond : ImPlotCond = ImPlotCond.Once) {
    //! `SetNextAxesLimits(...)` — set the next plot's initial axis range BEFORE
    //! its BeginPlot (the SetupAxesLimits equivalent for a `plot` you don't want
    //! to put a `setup_axes_limits` call inside).
    SetNextAxesLimits(x_min, x_max, y_min, y_max, cond)
}

def public next_axes_to_fit() {
    //! `SetNextAxesToFit()` — fit the next plot's axes to its data on this frame.
    SetNextAxesToFit()
}

// ===== Plot items (float | double | int) =====
//
// Single OR-typed wrappers over the type-overloaded native forwarders. The paired
// x/y forms tie both arrays to one element type T (mixed-type x/y has no native
// overload). `flags` is the per-item ImPlot*Flags as a bare int (all are typedef int).

def public plot_line(label_id : string; values : array<float> | array<double> | array<int>;
                     xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    //! `PlotLine(label_id, values, xscale, xstart, flags)` — a y-series against an
    //! implicit x = xstart + i*xscale.
    PlotLine(label_id, values, xscale, xstart, flags)
}
def public plot_line(label_id : string; xs : array<auto(T)>; ys : array<T>; flags : int = 0) {
    //! `PlotLine(label_id, xs, ys, flags)` — an explicit x/y series.
    PlotLine(label_id, xs, ys, flags)
}

def public plot_scatter(label_id : string; values : array<float> | array<double> | array<int>;
                        xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    //! `PlotScatter(...)` — markers only, no connecting line.
    PlotScatter(label_id, values, xscale, xstart, flags)
}
def public plot_scatter(label_id : string; xs : array<auto(T)>; ys : array<T>; flags : int = 0) {
    PlotScatter(label_id, xs, ys, flags)
}

def public plot_stairs(label_id : string; values : array<float> | array<double> | array<int>;
                       xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    //! `PlotStairs(...)` — a step plot.
    PlotStairs(label_id, values, xscale, xstart, flags)
}
def public plot_stairs(label_id : string; xs : array<auto(T)>; ys : array<T>; flags : int = 0) {
    PlotStairs(label_id, xs, ys, flags)
}

def public plot_bars(label_id : string; values : array<float> | array<double> | array<int>;
                     bar_size : double = 0.67lf; shift : double = 0.0lf; flags : int = 0) {
    //! `PlotBars(...)` — vertical bars at x = i + shift (Horizontal flag flips it).
    PlotBars(label_id, values, bar_size, shift, flags)
}
def public plot_bars(label_id : string; xs : array<auto(T)>; ys : array<T>;
                     bar_size : double; flags : int = 0) {
    PlotBars(label_id, xs, ys, bar_size, flags)
}

def public plot_stems(label_id : string; values : array<float> | array<double> | array<int>;
                      ref : double = 0.0lf; scale : double = 1.0lf; start : double = 0.0lf;
                      flags : int = 0) {
    //! `PlotStems(...)` — stems from a baseline `ref` to each y value.
    PlotStems(label_id, values, ref, scale, start, flags)
}
def public plot_stems(label_id : string; xs : array<auto(T)>; ys : array<T>;
                      ref : double = 0.0lf; flags : int = 0) {
    PlotStems(label_id, xs, ys, ref, flags)
}

def public plot_shaded(label_id : string; values : array<float> | array<double> | array<int>;
                       yref : double = 0.0lf; xscale : double = 1.0lf; xstart : double = 0.0lf;
                       flags : int = 0) {
    //! `PlotShaded(...)` — area between the series and a horizontal baseline `yref`.
    PlotShaded(label_id, values, yref, xscale, xstart, flags)
}
def public plot_shaded(label_id : string; xs : array<auto(T)>; ys : array<T>;
                       yref : double = 0.0lf; flags : int = 0) {
    PlotShaded(label_id, xs, ys, yref, flags)
}
def public plot_shaded_between(label_id : string; xs : array<auto(T)>;
                               ys1 : array<T>; ys2 : array<T>; flags : int = 0) {
    //! `PlotShaded(label_id, xs, ys1, ys2, flags)` — area between two y series.
    PlotShaded(label_id, xs, ys1, ys2, flags)
}

def public plot_inf_lines(label_id : string;
                          values : array<float> | array<double> | array<int>; flags : int = 0) {
    //! `PlotInfLines(...)` — infinite vertical (or Horizontal-flagged) reference lines.
    PlotInfLines(label_id, values, flags)
}

// ===== Annotation / scalar items =====

def public plot_text(text : string; x : double; y : double;
                     pix_offset : float2 = float2(0.0f, 0.0f);
                     flags : ImPlotTextFlags = ImPlotTextFlags.None) {
    //! `PlotText(text, x, y, pix_offset, flags)` — draw a text label at a data point.
    PlotText(text, x, y, pix_offset, flags)
}

def public plot_dummy(label_id : string; flags : ImPlotDummyFlags = ImPlotDummyFlags.None) {
    //! `PlotDummy(label_id, flags)` — a legend entry with no drawn data.
    PlotDummy(label_id, flags)
}

// ===== Statistical / 2D items =====

def public plot_error_bars(label_id : string; xs : array<auto(T)>; ys : array<T>; err : array<T>;
                           flags : int = 0) {
    //! `PlotErrorBars(label_id, xs, ys, err, flags)` — symmetric error bars (±err) on each point.
    PlotErrorBars(label_id, xs, ys, err, flags)
}
def public plot_error_bars(label_id : string; xs : array<auto(T)>; ys : array<T>;
                           neg : array<T>; pos : array<T>; flags : int = 0) {
    //! `PlotErrorBars(label_id, xs, ys, neg, pos, flags)` — asymmetric error bars (−neg / +pos).
    PlotErrorBars(label_id, xs, ys, neg, pos, flags)
}

def public plot_digital(label_id : string; xs : array<auto(T)>; ys : array<T>; flags : int = 0) {
    //! `PlotDigital(...)` — a boolean / step signal pinned to the plot bottom (ignores y zoom).
    PlotDigital(label_id, xs, ys, flags)
}

def public plot_heatmap(label_id : string; values : array<float> | array<double> | array<int>;
                        rows : int; cols : int; scale_min : double = 0.0lf; scale_max : double = 0.0lf;
                        label_fmt : string = "%.1f";
                        bounds_min : float2 = float2(0.0f, 0.0f);
                        bounds_max : float2 = float2(1.0f, 1.0f); flags : int = 0) {
    //! `PlotHeatmap(...)` — a rows×cols grid of `values` (row-major). scale_min==scale_max
    //! (both 0) auto-scales the colormap. Pass `label_fmt=""` to draw no per-cell labels.
    PlotHeatmap(label_id, values, rows, cols, scale_min, scale_max, label_fmt,
                double(bounds_min.x), double(bounds_min.y),
                double(bounds_max.x), double(bounds_max.y), flags)
}

// Named `histogram` (not `plot_histogram`) — dasImgui's imgui_boost_v2 already owns the
// `plot_histogram` widget name (ImGui's sparkline histogram) via a call-macro. This is
// ImPlot's statistical histogram, a different thing.
def public histogram(label_id : string; values : array<float> | array<double> | array<int>;
                     bins : int = int(ImPlotBin.Sturges); bar_scale : double = 1.0lf;
                     range_min : double = 0.0lf; range_max : double = 0.0lf;
                     flags : int = 0) : double {
    //! `PlotHistogram(...)` — 1D histogram; returns the largest bin count (or density with the
    //! Density flag). `bins` is a positive count OR an ImPlotBin method cast to int.
    //! range_min==range_max auto-ranges to the data.
    return PlotHistogram(label_id, values, bins, bar_scale, range_min, range_max, flags)
}

def public histogram2d(label_id : string; xs : array<auto(T)>; ys : array<T>;
                       x_bins : int = int(ImPlotBin.Sturges); y_bins : int = int(ImPlotBin.Sturges);
                       x_min : double = 0.0lf; x_max : double = 0.0lf;
                       y_min : double = 0.0lf; y_max : double = 0.0lf; flags : int = 0) : double {
    //! `PlotHistogram2D(...)` — bivariate histogram heatmap; returns the largest bin count.
    //! An all-zero range auto-ranges to the data.
    return PlotHistogram2D(label_id, xs, ys, x_bins, y_bins, x_min, x_max, y_min, y_max, flags)
}

// ===== Categorical / labelled items =====

def public plot_bar_groups(label_ids : array<string>;
                           values : array<float> | array<double> | array<int>;
                           item_count : int; group_count : int;
                           group_size : double = 0.67lf; shift : double = 0.0lf; flags : int = 0) {
    //! `PlotBarGroups(...)` — `item_count` series clustered into `group_count` groups.
    //! `values` is a flat `item_count*group_count` row-major matrix (`values[item*group_count+group]`)
    //! and `label_ids` names one series per row. The Stacked flag stacks within a group, Horizontal
    //! flips the bars onto the y-axis.
    PlotBarGroups(label_ids, values, item_count, group_count, group_size, shift, flags)
}

def public plot_pie_chart(label_ids : array<string>;
                          values : array<float> | array<double> | array<int>;
                          x : double; y : double; radius : double;
                          label_fmt : string = "%.1f"; angle0 : double = 90.0lf; flags : int = 0) {
    //! `PlotPieChart(...)` — one slice per (`label_ids`, `values`) pair centered at data-coords
    //! `(x, y)` with `radius` in data units. `label_fmt=""` draws no slice labels; the Normalize
    //! flag forces a full circle even when the values sum to less than one.
    PlotPieChart(label_ids, values, x, y, radius, label_fmt, angle0, flags)
}

// ===== Drag tools =====
//
// Interactive handles INSIDE a plot scope: the user drags them and their bound
// value updates in place. Unlike the items above, a drag tool owns mutable state
// (the value being dragged), so the caller passes a PERSISTENT state struct (a
// global) — the wrapper mutates it through `addr` each frame and serializes it
// into the snapshot under a path nested below the plot (`<plot>/<id>`), with a
// bbox computed from the handle's DATA position via PlotToPixels (a drag tool
// submits no normal ImGui item, so GetItemRect — what widget_finalize captures —
// would be stale). That bbox is what a test/playwright synth-drags onto.

struct DragPointState {
    //! A draggable (x,y) point handle. x/y are plot DATA coordinates and update in
    //! place on drag; `held` is true on the frame the handle is grabbed or dragged.
    x : double
    y : double
    held : bool
}

def public drag_point(var state : DragPointState; id : string; col : float4;
                      size : float = 4.0f;
                      flags : ImPlotDragToolFlags = ImPlotDragToolFlags.None) {
    //! `DragPoint(id, &x, &y, col, size, flags)` — a draggable point. Owns `state`
    //! (x,y persist across frames); registers under `<plot>/<id>` with the handle's
    //! screen bbox so a test can target and drag it.
    let seed = int(GetID(id))
    widget_prelude(id)
    container_path_push(id)
    state.held = DragPoint(seed, unsafe(addr(state.x)), unsafe(addr(state.y)), col, size, flags)
    let px = PlotToPixels(state.x, state.y, ImAxis.X1, ImAxis.Y1)
    let r = size + 4.0f
    finalize_state(id, "implot_drag_point", state,
                   float4(px.x - r, px.y - r, px.x + r, px.y + r))
    container_path_pop()
}

struct DragLineState {
    //! A draggable infinite line. `value` is its position on its own axis (x for
    //! drag_line_x, y for drag_line_y) in DATA coords; `held` true while grabbed.
    value : double
    held : bool
}

def public drag_line_x(var state : DragLineState; id : string; col : float4;
                       thickness : float = 1.0f;
                       flags : ImPlotDragToolFlags = ImPlotDragToolFlags.None) {
    //! `DragLineX(id, &x, col, thickness, flags)` — a draggable vertical line at x=value.
    let seed = int(GetID(id))
    widget_prelude(id)
    container_path_push(id)
    state.held = DragLineX(seed, unsafe(addr(state.value)), col, thickness, flags)
    let ppos = GetPlotPos()
    let psz = GetPlotSize()
    let sx = PlotToPixels(state.value, 0.0lf, ImAxis.X1, ImAxis.Y1).x
    finalize_state(id, "implot_drag_line_x", state,
                   float4(sx - 3.0f, ppos.y, sx + 3.0f, ppos.y + psz.y))
    container_path_pop()
}

def public drag_line_y(var state : DragLineState; id : string; col : float4;
                       thickness : float = 1.0f;
                       flags : ImPlotDragToolFlags = ImPlotDragToolFlags.None) {
    //! `DragLineY(id, &y, col, thickness, flags)` — a draggable horizontal line at y=value.
    let seed = int(GetID(id))
    widget_prelude(id)
    container_path_push(id)
    state.held = DragLineY(seed, unsafe(addr(state.value)), col, thickness, flags)
    let ppos = GetPlotPos()
    let psz = GetPlotSize()
    let sy = PlotToPixels(0.0lf, state.value, ImAxis.X1, ImAxis.Y1).y
    finalize_state(id, "implot_drag_line_y", state,
                   float4(ppos.x, sy - 3.0f, ppos.x + psz.x, sy + 3.0f))
    container_path_pop()
}

struct DragRectState {
    //! A draggable axis-aligned rectangle in DATA coords — edges, corners, and body
    //! all drag the bounds in place. `held` true while any part is grabbed.
    x_min : double
    y_min : double
    x_max : double
    y_max : double
    held : bool
}

def public drag_rect(var state : DragRectState; id : string; col : float4;
                     flags : ImPlotDragToolFlags = ImPlotDragToolFlags.None) {
    //! `DragRect(id, &x1,&y1,&x2,&y2, col, flags)` — a draggable rectangle region.
    let seed = int(GetID(id))
    widget_prelude(id)
    container_path_push(id)
    state.held = DragRect(seed, unsafe(addr(state.x_min)), unsafe(addr(state.y_min)),
                          unsafe(addr(state.x_max)), unsafe(addr(state.y_max)), col, flags)
    // data y_max projects to the SMALLER screen y, so (x_min,y_max)=top-left,
    // (x_max,y_min)=bottom-right.
    let tl = PlotToPixels(state.x_min, state.y_max, ImAxis.X1, ImAxis.Y1)
    let br = PlotToPixels(state.x_max, state.y_min, ImAxis.X1, ImAxis.Y1)
    finalize_state(id, "implot_drag_rect", state, float4(tl.x, tl.y, br.x, br.y))
    container_path_pop()
}

// ===== Coordinate conversion =====

def public plot_to_pixels(x : double; y : double;
                          x_axis : ImAxis = ImAxis.X1; y_axis : ImAxis = ImAxis.Y1) : float2 {
    //! `PlotToPixels(x, y, ...)` — data coords → screen pixels (valid in-scope).
    return PlotToPixels(x, y, x_axis, y_axis)
}

def public pixels_to_plot(px : float2;
                          x_axis : ImAxis = ImAxis.X1; y_axis : ImAxis = ImAxis.Y1) : ImPlotPoint {
    //! `PixelsToPlot(px, ...)` — screen pixels → data coords (valid in-scope).
    return PixelsToPlot(px, x_axis, y_axis)
}

// ===== Colormaps =====
//
// A colormap maps a normalized t in [0,1] to a color. Push one (with_colormap /
// push_colormap) and the auto-colored items + heatmaps inside it sample their colors
// from it; colormap_scale draws the matching colorbar legend. `cmap` is the
// ImPlotColormap enum (Deep / Viridis / Plasma / Jet / Greys / …) — passed straight
// through (the binding exposes ImPlot's typedef-int colormap handle AS the enum).

def public push_colormap(cmap : ImPlotColormap) {
    //! `PushColormap(cmap)` — make `cmap` the active colormap for subsequent items.
    //! Balance with `pop_colormap` (or use `with_colormap` for the RAII scope).
    PushColormap(cmap)
}

def public pop_colormap(count : int = 1) {
    //! `PopColormap(count)` — restore the colormap(s) pushed by `push_colormap`.
    PopColormap(count)
}

def public with_colormap(cmap : ImPlotColormap; blk : block) {
    //! `PushColormap(cmap)` / `PopColormap()` around `blk` — RAII colormap scope so the
    //! pop can't be skipped. Auto-colored items / heatmaps in the body sample from `cmap`.
    PushColormap(cmap)
    invoke(blk)
    PopColormap(1)
}

def public colormap_scale(label_id : string; scale_min : double; scale_max : double;
                          cmap : ImPlotColormap; size : float2 = float2(0.0f, 0.0f);
                          fmt : string = "%g";
                          flags : ImPlotColormapScaleFlags = ImPlotColormapScaleFlags.None) {
    //! `ColormapScale(...)` — draw a vertical colorbar legend spanning [scale_min, scale_max]
    //! for `cmap` (pass the same colormap you pushed). Pair with a heatmap to label its
    //! value→color mapping.
    ColormapScale(label_id, scale_min, scale_max, size, fmt, flags, cmap)
}

def public sample_colormap(t : float; cmap : ImPlotColormap) : float4 {
    //! `SampleColormap(t, cmap)` — the color at normalized position `t` in [0,1] of `cmap`.
    return SampleColormap(t, cmap)
}
