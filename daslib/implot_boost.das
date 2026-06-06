options gen2
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
