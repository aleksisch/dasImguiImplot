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
// (0 / sizeof(T)) and dropped from the surface. Every ImPlot*Flags is `typedef int`, so
// the flags int passes straight through.

// TArray<T>::data is char* (inherited from Array), so cast to the typed pointer or the
// template arg deduces to char and the call hits an uninstantiated PlotLine<char>.
#define IMPLOT_LINE_FWD(SUF, T) \
    void PlotLine_v_##SUF(const char* label, const TArray<T>& values, double xscale, double xstart, int flags) { \
        ImPlot::PlotLine(label, (const T*)values.data, (int)values.size, xscale, xstart, flags); } \
    void PlotLine_xy_##SUF(const char* label, const TArray<T>& xs, const TArray<T>& ys, int flags) { \
        ImPlot::PlotLine(label, (const T*)xs.data, (const T*)ys.data, (int)(xs.size < ys.size ? xs.size : ys.size), flags); }

IMPLOT_LINE_FWD(f, float)
IMPLOT_LINE_FWD(d, double)
IMPLOT_LINE_FWD(i, int32_t)

#undef IMPLOT_LINE_FWD

void Module_dasIMPLOT::initAotAlias () {
}

void Module_dasIMPLOT::initMain () {
    // Templated Plot* forwarders — overloaded by array element type (float/double/int).
    addExtern<DAS_BIND_FUN(das::PlotLine_v_f)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_v_f")->args({"label","values","xscale","xstart","flags"});
    addExtern<DAS_BIND_FUN(das::PlotLine_v_d)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_v_d")->args({"label","values","xscale","xstart","flags"});
    addExtern<DAS_BIND_FUN(das::PlotLine_v_i)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_v_i")->args({"label","values","xscale","xstart","flags"});
    addExtern<DAS_BIND_FUN(das::PlotLine_xy_f)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_xy_f")->args({"label","xs","ys","flags"});
    addExtern<DAS_BIND_FUN(das::PlotLine_xy_d)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_xy_d")->args({"label","xs","ys","flags"});
    addExtern<DAS_BIND_FUN(das::PlotLine_xy_i)>(*this, lib, "PlotLine",
        SideEffects::modifyExternal, "das::PlotLine_xy_i")->args({"label","xs","ys","flags"});

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
