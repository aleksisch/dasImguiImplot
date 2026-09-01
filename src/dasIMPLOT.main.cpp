#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMPLOT.h"
#include "need_dasIMPLOT.h"
#include "aot_dasIMPLOT.h"

// implot_internal.h for the legend telemetry forwarders below (GetCurrentPlot / ImPlotItemGroup).
// IMGUI_DEFINE_MATH_OPERATORS so the ImVec2 math in imgui_internal.h's inline helpers compiles,
// mirroring implot.cpp's own include preamble.
#ifndef IMGUI_DEFINE_MATH_OPERATORS
#define IMGUI_DEFINE_MATH_OPERATORS
#endif
#include <implot_internal.h>

namespace das {

// ImPlot's Plot* functions are C++ templates; libclang skips them in the binder, so we
// expose concrete float/double/int instantiations as plain forwarders. A daslang array
// binds as const TArray<T>& and is contiguous, so upstream offset/stride are fixed
// (0 / sizeof(T)) and dropped from the surface. TArray<T>::data is char* (inherited from
// Array) — cast to (const T*) or the template deduces char -> uninstantiated PlotLine<char>.
// Every ImPlot*Flags is `typedef int`, so the flags int passes straight through.

#define IMPLOT_N2(a, b) ((int)((a).size < (b).size ? (a).size : (b).size))

// Line / Scatter / Stairs: values(xscale,xstart) + xs/ys
#define FWD_LINELIKE(NAME, SUF, T) \
    void NAME##_v_##SUF(const char* l, const TArray<T>& v, double xscale, double xstart, int flags) { \
        ImPlot::NAME(l, (const T*)v.data, (int)v.size, xscale, xstart, flags); } \
    void NAME##_xy_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, int flags) { \
        ImPlot::NAME(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), flags); }
#define FWD_LINELIKE_ALL(NAME) FWD_LINELIKE(NAME, f, float) FWD_LINELIKE(NAME, d, double) FWD_LINELIKE(NAME, i, int32_t)
FWD_LINELIKE_ALL(PlotLine)
FWD_LINELIKE_ALL(PlotScatter)
FWD_LINELIKE_ALL(PlotStairs)

// Bars: values(bar_size,shift) + xs/ys(bar_size)
#define FWD_BARS(SUF, T) \
    void PlotBars_v_##SUF(const char* l, const TArray<T>& v, double bar_size, double shift, int flags) { \
        ImPlot::PlotBars(l, (const T*)v.data, (int)v.size, bar_size, shift, flags); } \
    void PlotBars_xy_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, double bar_size, int flags) { \
        ImPlot::PlotBars(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), bar_size, flags); }
FWD_BARS(f, float) FWD_BARS(d, double) FWD_BARS(i, int32_t)

// Stems: values(ref,scale,start) + xs/ys(ref)
#define FWD_STEMS(SUF, T) \
    void PlotStems_v_##SUF(const char* l, const TArray<T>& v, double ref, double scale, double start, int flags) { \
        ImPlot::PlotStems(l, (const T*)v.data, (int)v.size, ref, scale, start, flags); } \
    void PlotStems_xy_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, double ref, int flags) { \
        ImPlot::PlotStems(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), ref, flags); }
FWD_STEMS(f, float) FWD_STEMS(d, double) FWD_STEMS(i, int32_t)

// Shaded: values(yref,xscale,xstart) + xs/ys(yref) + xs/ys1/ys2
#define FWD_SHADED(SUF, T) \
    void PlotShaded_v_##SUF(const char* l, const TArray<T>& v, double yref, double xscale, double xstart, int flags) { \
        ImPlot::PlotShaded(l, (const T*)v.data, (int)v.size, yref, xscale, xstart, flags); } \
    void PlotShaded_xy_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, double yref, int flags) { \
        ImPlot::PlotShaded(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), yref, flags); } \
    void PlotShaded_xy2_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys1, const TArray<T>& ys2, int flags) { \
        ImPlot::PlotShaded(l, (const T*)xs.data, (const T*)ys1.data, (const T*)ys2.data, IMPLOT_N2(xs, ys1), flags); }
FWD_SHADED(f, float) FWD_SHADED(d, double) FWD_SHADED(i, int32_t)

// InfLines: values only
#define FWD_INFLINES(SUF, T) \
    void PlotInfLines_v_##SUF(const char* l, const TArray<T>& v, int flags) { \
        ImPlot::PlotInfLines(l, (const T*)v.data, (int)v.size, flags); }
FWD_INFLINES(f, float) FWD_INFLINES(d, double) FWD_INFLINES(i, int32_t)

// ===== Templated item families (statistical / 2D) =====
// Same template-skip story as the line family. Struct args (ImPlotPoint / ImPlotRange /
// ImPlotRect) are flattened to scalar doubles so the daslang surface stays vector-free.
// label_fmt: an empty das string maps to nullptr — ImPlot's "draw no cell/slice labels".
static inline const char* implot_nz(const char* s) { return (s && s[0]) ? s : nullptr; }

// ErrorBars: symmetric (err) + asymmetric (neg/pos)
#define FWD_ERRORBARS(SUF, T) \
    void PlotErrorBars_sym_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, const TArray<T>& err, int flags) { \
        ImPlot::PlotErrorBars(l, (const T*)xs.data, (const T*)ys.data, (const T*)err.data, IMPLOT_N2(xs, ys), flags); } \
    void PlotErrorBars_asym_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, const TArray<T>& neg, const TArray<T>& pos, int flags) { \
        ImPlot::PlotErrorBars(l, (const T*)xs.data, (const T*)ys.data, (const T*)neg.data, (const T*)pos.data, IMPLOT_N2(xs, ys), flags); }
FWD_ERRORBARS(f, float) FWD_ERRORBARS(d, double) FWD_ERRORBARS(i, int32_t)

// Digital: xs/ys step signal
#define FWD_DIGITAL(SUF, T) \
    void PlotDigital_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, int flags) { \
        ImPlot::PlotDigital(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), flags); }
FWD_DIGITAL(f, float) FWD_DIGITAL(d, double) FWD_DIGITAL(i, int32_t)

// Heatmap: flat row-major values, rows x cols, scalar bounds rect
#define FWD_HEATMAP(SUF, T) \
    void PlotHeatmap_##SUF(const char* l, const TArray<T>& v, int rows, int cols, double scale_min, double scale_max, \
                           const char* label_fmt, double bx0, double by0, double bx1, double by1, int flags) { \
        ImPlot::PlotHeatmap(l, (const T*)v.data, rows, cols, scale_min, scale_max, implot_nz(label_fmt), \
                            ImPlotPoint(bx0, by0), ImPlotPoint(bx1, by1), flags); }
FWD_HEATMAP(f, float) FWD_HEATMAP(d, double) FWD_HEATMAP(i, int32_t)

// Histogram (1D): returns max bin count; range (min==max) => auto-range
#define FWD_HISTOGRAM(SUF, T) \
    double PlotHistogram_##SUF(const char* l, const TArray<T>& v, int bins, double bar_scale, double range_min, double range_max, int flags) { \
        return ImPlot::PlotHistogram(l, (const T*)v.data, (int)v.size, bins, bar_scale, ImPlotRange(range_min, range_max), flags); }
FWD_HISTOGRAM(f, float) FWD_HISTOGRAM(d, double) FWD_HISTOGRAM(i, int32_t)

// Histogram2D: returns max bin count; rect (all zero) => auto-range
#define FWD_HISTOGRAM2D(SUF, T) \
    double PlotHistogram2D_##SUF(const char* l, const TArray<T>& xs, const TArray<T>& ys, int x_bins, int y_bins, \
                                 double x0, double x1, double y0, double y1, int flags) { \
        return ImPlot::PlotHistogram2D(l, (const T*)xs.data, (const T*)ys.data, IMPLOT_N2(xs, ys), x_bins, y_bins, \
                                       ImPlotRect(x0, x1, y0, y1), flags); }
FWD_HISTOGRAM2D(f, float) FWD_HISTOGRAM2D(d, double) FWD_HISTOGRAM2D(i, int32_t)

// ===== Categorical / labelled families =====
// These take a per-series label array. A daslang array<string> binds as TArray<char*>
// whose contiguous element block IS const char* const[] (each element is already a
// char*), so labels.data casts straight through with no per-call repacking — same fact
// dasImgui's list_box relies on. Values stay element-typed like the other families.

// BarGroups: item_count series x group_count groups, row-major (values[item*group_count+group])
#define FWD_BARGROUPS(SUF, T) \
    void PlotBarGroups_##SUF(const TArray<char*>& labels, const TArray<T>& v, int item_count, int group_count, \
                             double group_size, double shift, int flags) { \
        ImPlot::PlotBarGroups((const char* const*)labels.data, (const T*)v.data, item_count, group_count, \
                              group_size, shift, flags); }
FWD_BARGROUPS(f, float) FWD_BARGROUPS(d, double) FWD_BARGROUPS(i, int32_t)

// PieChart: one slice per (label, value); count = min(labels, values). Empty fmt => no labels.
#define FWD_PIECHART(SUF, T) \
    void PlotPieChart_##SUF(const TArray<char*>& labels, const TArray<T>& v, double x, double y, double radius, \
                            const char* label_fmt, double angle0, int flags) { \
        ImPlot::PlotPieChart((const char* const*)labels.data, (const T*)v.data, IMPLOT_N2(labels, v), \
                             x, y, radius, implot_nz(label_fmt), angle0, flags); }
FWD_PIECHART(f, float) FWD_PIECHART(d, double) FWD_PIECHART(i, int32_t)

// ===== Legend telemetry (read AFTER EndPlot, by plot title) =====
// ImPlot keeps per-series visibility (ImPlotItem::Show) and the per-entry legend button rect
// internal, and BOTH are written DURING EndPlot's legend render (ShowLegendEntries) — so the v2
// `plot` scope reads them right AFTER EndPlot via GetPlot(title), which gives current-frame
// values (the plot persists past EndPlot; Legend.Indices isn't reset until the next BeginPlot).
// Reading before EndPlot would serialize last frame's rects (zero on the first visible frame,
// stale after a resize), so the title-keyed post-EndPlot read is the correct one. The scope
// serializes a per-series {label, shown, rect} list into the snapshot so a test / recording can
// target a synthetic legend-toggle click and verify the series hid / showed. `index` is always
// submission order — GetLegendItem/Label index Legend.Indices; the Sort flag only reorders the
// render pass, not this. The rect is screen-space pixels (LegendHoverRect, patched to update
// every frame — see implot.cpp). All return empty / zero when the plot or index is unknown.
int LegendEntryCount(const char* title) {
    ImPlotPlot* plot = ImPlot::GetPlot(title);
    return plot ? plot->Items.GetLegendCount() : 0;
}
// allocateString (das heap), NOT the raw GetLegendLabel pointer: that points into ImPlot's
// per-frame Legend.Labels buffer, which the next BeginPlot/SetupFinish resets and may realloc — a
// raw return would dangle by the time the snapshot serializes a frame later (empty/garbage on
// macOS, issue #9). Owning the bytes here keeps the das string valid; mirrors the rest of the
// string-returning API (dasImgui's text_range_string / ImGTB_Slice).
char* LegendEntryLabel(const char* title, int index, das::Context* context, das::LineInfoArg* at) {
    ImPlotPlot* plot = ImPlot::GetPlot(title);
    if (!plot || index < 0 || index >= plot->Items.GetLegendCount())
        return context->allocateString(nullptr, 0, at);
    const char* label = plot->Items.GetLegendLabel(index);
    return context->allocateString(label, strlen(label), at);
}
bool LegendEntryShown(const char* title, int index) {
    ImPlotPlot* plot = ImPlot::GetPlot(title);
    if (!plot || index < 0 || index >= plot->Items.GetLegendCount()) return false;
    ImPlotItem* item = plot->Items.GetLegendItem(index);
    return item ? item->Show : false;
}
bool LegendEntryHovered(const char* title, int index) {
    // ImPlotItem::LegendHovered is reset to false at the top of EndPlot's legend block and set
    // during the entry render, so a post-EndPlot read via GetPlot(title) reflects this frame.
    ImPlotPlot* plot = ImPlot::GetPlot(title);
    if (!plot || index < 0 || index >= plot->Items.GetLegendCount()) return false;
    ImPlotItem* item = plot->Items.GetLegendItem(index);
    return item ? item->LegendHovered : false;
}
ImVec4 LegendEntryRect(const char* title, int index) {
    ImPlotPlot* plot = ImPlot::GetPlot(title);
    if (!plot || index < 0 || index >= plot->Items.GetLegendCount()) return ImVec4(0, 0, 0, 0);
    ImPlotItem* item = plot->Items.GetLegendItem(index);
    if (!item) return ImVec4(0, 0, 0, 0);
    const ImRect& r = item->LegendHoverRect;
    return ImVec4(r.Min.x, r.Min.y, r.Max.x, r.Max.y);
}

// Per-axis range telemetry — read one plot axis's data-coord range and whether it's enabled, so the
// `plot` snapshot can capture SECONDARY axes (Y2/Y3/X2/X3). GetPlotLimits only pairs the X1/Y1
// primaries; on a multi-axis plot (e.g. pressure on Y2) the others are invisible without this.
// MUST be called between BeginPlot/EndPlot — GetCurrentPlot() is valid only in-scope. AxisEnabled
// gates the capture: a disabled axis's Range is meaningless (default/zero), so only active axes are
// serialized. `axis` is an ImAxis (X1=0..Y3=5).
bool AxisEnabled(int axis) {
    ImPlotPlot* plot = ImPlot::GetCurrentPlot();
    return plot && axis >= 0 && axis < ImAxis_COUNT && plot->Axes[axis].Enabled;
}
// Min/Max as separate scalar forwarders — ImPlotRange is a plain local_type struct with no
// by-value cast_res binding (unlike ImVec4 -> float4), so the range is returned as two doubles.
double AxisRangeMin(int axis) {
    ImPlotPlot* plot = ImPlot::GetCurrentPlot();
    if (!plot || axis < 0 || axis >= ImAxis_COUNT) return 0.0;
    return plot->Axes[axis].Range.Min;
}
double AxisRangeMax(int axis) {
    ImPlotPlot* plot = ImPlot::GetCurrentPlot();
    if (!plot || axis < 0 || axis >= ImAxis_COUNT) return 0.0;
    return plot->Axes[axis].Range.Max;
}

void Module_dasIMPLOT::initAotAlias () {
}

// Registration helpers — each forwarder registered under its ImPlot PascalCase name,
// overloaded by array element type.
#define REG_LINELIKE(NAME, SUF) \
    addExtern<DAS_BIND_FUN(das::NAME##_v_##SUF)>(*this, lib, #NAME, \
        SideEffects::modifyExternal, "das::" #NAME "_v_" #SUF)->args({"label","values","xscale","xstart","flags"}); \
    addExtern<DAS_BIND_FUN(das::NAME##_xy_##SUF)>(*this, lib, #NAME, \
        SideEffects::modifyExternal, "das::" #NAME "_xy_" #SUF)->args({"label","xs","ys","flags"});
#define REG_LINELIKE_ALL(NAME) REG_LINELIKE(NAME, f) REG_LINELIKE(NAME, d) REG_LINELIKE(NAME, i)

#define REG_BARS(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotBars_v_##SUF)>(*this, lib, "PlotBars", \
        SideEffects::modifyExternal, "das::PlotBars_v_" #SUF)->args({"label","values","bar_size","shift","flags"}); \
    addExtern<DAS_BIND_FUN(das::PlotBars_xy_##SUF)>(*this, lib, "PlotBars", \
        SideEffects::modifyExternal, "das::PlotBars_xy_" #SUF)->args({"label","xs","ys","bar_size","flags"});

#define REG_STEMS(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotStems_v_##SUF)>(*this, lib, "PlotStems", \
        SideEffects::modifyExternal, "das::PlotStems_v_" #SUF)->args({"label","values","ref","scale","start","flags"}); \
    addExtern<DAS_BIND_FUN(das::PlotStems_xy_##SUF)>(*this, lib, "PlotStems", \
        SideEffects::modifyExternal, "das::PlotStems_xy_" #SUF)->args({"label","xs","ys","ref","flags"});

#define REG_SHADED(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotShaded_v_##SUF)>(*this, lib, "PlotShaded", \
        SideEffects::modifyExternal, "das::PlotShaded_v_" #SUF)->args({"label","values","yref","xscale","xstart","flags"}); \
    addExtern<DAS_BIND_FUN(das::PlotShaded_xy_##SUF)>(*this, lib, "PlotShaded", \
        SideEffects::modifyExternal, "das::PlotShaded_xy_" #SUF)->args({"label","xs","ys","yref","flags"}); \
    addExtern<DAS_BIND_FUN(das::PlotShaded_xy2_##SUF)>(*this, lib, "PlotShaded", \
        SideEffects::modifyExternal, "das::PlotShaded_xy2_" #SUF)->args({"label","xs","ys1","ys2","flags"});

#define REG_INFLINES(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotInfLines_v_##SUF)>(*this, lib, "PlotInfLines", \
        SideEffects::modifyExternal, "das::PlotInfLines_v_" #SUF)->args({"label","values","flags"});

#define REG_ERRORBARS(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotErrorBars_sym_##SUF)>(*this, lib, "PlotErrorBars", \
        SideEffects::modifyExternal, "das::PlotErrorBars_sym_" #SUF)->args({"label","xs","ys","err","flags"}); \
    addExtern<DAS_BIND_FUN(das::PlotErrorBars_asym_##SUF)>(*this, lib, "PlotErrorBars", \
        SideEffects::modifyExternal, "das::PlotErrorBars_asym_" #SUF)->args({"label","xs","ys","neg","pos","flags"});

#define REG_DIGITAL(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotDigital_##SUF)>(*this, lib, "PlotDigital", \
        SideEffects::modifyExternal, "das::PlotDigital_" #SUF)->args({"label","xs","ys","flags"});

#define REG_HEATMAP(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotHeatmap_##SUF)>(*this, lib, "PlotHeatmap", \
        SideEffects::modifyExternal, "das::PlotHeatmap_" #SUF)->args({"label","values","rows","cols","scale_min","scale_max","label_fmt","bx0","by0","bx1","by1","flags"});

#define REG_HISTOGRAM(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotHistogram_##SUF)>(*this, lib, "PlotHistogram", \
        SideEffects::modifyExternal, "das::PlotHistogram_" #SUF)->args({"label","values","bins","bar_scale","range_min","range_max","flags"});

#define REG_HISTOGRAM2D(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotHistogram2D_##SUF)>(*this, lib, "PlotHistogram2D", \
        SideEffects::modifyExternal, "das::PlotHistogram2D_" #SUF)->args({"label","xs","ys","x_bins","y_bins","x0","x1","y0","y1","flags"});

#define REG_BARGROUPS(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotBarGroups_##SUF)>(*this, lib, "PlotBarGroups", \
        SideEffects::modifyExternal, "das::PlotBarGroups_" #SUF)->args({"label_ids","values","item_count","group_count","group_size","shift","flags"});

#define REG_PIECHART(SUF) \
    addExtern<DAS_BIND_FUN(das::PlotPieChart_##SUF)>(*this, lib, "PlotPieChart", \
        SideEffects::modifyExternal, "das::PlotPieChart_" #SUF)->args({"label_ids","values","x","y","radius","label_fmt","angle0","flags"});

void Module_dasIMPLOT::initMain () {
    REG_LINELIKE_ALL(PlotLine)
    REG_LINELIKE_ALL(PlotScatter)
    REG_LINELIKE_ALL(PlotStairs)
    REG_BARS(f) REG_BARS(d) REG_BARS(i)
    REG_STEMS(f) REG_STEMS(d) REG_STEMS(i)
    REG_SHADED(f) REG_SHADED(d) REG_SHADED(i)
    REG_INFLINES(f) REG_INFLINES(d) REG_INFLINES(i)
    REG_ERRORBARS(f) REG_ERRORBARS(d) REG_ERRORBARS(i)
    REG_DIGITAL(f) REG_DIGITAL(d) REG_DIGITAL(i)
    REG_HEATMAP(f) REG_HEATMAP(d) REG_HEATMAP(i)
    REG_HISTOGRAM(f) REG_HISTOGRAM(d) REG_HISTOGRAM(i)
    REG_HISTOGRAM2D(f) REG_HISTOGRAM2D(d) REG_HISTOGRAM2D(i)
    REG_BARGROUPS(f) REG_BARGROUPS(d) REG_BARGROUPS(i)
    REG_PIECHART(f) REG_PIECHART(d) REG_PIECHART(i)

    // Legend telemetry — pure reads of a plot's internal item/legend state, keyed by title.
    addExtern<DAS_BIND_FUN(das::LegendEntryCount)>(*this, lib, "LegendEntryCount",
        SideEffects::accessExternal, "das::LegendEntryCount")->args({"title"});
    addExtern<DAS_BIND_FUN(das::LegendEntryLabel)>(*this, lib, "LegendEntryLabel",
        SideEffects::accessExternal, "das::LegendEntryLabel")->args({"title", "index", "context", "lineinfo"});
    addExtern<DAS_BIND_FUN(das::LegendEntryShown)>(*this, lib, "LegendEntryShown",
        SideEffects::accessExternal, "das::LegendEntryShown")->args({"title", "index"});
    addExtern<DAS_BIND_FUN(das::LegendEntryHovered)>(*this, lib, "LegendEntryHovered",
        SideEffects::accessExternal, "das::LegendEntryHovered")->args({"title", "index"});
    addExtern<DAS_BIND_FUN(das::LegendEntryRect)>(*this, lib, "LegendEntryRect",
        SideEffects::accessExternal, "das::LegendEntryRect")->args({"title", "index"});

    // Per-axis range telemetry — secondary-axis limits for the plot snapshot (multi-axis plots).
    addExtern<DAS_BIND_FUN(das::AxisEnabled)>(*this, lib, "AxisEnabled",
        SideEffects::accessExternal, "das::AxisEnabled")->args({"axis"});
    addExtern<DAS_BIND_FUN(das::AxisRangeMin)>(*this, lib, "AxisRangeMin",
        SideEffects::accessExternal, "das::AxisRangeMin")->args({"axis"});
    addExtern<DAS_BIND_FUN(das::AxisRangeMax)>(*this, lib, "AxisRangeMax",
        SideEffects::accessExternal, "das::AxisRangeMax")->args({"axis"});

    // const ImVec2&/ImVec4& -> by value (so daslang passes float2/float4 by value);
    // mirrors dasImguiNodeEditor's initMain fixup.
    for ( auto & pfn : this->functions.each() ) {
        for ( auto & arg : pfn->arguments ) {
            if ( arg->type->constant && arg->type->ref && !arg->type->isArray() ) {
                if ( arg->type->baseType==Type::tFloat2 || arg->type->baseType==Type::tFloat4 ) {
                    arg->type->ref = false;
                }
            }
        }
    }
}

ModuleAotType Module_dasIMPLOT::aotRequire ( TextWriter & tw ) const {
    tw << "#include \"../modules/dasImguiImplot/src/implot_stub.h\"\n";
    tw << "#include \"../modules/dasImguiImplot/src/aot_dasIMPLOT.h\"\n";
    tw << "#include \"daScript/simulate/bind_enum.h\"\n";
    tw << "#include \"../modules/dasImguiImplot/src/dasIMPLOT.enum.decl.cast.inc\"\n";
    return ModuleAotType::cpp;
}

}
