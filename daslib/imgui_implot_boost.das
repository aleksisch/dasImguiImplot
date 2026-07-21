options gen2
options _comment_hygiene = true
options indenting = 4
options no_unused_block_arguments = false
options no_unused_function_arguments = false

module imgui_implot_boost shared

// v1 "thin" wrapper over the implot native binding: RAII plot/subplot scopes (so EndPlot
// can never be skipped) + sensible defaults on the core Plot* item family. double-typed —
// ImPlot is double-native. The v2 DSL (imgui_implot_boost_v2) adds multi-type data,
// styling builders, the full item set, and the playwright snapshot hook.

require implot public

// ===== Scopes =====

// Begin a plot, run the body only if it is visible, and always End it. The ImPlot
// contract is that EndPlot runs iff BeginPlot returned true — this enforces it.
// daslang binds the trailing block to the param right after the explicit args, so the
// optional size/flags are arity overloads rather than default arguments.
def public with_plot(title : string; blk : block) {
    if (BeginPlot(title, float2(-1.0f, 0.0f), ImPlotFlags.None)) {
        invoke(blk)
        EndPlot()
    }
}
def public with_plot(title : string; size : float2; blk : block) {
    if (BeginPlot(title, size, ImPlotFlags.None)) {
        invoke(blk)
        EndPlot()
    }
}
def public with_plot(title : string; size : float2; flags : ImPlotFlags; blk : block) {
    if (BeginPlot(title, size, flags)) {
        invoke(blk)
        EndPlot()
    }
}

// Begin a rows x cols subplot grid, run the body if visible, always End it.
def public with_subplots(title : string; rows : int; cols : int; size : float2; blk : block) {
    if (BeginSubplots(title, rows, cols, size, ImPlotSubplotFlags.None)) {
        invoke(blk)
        EndSubplots()
    }
}
def public with_subplots(title : string; rows : int; cols : int; size : float2;
                         flags : ImPlotSubplotFlags; blk : block) {
    if (BeginSubplots(title, rows, cols, size, flags)) {
        invoke(blk)
        EndSubplots()
    }
}

// Begin a group of axis-aligned plots, run the body if it began, always End it.
def public with_aligned_plots(group_id : string; blk : block) {
    if (BeginAlignedPlots(group_id)) {   // native default vertical = true
        invoke(blk)
        EndAlignedPlots()
    }
}
def public with_aligned_plots(group_id : string; vertical : bool; blk : block) {
    if (BeginAlignedPlots(group_id, vertical)) {
        invoke(blk)
        EndAlignedPlots()
    }
}

// ===== Style scopes (Push/Pop — always balanced) =====

// Push a colormap for the body; auto-colored items + heatmaps inside sample from it.
def public with_colormap(cmap : ImPlotColormap; blk : block) {
    PushColormap(cmap)
    invoke(blk)
    PopColormap(1)
}

// Push one ImPlotCol color override (e.g. ImPlotCol.Line) for the body.
def public with_style_color(idx : ImPlotCol; col : float4; blk : block) {
    implot::PushStyleColor(idx, col)
    invoke(blk)
    implot::PopStyleColor(1)
}

// Push one ImPlotStyleVar override for the body — float / int / float2 forms.
def public with_style_var(idx : ImPlotStyleVar; value : float; blk : block) {
    implot::PushStyleVar(idx, value)
    invoke(blk)
    implot::PopStyleVar(1)
}
def public with_style_var(idx : ImPlotStyleVar; value : int; blk : block) {
    implot::PushStyleVar(idx, value)
    invoke(blk)
    implot::PopStyleVar(1)
}
def public with_style_var(idx : ImPlotStyleVar; value : float2; blk : block) {
    implot::PushStyleVar(idx, value)
    invoke(blk)
    implot::PopStyleVar(1)
}

// Clip drawing to the plot area (optionally expanded by `expand` px) for the body.
def public with_plot_clip_rect(blk : block) {
    PushPlotClipRect()   // native default expand = 0
    invoke(blk)
    PopPlotClipRect()
}
def public with_plot_clip_rect(expand : float; blk : block) {
    PushPlotClipRect(expand)
    invoke(blk)
    PopPlotClipRect()
}

// ===== Popup & drag-and-drop scopes (body runs iff Begin succeeded) =====

// A legend popup (default right mouse button); body emits its contents.
def public with_legend_popup(label_id : string; blk : block) {
    if (BeginLegendPopup(label_id)) {   // native default mouse button = right
        invoke(blk)
        EndLegendPopup()
    }
}
def public with_legend_popup(label_id : string; mouse_button : int; blk : block) {
    if (BeginLegendPopup(label_id, mouse_button)) {
        invoke(blk)
        EndLegendPopup()
    }
}

// Drag-drop SOURCE on the last item / the whole plot / an axis.
def public with_drag_drop_source_item(label_id : string; blk : block) {
    if (BeginDragDropSourceItem(label_id)) {   // native default flags = 0
        invoke(blk)
        implot::EndDragDropSource()
    }
}
def public with_drag_drop_source_item(label_id : string; flags : int; blk : block) {
    if (BeginDragDropSourceItem(label_id, flags)) {
        invoke(blk)
        implot::EndDragDropSource()
    }
}
def public with_drag_drop_source_plot(blk : block) {
    if (BeginDragDropSourcePlot()) {   // native default flags = 0
        invoke(blk)
        implot::EndDragDropSource()
    }
}
def public with_drag_drop_source_plot(flags : int; blk : block) {
    if (BeginDragDropSourcePlot(flags)) {
        invoke(blk)
        implot::EndDragDropSource()
    }
}
def public with_drag_drop_source_axis(axis : ImAxis; blk : block) {
    if (BeginDragDropSourceAxis(axis)) {   // native default flags = 0
        invoke(blk)
        implot::EndDragDropSource()
    }
}
def public with_drag_drop_source_axis(axis : ImAxis; flags : int; blk : block) {
    if (BeginDragDropSourceAxis(axis, flags)) {
        invoke(blk)
        implot::EndDragDropSource()
    }
}

// Drag-drop TARGET on the whole plot / an axis / the legend.
def public with_drag_drop_target_plot(blk : block) {
    if (BeginDragDropTargetPlot()) {
        invoke(blk)
        implot::EndDragDropTarget()
    }
}
def public with_drag_drop_target_axis(axis : ImAxis; blk : block) {
    if (BeginDragDropTargetAxis(axis)) {
        invoke(blk)
        implot::EndDragDropTarget()
    }
}
def public with_drag_drop_target_legend(blk : block) {
    if (BeginDragDropTargetLegend()) {
        invoke(blk)
        implot::EndDragDropTarget()
    }
}

// ===== Axis setup =====

def public setup_axes(x_label : string; y_label : string) {
    SetupAxes(x_label, y_label, ImPlotAxisFlags.None, ImPlotAxisFlags.None)
}

def public setup_axes_limits(x_min : double; x_max : double; y_min : double; y_max : double;
                             cond : ImPlotCond = ImPlotCond.Once) {
    SetupAxesLimits(x_min, x_max, y_min, y_max, cond)
}

def public setup_axis_limits(axis : ImAxis; v_min : double; v_max : double;
                             cond : ImPlotCond = ImPlotCond.Once) {
    SetupAxisLimits(axis, v_min, v_max, cond)
}

// ===== Plot items (double, with defaults) =====

def public plot_line(label_id : string; values : array<double>;
                     xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    PlotLine(label_id, values, xscale, xstart, flags)
}
def public plot_line(label_id : string; xs : array<double>; ys : array<double>; flags : int = 0) {
    PlotLine(label_id, xs, ys, flags)
}

def public plot_scatter(label_id : string; values : array<double>;
                        xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    PlotScatter(label_id, values, xscale, xstart, flags)
}
def public plot_scatter(label_id : string; xs : array<double>; ys : array<double>; flags : int = 0) {
    PlotScatter(label_id, xs, ys, flags)
}

def public plot_stairs(label_id : string; values : array<double>;
                       xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    PlotStairs(label_id, values, xscale, xstart, flags)
}
def public plot_stairs(label_id : string; xs : array<double>; ys : array<double>; flags : int = 0) {
    PlotStairs(label_id, xs, ys, flags)
}

def public plot_bars(label_id : string; values : array<double>;
                     bar_size : double = 0.67lf; shift : double = 0.0lf; flags : int = 0) {
    PlotBars(label_id, values, bar_size, shift, flags)
}
def public plot_bars(label_id : string; xs : array<double>; ys : array<double>;
                     bar_size : double; flags : int = 0) {
    PlotBars(label_id, xs, ys, bar_size, flags)
}

def public plot_shaded(label_id : string; values : array<double>; yref : double = 0.0lf;
                       xscale : double = 1.0lf; xstart : double = 0.0lf; flags : int = 0) {
    PlotShaded(label_id, values, yref, xscale, xstart, flags)
}
def public plot_shaded(label_id : string; xs : array<double>; ys : array<double>;
                       yref : double = 0.0lf; flags : int = 0) {
    PlotShaded(label_id, xs, ys, yref, flags)
}
def public plot_shaded_between(label_id : string; xs : array<double>;
                               ys1 : array<double>; ys2 : array<double>; flags : int = 0) {
    PlotShaded(label_id, xs, ys1, ys2, flags)
}

def public plot_stems(label_id : string; values : array<double>; ref : double = 0.0lf;
                      scale : double = 1.0lf; start : double = 0.0lf; flags : int = 0) {
    PlotStems(label_id, values, ref, scale, start, flags)
}
def public plot_stems(label_id : string; xs : array<double>; ys : array<double>;
                      ref : double = 0.0lf; flags : int = 0) {
    PlotStems(label_id, xs, ys, ref, flags)
}

def public plot_inf_lines(label_id : string; values : array<double>; flags : int = 0) {
    PlotInfLines(label_id, values, flags)
}
