#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMPLOT.h"
#include "need_dasIMPLOT.h"
#include "aot_dasIMPLOT.h"

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

void Module_dasIMPLOT::initMain () {
    REG_LINELIKE_ALL(PlotLine)
    REG_LINELIKE_ALL(PlotScatter)
    REG_LINELIKE_ALL(PlotStairs)
    REG_BARS(f) REG_BARS(d) REG_BARS(i)
    REG_STEMS(f) REG_STEMS(d) REG_STEMS(i)
    REG_SHADED(f) REG_SHADED(d) REG_SHADED(i)
    REG_INFLINES(f) REG_INFLINES(d) REG_INFLINES(i)

    // const ImVec2&/ImVec4& -> by value (so daslang passes float2/float4 by value);
    // mirrors dasImguiNodeEditor's initMain fixup.
    for ( auto & pfn : this->functions.each() ) {
        for ( auto & arg : pfn->arguments ) {
            if ( arg->type->constant && arg->type->ref && arg->type->dim.size()==0 ) {
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
