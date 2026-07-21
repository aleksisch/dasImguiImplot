options gen2
options _comment_hygiene = true

require imgui/imgui_harness
require imgui/imgui_containers_builtin
require imgui/imgui_widgets_builtin
require imgui/imgui_implot_boost_v2
require implot

// =============================================================================
// TUTORIAL: bar_groups_and_pie — the two categorical / labelled items.
//
//   plot_bar_groups(label_ids, values, item_count, group_count)  — item_count series
//       clustered into group_count groups. `values` is a flat item_count*group_count
//       row-major matrix (values[item*group_count+group]); `label_ids` names one
//       series per row (they show up in the legend). The Stacked / Horizontal flags
//       restack / reorient the bars.
//   plot_pie_chart(label_ids, values, x, y, radius)              — one slice per
//       (label, value) pair, centered at data-coords (x, y). Pie plots want square,
//       decoration-free axes spanning [0,1].
//
// Both take label_ids : array<string> — a daslang string array IS already a
// const char* const[] block, so it passes straight to ImPlot.
//
// STANDALONE: daslang.exe modules/dasImguiImplot/examples/tutorial/bar_groups_and_pie.das
// LIVE:       daslang-live modules/dasImguiImplot/examples/tutorial/bar_groups_and_pie.das
// =============================================================================

let ITEMS = 3      // series (one label / color each)
let GROUPS = 4     // clusters along the x-axis

var g_ctx : ImPlotContext?
var g_bar_labels : array<string>
var g_bar_values : array<double>     // ITEMS*GROUPS, row-major
var g_pie_labels : array<string>
var g_pie_values : array<double>

[export]
def init() {
    harness_init("dasImguiImplot — bar_groups_and_pie", 1280, 720)
    g_ctx = implot::CreateContext()

    // One row of GROUPS values per series, laid out flat (values[item*GROUPS+group]).
    g_bar_labels <- ["merchant", "consumer", "industrial"]
    g_bar_values <- [10.0lf, 14.0lf,  9.0lf, 12.0lf,    // merchant
                      8.0lf, 11.0lf, 13.0lf,  7.0lf,    // consumer
                      6.0lf,  9.0lf, 15.0lf, 10.0lf]    // industrial

    // One slice per (label, value); values need not be normalized.
    g_pie_labels <- ["rent", "food", "transit", "savings"]
    g_pie_values <- [35.0lf, 25.0lf, 18.0lf, 22.0lf]
}

[export]
def update() {
    if (!harness_begin_frame()) return
    harness_new_frame()

    SetNextWindowPos(float2(20.0, 20.0), ImGuiCond.Always)
    SetNextWindowSize(float2(1240.0, 680.0), ImGuiCond.Always)
    window(PLOT_WIN, (text = "bar groups & pie", closable = false,
                      flags = ImGuiWindowFlags.None)) {
        text("plot_bar_groups clusters labelled series; plot_pie_chart splits a whole.")
        plot(BARS, (title = "quarterly volume", size = float2(560.0f, 560.0f),
                    flags = ImPlotFlags.None)) {
            setup_axes("group", "value")
            setup_axes_limits(-0.5lf, double(GROUPS) - 0.5lf, 0.0lf, 18.0lf, ImPlotCond.Always)
            plot_bar_groups(g_bar_labels, g_bar_values, ITEMS, GROUPS)
        }
        same_line()
        plot(PIE, (title = "budget split", size = float2(-1.0f, 560.0f),
                   flags = ImPlotFlags.Equal)) {
            setup_axes("", "", ImPlotAxisFlags.NoDecorations, ImPlotAxisFlags.NoDecorations)
            setup_axes_limits(0.0lf, 1.0lf, 0.0lf, 1.0lf, ImPlotCond.Always)
            plot_pie_chart(g_pie_labels, g_pie_values, 0.5lf, 0.5lf, 0.45lf, "%.0f%%")
        }
    }

    harness_end_frame()
}

[export]
def shutdown() {
    if (g_ctx != null) {
        DestroyContext(g_ctx)
    }
    harness_shutdown()
}

[export]
def main() {
    init()
    while (!exit_requested()) {
        update()
    }
    shutdown()
}
