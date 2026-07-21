options gen2
options _comment_hygiene = true
options rtti = true

require daslib/fio
require daslib/rtti
require daslib/ast
require daslib/rst_comment
require daslib/rst
require daslib/regex
require daslib/regex_boost
require daslib/profiler_boost

// Pull in every documented module so RTTI can see them. The v1 thin-wrapper
// module (imgui_implot_boost) is intentionally excluded — it is a near-1:1
// passthrough over the native binding, covered by the v2 page + examples.
require imgui/imgui_implot_boost_v2
require imgui/imgui_implot_app
require imgui/imgui_implot_playwright


def document_module_imgui_implot_boost_v2() {
    var mod = find_module("imgui_implot_boost_v2")
    // plot / subplots are [container] macros (no documentable render function
    // survives expansion), so they auto-list under "Call macros" and are
    // explained in prose in the handmade intro.
    var groups <- array<DocGroup>(
        group_by_regex("Axis & legend setup", mod, %regex~^(setup_axes|setup_axis|setup_axes_limits|setup_axis_limits|setup_legend|set_axis|set_axes)$%%),
        group_by_regex("Next-item styling",   mod, %regex~^(next_line_style|next_fill_style|next_marker_style|next_axes_limits|next_axes_to_fit)$%%),
        group_by_regex("Plot items",          mod, %regex~^(plot_line|plot_scatter|plot_stairs|plot_bars|plot_stems|plot_shaded|plot_shaded_between|plot_inf_lines|plot_text|plot_dummy|plot_error_bars|plot_digital|plot_heatmap|histogram|histogram2d|plot_bar_groups|plot_pie_chart)$%%),
        group_by_regex("Drag tools",          mod, %regex~^(drag_point|drag_line_x|drag_line_y|drag_rect)$%%),
        group_by_regex("Colormaps",           mod, %regex~^(push_colormap|pop_colormap|with_colormap|colormap_scale|sample_colormap)$%%),
        group_by_regex("Coordinate conversion", mod, %regex~^(plot_to_pixels|pixels_to_plot)$%%),
        hide_group(group_by_regex("Finalizers", mod, %regex~^(finalize_.*|.*_finalize)$%%)),
        hide_group(group_by_regex("Internal",   mod, %regex~^(_|priv_).*%%))
    )
    document("Boost v2 — the ImPlot DSL: snapshot plot scopes, OR-typed items, Setup*/SetNext* styling, drag tools, coordinate helpers", mod, "imgui_implot_boost_v2.rst", groups)
}

def document_module_imgui_implot_app() {
    var mod = find_module("imgui_implot_app")
    var groups <- array<DocGroup>(
        group_by_regex("App harness", mod, %regex~^with_implot(_recording)?_app$%%),
        hide_group(group_by_regex("Internal", mod, %regex~^(_|priv_).*%%))
    )
    document("App harness — with_implot_app + with_implot_recording_app, thin ImPlot delegates over imgui_playwright's with_imgui_app / with_recording_app", mod, "imgui_implot_app.rst", groups)
}

def document_module_imgui_implot_playwright() {
    var mod = find_module("imgui_implot_playwright")
    var groups <- array<DocGroup>(
        group_by_regex("Session",            mod, %regex~^implot_open$%%),
        group_by_regex("Reads",              mod, %regex~^(implot_snapshot|plot_payload|plot_visible|plot_hovered|plot_axis_limits|plot_axis_limit|plot_mouse_pos|plot_bbox|plot_center)$%%),
        group_by_regex("Axis drag",          mod, %regex~^drag_axis$%%),
        group_by_regex("Drag-tool handles",  mod, %regex~^(handle_path|drag_point_value|drag_line_value|drag_rect_value|drag_held)$%%),
        group_by_regex("Legend",             mod, %regex~^(legend_entry|legend_entry_center|series_shown|legend_toggle|wait_for_legend_hover|wait_for_series_shown)$%%),
        group_by_regex("Polling / await",    mod, %regex~^(implot_wait_visible|wait_for_axis_limits|wait_for_axis_limit_changed|wait_for_hovered|wait_for_point_moved)$%%),
        hide_group(group_by_regex("Internal", mod, %regex~^(_|priv_).*%%))
    )
    document("ImPlot playwright — ImPlot-aware test layer over imgui_playwright (PlotSession + plot_* / drag_* readers and wait_for_* polls)", mod, "imgui_implot_playwright.rst", groups)
}


// dasImguiImplot repo root, derived from a loaded module's own source path so
// docs generate correctly under both -load_module (dev) and daspkg-install (CI),
// without assuming the package lives under <das_root>/modules/.
def dasimguiimplot_root() : string {
    let m = find_module("imgui_implot_boost_v2")
    assert(m != null, "imgui_implot_boost_v2 not loaded — cannot locate dasImguiImplot root")
    return dir_name(dir_name(string(m.fileName)))
}

[export]
def main {
    disable_profiler(this_context())
    disable_profiler_log(this_context())
    ast_gc_guard() {
        let impl_doc = dasimguiimplot_root() + "/doc/source/stdlib"
        topic_root = "{impl_doc}/generated"
        handmade_root = impl_doc

        document_module_imgui_implot_boost_v2()
        document_module_imgui_implot_app()
        document_module_imgui_implot_playwright()
    }
}
