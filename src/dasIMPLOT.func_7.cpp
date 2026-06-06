// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

#include "daScript/misc/platform.h"
#include "daScript/ast/ast.h"
#include "daScript/ast/ast_interop.h"
#include "daScript/ast/ast_handle.h"
#include "daScript/ast/ast_typefactory_bind.h"
#include "daScript/simulate/bind_enum.h"
#include "dasIMPLOT.h"
#include "need_dasIMPLOT.h"
namespace das {
#include "dasIMPLOT.func.aot.decl.inc"
void Module_dasIMPLOT::initFunctions_7() {
// from implot.h:1180:17
	makeExtern< void (*)(const char *,double,double,const ImVec2 &,const char *,int,int) , ImPlot::ColormapScale , SimNode_ExtFuncCall , implotTempFn>(lib,"ColormapScale","ImPlot::ColormapScale")
		->args({"label","scale_min","scale_max","size","format","flags","cmap"})
		->arg_init(4,new ExprConstString("%g"))
		->arg_type(5,makeType<ImPlotColormapScaleFlags_>(lib))
		->arg_init(5,new ExprConstEnumeration(0,makeType<ImPlotColormapScaleFlags_>(lib)))
		->arg_type(6,makeType<ImPlotColormap_>(lib))
		->arg_init(6,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1182:17
	makeExtern< bool (*)(const char *,float *,ImVec4 *,const char *,int) , ImPlot::ColormapSlider , SimNode_ExtFuncCall , implotTempFn>(lib,"ColormapSlider","ImPlot::ColormapSlider")
		->args({"label","t","out","format","cmap"})
		->arg_init(2,new ExprConstPtr())
		->arg_init(3,new ExprConstString(""))
		->arg_type(4,makeType<ImPlotColormap_>(lib))
		->arg_init(4,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1184:17
	makeExtern< bool (*)(const char *,const ImVec2 &,int) , ImPlot::ColormapButton , SimNode_ExtFuncCall , implotTempFn>(lib,"ColormapButton","ImPlot::ColormapButton")
		->args({"label","size","cmap"})
		->arg_type(2,makeType<ImPlotColormap_>(lib))
		->arg_init(2,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1193:17
	makeExtern< void (*)(const char *) , ImPlot::BustColorCache , SimNode_ExtFuncCall , implotTempFn>(lib,"BustColorCache","ImPlot::BustColorCache")
		->args({"plot_title_id"})
		->arg_init(0,new ExprConstString(""))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1200:28
	makeExtern< ImPlotInputMap & (*)() , ImPlot::GetInputMap , SimNode_ExtFuncCallRef , implotTempFn>(lib,"GetInputMap","ImPlot::GetInputMap")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1203:17
	makeExtern< void (*)(ImPlotInputMap *) , ImPlot::MapInputDefault , SimNode_ExtFuncCall , implotTempFn>(lib,"MapInputDefault","ImPlot::MapInputDefault")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1205:17
	makeExtern< void (*)(ImPlotInputMap *) , ImPlot::MapInputReverse , SimNode_ExtFuncCall , implotTempFn>(lib,"MapInputReverse","ImPlot::MapInputReverse")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1212:17
	makeExtern< void (*)(const ImVec4 &) , ImPlot::ItemIcon , SimNode_ExtFuncCall , implotTempFn>(lib,"ItemIcon","ImPlot::ItemIcon")
		->args({"col"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1213:17
	makeExtern< void (*)(unsigned int) , ImPlot::ItemIcon , SimNode_ExtFuncCall , implotTempFn>(lib,"ItemIcon","ImPlot::ItemIcon")
		->args({"col"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1214:17
	makeExtern< void (*)(int) , ImPlot::ColormapIcon , SimNode_ExtFuncCall , implotTempFn>(lib,"ColormapIcon","ImPlot::ColormapIcon")
		->args({"cmap"})
		->arg_type(0,makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1217:24
	makeExtern< ImDrawList * (*)() , ImPlot::GetPlotDrawList , SimNode_ExtFuncCall , implotTempFn>(lib,"GetPlotDrawList","ImPlot::GetPlotDrawList")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1219:17
	makeExtern< void (*)(float) , ImPlot::PushPlotClipRect , SimNode_ExtFuncCall , implotTempFn>(lib,"PushPlotClipRect","ImPlot::PushPlotClipRect")
		->args({"expand"})
		->arg_init(0,new ExprConstFloat(0))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1221:17
	makeExtern< void (*)() , ImPlot::PopPlotClipRect , SimNode_ExtFuncCall , implotTempFn>(lib,"PopPlotClipRect","ImPlot::PopPlotClipRect")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1224:17
	makeExtern< bool (*)(const char *) , ImPlot::ShowStyleSelector , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowStyleSelector","ImPlot::ShowStyleSelector")
		->args({"label"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1226:17
	makeExtern< bool (*)(const char *) , ImPlot::ShowColormapSelector , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowColormapSelector","ImPlot::ShowColormapSelector")
		->args({"label"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1228:17
	makeExtern< bool (*)(const char *) , ImPlot::ShowInputMapSelector , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowInputMapSelector","ImPlot::ShowInputMapSelector")
		->args({"label"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1230:17
	makeExtern< void (*)(ImPlotStyle *) , ImPlot::ShowStyleEditor , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowStyleEditor","ImPlot::ShowStyleEditor")
		->args({"ref"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1232:17
	makeExtern< void (*)() , ImPlot::ShowUserGuide , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowUserGuide","ImPlot::ShowUserGuide")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1234:17
	makeExtern< void (*)(bool *) , ImPlot::ShowMetricsWindow , SimNode_ExtFuncCall , implotTempFn>(lib,"ShowMetricsWindow","ImPlot::ShowMetricsWindow")
		->args({"p_popen"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
}
}

