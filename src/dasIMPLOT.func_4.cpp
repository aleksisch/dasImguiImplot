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
void Module_dasIMPLOT::initFunctions_4() {
// from implot.h:958:17
	makeExtern< void (*)(int,int) , ImPlot::SetAxes , SimNode_ExtFuncCall , implotTempFn>(lib,"SetAxes","ImPlot::SetAxes")
		->args({"x_axis","y_axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_type(1,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:961:24
	makeExtern< ImPlotPoint (*)(const ImVec2 &,int,int) , ImPlot::PixelsToPlot , SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"PixelsToPlot","ImPlot::PixelsToPlot")
		->args({"pix","x_axis","y_axis"})
		->arg_type(1,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(2,makeType<ImAxis_>(lib))
		->arg_init(2,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:962:24
	makeExtern< ImPlotPoint (*)(float,float,int,int) , ImPlot::PixelsToPlot , SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"PixelsToPlot","ImPlot::PixelsToPlot")
		->args({"x","y","x_axis","y_axis"})
		->arg_type(2,makeType<ImAxis_>(lib))
		->arg_init(2,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(3,makeType<ImAxis_>(lib))
		->arg_init(3,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:965:19
	makeExtern< ImVec2 (*)(const ImPlotPoint &,int,int) , ImPlot::PlotToPixels , SimNode_ExtFuncCall , implotTempFn>(lib,"PlotToPixels","ImPlot::PlotToPixels")
		->args({"plt","x_axis","y_axis"})
		->arg_type(1,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(2,makeType<ImAxis_>(lib))
		->arg_init(2,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:966:19
	makeExtern< ImVec2 (*)(double,double,int,int) , ImPlot::PlotToPixels , SimNode_ExtFuncCall , implotTempFn>(lib,"PlotToPixels","ImPlot::PlotToPixels")
		->args({"x","y","x_axis","y_axis"})
		->arg_type(2,makeType<ImAxis_>(lib))
		->arg_init(2,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(3,makeType<ImAxis_>(lib))
		->arg_init(3,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:969:19
	makeExtern< ImVec2 (*)() , ImPlot::GetPlotPos , SimNode_ExtFuncCall , implotTempFn>(lib,"GetPlotPos","ImPlot::GetPlotPos")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:971:19
	makeExtern< ImVec2 (*)() , ImPlot::GetPlotSize , SimNode_ExtFuncCall , implotTempFn>(lib,"GetPlotSize","ImPlot::GetPlotSize")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:974:24
	makeExtern< ImPlotPoint (*)(int,int) , ImPlot::GetPlotMousePos , SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"GetPlotMousePos","ImPlot::GetPlotMousePos")
		->args({"x_axis","y_axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(0,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(1,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:976:23
	makeExtern< ImPlotRect (*)(int,int) , ImPlot::GetPlotLimits , SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"GetPlotLimits","ImPlot::GetPlotLimits")
		->args({"x_axis","y_axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(0,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(1,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:979:17
	makeExtern< bool (*)() , ImPlot::IsPlotHovered , SimNode_ExtFuncCall , implotTempFn>(lib,"IsPlotHovered","ImPlot::IsPlotHovered")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:981:17
	makeExtern< bool (*)(int) , ImPlot::IsAxisHovered , SimNode_ExtFuncCall , implotTempFn>(lib,"IsAxisHovered","ImPlot::IsAxisHovered")
		->args({"axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:983:17
	makeExtern< bool (*)() , ImPlot::IsSubplotsHovered , SimNode_ExtFuncCall , implotTempFn>(lib,"IsSubplotsHovered","ImPlot::IsSubplotsHovered")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:986:17
	makeExtern< bool (*)() , ImPlot::IsPlotSelected , SimNode_ExtFuncCall , implotTempFn>(lib,"IsPlotSelected","ImPlot::IsPlotSelected")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:988:23
	makeExtern< ImPlotRect (*)(int,int) , ImPlot::GetPlotSelection , SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"GetPlotSelection","ImPlot::GetPlotSelection")
		->args({"x_axis","y_axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(0,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->arg_type(1,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImAxis_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:990:17
	makeExtern< void (*)() , ImPlot::CancelPlotSelection , SimNode_ExtFuncCall , implotTempFn>(lib,"CancelPlotSelection","ImPlot::CancelPlotSelection")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:994:17
	makeExtern< void (*)(bool,int) , ImPlot::HideNextItem , SimNode_ExtFuncCall , implotTempFn>(lib,"HideNextItem","ImPlot::HideNextItem")
		->args({"hidden","cond"})
		->arg_init(0,new ExprConstBool(true))
		->arg_type(1,makeType<ImPlotCond_>(lib))
		->arg_init(1,new ExprConstEnumeration(2,makeType<ImPlotCond_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1003:17
	makeExtern< bool (*)(const char *,bool) , ImPlot::BeginAlignedPlots , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginAlignedPlots","ImPlot::BeginAlignedPlots")
		->args({"group_id","vertical"})
		->arg_init(1,new ExprConstBool(true))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1005:17
	makeExtern< void (*)() , ImPlot::EndAlignedPlots , SimNode_ExtFuncCall , implotTempFn>(lib,"EndAlignedPlots","ImPlot::EndAlignedPlots")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1012:17
	makeExtern< bool (*)(const char *,int) , ImPlot::BeginLegendPopup , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginLegendPopup","ImPlot::BeginLegendPopup")
		->args({"label_id","mouse_button"})
		->arg_init(1,new ExprConstInt(1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1014:17
	makeExtern< void (*)() , ImPlot::EndLegendPopup , SimNode_ExtFuncCall , implotTempFn>(lib,"EndLegendPopup","ImPlot::EndLegendPopup")
		->addToModule(*this, SideEffects::worstDefault);
}
}

