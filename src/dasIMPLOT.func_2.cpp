// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMPLOT.h"
#include "need_dasIMPLOT.h"
namespace das {
#include "dasIMPLOT.func.aot.decl.inc"
void Module_dasIMPLOT::initFunctions_2() {
	addCtorAndUsing<ImPlotInputMap>(*this,lib,"ImPlotInputMap","ImPlotInputMap");
// from implot.h:598:27
	makeExtern< ImPlotContext * (*)() , ImPlot::CreateContext , SimNode_ExtFuncCall , implotTempFn>(lib,"CreateContext","ImPlot::CreateContext")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:600:17
	makeExtern< void (*)(ImPlotContext *) , ImPlot::DestroyContext , SimNode_ExtFuncCall , implotTempFn>(lib,"DestroyContext","ImPlot::DestroyContext")
		->args({"ctx"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:602:27
	makeExtern< ImPlotContext * (*)() , ImPlot::GetCurrentContext , SimNode_ExtFuncCall , implotTempFn>(lib,"GetCurrentContext","ImPlot::GetCurrentContext")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:604:17
	makeExtern< void (*)(ImPlotContext *) , ImPlot::SetCurrentContext , SimNode_ExtFuncCall , implotTempFn>(lib,"SetCurrentContext","ImPlot::SetCurrentContext")
		->args({"ctx"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:610:17
	makeExtern< void (*)(ImGuiContext *) , ImPlot::SetImGuiContext , SimNode_ExtFuncCall , implotTempFn>(lib,"SetImGuiContext","ImPlot::SetImGuiContext")
		->args({"ctx"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:632:17
	makeExtern< bool (*)(const char *,const ImVec2 &,int) , ImPlot::BeginPlot , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginPlot","ImPlot::BeginPlot")
		->args({"title_id","size","flags"})
		->arg_type(2,makeType<ImPlotFlags_>(lib))
		->arg_init(2,new ExprConstEnumeration(0,makeType<ImPlotFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:636:17
	makeExtern< void (*)() , ImPlot::EndPlot , SimNode_ExtFuncCall , implotTempFn>(lib,"EndPlot","ImPlot::EndPlot")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:688:17
	makeExtern< bool (*)(const char *,int,int,const ImVec2 &,int,float *,float *) , ImPlot::BeginSubplots , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginSubplots","ImPlot::BeginSubplots")
		->args({"title_id","rows","cols","size","flags","row_ratios","col_ratios"})
		->arg_type(4,makeType<ImPlotSubplotFlags_>(lib))
		->arg_init(4,new ExprConstEnumeration(0,makeType<ImPlotSubplotFlags_>(lib)))
		->arg_init(5,new ExprConstPtr())
		->arg_init(6,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:698:17
	makeExtern< void (*)() , ImPlot::EndSubplots , SimNode_ExtFuncCall , implotTempFn>(lib,"EndSubplots","ImPlot::EndSubplots")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:730:17
	makeExtern< void (*)(int,const char *,int) , ImPlot::SetupAxis , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxis","ImPlot::SetupAxis")
		->args({"axis","label","flags"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstString(""))
		->arg_type(2,makeType<ImPlotAxisFlags_>(lib))
		->arg_init(2,new ExprConstEnumeration(0,makeType<ImPlotAxisFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:732:17
	makeExtern< void (*)(int,double,double,int) , ImPlot::SetupAxisLimits , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisLimits","ImPlot::SetupAxisLimits")
		->args({"axis","v_min","v_max","cond"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_type(3,makeType<ImPlotCond_>(lib))
		->arg_init(3,new ExprConstEnumeration(2,makeType<ImPlotCond_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:734:17
	makeExtern< void (*)(int,double *,double *) , ImPlot::SetupAxisLinks , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisLinks","ImPlot::SetupAxisLinks")
		->args({"axis","link_min","link_max"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:736:17
	makeExtern< void (*)(int,const char *) , ImPlot::SetupAxisFormat , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisFormat","ImPlot::SetupAxisFormat")
		->args({"axis","fmt"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:740:17
	makeExtern< void (*)(int,const double *,int,const char *const[],bool) , ImPlot::SetupAxisTicks , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisTicks","ImPlot::SetupAxisTicks")
		->args({"axis","values","n_ticks","labels","keep_default"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(4,new ExprConstBool(false))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:742:17
	makeExtern< void (*)(int,double,double,int,const char *const[],bool) , ImPlot::SetupAxisTicks , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisTicks","ImPlot::SetupAxisTicks")
		->args({"axis","v_min","v_max","n_ticks","labels","keep_default"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(5,new ExprConstBool(false))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:744:17
	makeExtern< void (*)(int,int) , ImPlot::SetupAxisScale , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisScale","ImPlot::SetupAxisScale")
		->args({"axis","scale"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_type(1,makeType<ImPlotScale_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:748:17
	makeExtern< void (*)(int,double,double) , ImPlot::SetupAxisLimitsConstraints , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisLimitsConstraints","ImPlot::SetupAxisLimitsConstraints")
		->args({"axis","v_min","v_max"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:750:17
	makeExtern< void (*)(int,double,double) , ImPlot::SetupAxisZoomConstraints , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxisZoomConstraints","ImPlot::SetupAxisZoomConstraints")
		->args({"axis","z_min","z_max"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:753:17
	makeExtern< void (*)(const char *,const char *,int,int) , ImPlot::SetupAxes , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxes","ImPlot::SetupAxes")
		->args({"x_label","y_label","x_flags","y_flags"})
		->arg_type(2,makeType<ImPlotAxisFlags_>(lib))
		->arg_init(2,new ExprConstEnumeration(0,makeType<ImPlotAxisFlags_>(lib)))
		->arg_type(3,makeType<ImPlotAxisFlags_>(lib))
		->arg_init(3,new ExprConstEnumeration(0,makeType<ImPlotAxisFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
}
}

