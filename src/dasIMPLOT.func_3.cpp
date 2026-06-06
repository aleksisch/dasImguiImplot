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
void Module_dasIMPLOT::initFunctions_3() {
// from implot.h:755:17
	makeExtern< void (*)(double,double,double,double,int) , ImPlot::SetupAxesLimits , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupAxesLimits","ImPlot::SetupAxesLimits")
		->args({"x_min","x_max","y_min","y_max","cond"})
		->arg_type(4,makeType<ImPlotCond_>(lib))
		->arg_init(4,new ExprConstEnumeration(2,makeType<ImPlotCond_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:758:17
	makeExtern< void (*)(int,int) , ImPlot::SetupLegend , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupLegend","ImPlot::SetupLegend")
		->args({"location","flags"})
		->arg_type(0,makeType<ImPlotLocation_>(lib))
		->arg_type(1,makeType<ImPlotLegendFlags_>(lib))
		->arg_init(1,new ExprConstEnumeration(0,makeType<ImPlotLegendFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:760:17
	makeExtern< void (*)(int,int) , ImPlot::SetupMouseText , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupMouseText","ImPlot::SetupMouseText")
		->args({"location","flags"})
		->arg_type(0,makeType<ImPlotLocation_>(lib))
		->arg_type(1,makeType<ImPlotMouseTextFlags_>(lib))
		->arg_init(1,new ExprConstEnumeration(0,makeType<ImPlotMouseTextFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:764:17
	makeExtern< void (*)() , ImPlot::SetupFinish , SimNode_ExtFuncCall , implotTempFn>(lib,"SetupFinish","ImPlot::SetupFinish")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:790:17
	makeExtern< void (*)(int,double,double,int) , ImPlot::SetNextAxisLimits , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextAxisLimits","ImPlot::SetNextAxisLimits")
		->args({"axis","v_min","v_max","cond"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_type(3,makeType<ImPlotCond_>(lib))
		->arg_init(3,new ExprConstEnumeration(2,makeType<ImPlotCond_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:792:17
	makeExtern< void (*)(int,double *,double *) , ImPlot::SetNextAxisLinks , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextAxisLinks","ImPlot::SetNextAxisLinks")
		->args({"axis","link_min","link_max"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:794:17
	makeExtern< void (*)(int) , ImPlot::SetNextAxisToFit , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextAxisToFit","ImPlot::SetNextAxisToFit")
		->args({"axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:797:17
	makeExtern< void (*)(double,double,double,double,int) , ImPlot::SetNextAxesLimits , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextAxesLimits","ImPlot::SetNextAxesLimits")
		->args({"x_min","x_max","y_min","y_max","cond"})
		->arg_type(4,makeType<ImPlotCond_>(lib))
		->arg_init(4,new ExprConstEnumeration(2,makeType<ImPlotCond_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:799:17
	makeExtern< void (*)() , ImPlot::SetNextAxesToFit , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextAxesToFit","ImPlot::SetNextAxesToFit")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:912:17
	makeExtern< void (*)(const char *,void *,const ImPlotPoint &,const ImPlotPoint &,const ImVec2 &,const ImVec2 &,const ImVec4 &,int) , ImPlot::PlotImage , SimNode_ExtFuncCall , implotTempFn>(lib,"PlotImage","ImPlot::PlotImage")
		->args({"label_id","user_texture_id","bounds_min","bounds_max","uv0","uv1","tint_col","flags"})
		->arg_type(7,makeType<ImPlotImageFlags_>(lib))
		->arg_init(7,new ExprConstEnumeration(0,makeType<ImPlotImageFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:915:17
	makeExtern< void (*)(const char *,double,double,const ImVec2 &,int) , ImPlot::PlotText , SimNode_ExtFuncCall , implotTempFn>(lib,"PlotText","ImPlot::PlotText")
		->args({"text","x","y","pix_offset","flags"})
		->arg_type(4,makeType<ImPlotTextFlags_>(lib))
		->arg_init(4,new ExprConstEnumeration(0,makeType<ImPlotTextFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:918:17
	makeExtern< void (*)(const char *,int) , ImPlot::PlotDummy , SimNode_ExtFuncCall , implotTempFn>(lib,"PlotDummy","ImPlot::PlotDummy")
		->args({"label_id","flags"})
		->arg_type(1,makeType<ImPlotDummyFlags_>(lib))
		->arg_init(1,new ExprConstEnumeration(0,makeType<ImPlotDummyFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:929:17
	makeExtern< bool (*)(int,double *,double *,const ImVec4 &,float,int) , ImPlot::DragPoint , SimNode_ExtFuncCall , implotTempFn>(lib,"DragPoint","ImPlot::DragPoint")
		->args({"id","x","y","col","size","flags"})
		->arg_init(4,new ExprConstFloat(4))
		->arg_type(5,makeType<ImPlotDragToolFlags_>(lib))
		->arg_init(5,new ExprConstEnumeration(0,makeType<ImPlotDragToolFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:931:17
	makeExtern< bool (*)(int,double *,const ImVec4 &,float,int) , ImPlot::DragLineX , SimNode_ExtFuncCall , implotTempFn>(lib,"DragLineX","ImPlot::DragLineX")
		->args({"id","x","col","thickness","flags"})
		->arg_init(3,new ExprConstFloat(1))
		->arg_type(4,makeType<ImPlotDragToolFlags_>(lib))
		->arg_init(4,new ExprConstEnumeration(0,makeType<ImPlotDragToolFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:933:17
	makeExtern< bool (*)(int,double *,const ImVec4 &,float,int) , ImPlot::DragLineY , SimNode_ExtFuncCall , implotTempFn>(lib,"DragLineY","ImPlot::DragLineY")
		->args({"id","y","col","thickness","flags"})
		->arg_init(3,new ExprConstFloat(1))
		->arg_type(4,makeType<ImPlotDragToolFlags_>(lib))
		->arg_init(4,new ExprConstEnumeration(0,makeType<ImPlotDragToolFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:935:17
	makeExtern< bool (*)(int,double *,double *,double *,double *,const ImVec4 &,int) , ImPlot::DragRect , SimNode_ExtFuncCall , implotTempFn>(lib,"DragRect","ImPlot::DragRect")
		->args({"id","x1","y1","x2","y2","col","flags"})
		->arg_type(6,makeType<ImPlotDragToolFlags_>(lib))
		->arg_init(6,new ExprConstEnumeration(0,makeType<ImPlotDragToolFlags_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:938:17
	makeExtern< void (*)(double,double,const ImVec4 &,const ImVec2 &,bool,bool) , ImPlot::Annotation , SimNode_ExtFuncCall , implotTempFn>(lib,"Annotation","ImPlot::Annotation")
		->args({"x","y","col","pix_offset","clamp","round"})
		->arg_init(5,new ExprConstBool(false))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:943:17
	makeExtern< void (*)(double,const ImVec4 &,bool) , ImPlot::TagX , SimNode_ExtFuncCall , implotTempFn>(lib,"TagX","ImPlot::TagX")
		->args({"x","col","round"})
		->arg_init(2,new ExprConstBool(false))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:948:17
	makeExtern< void (*)(double,const ImVec4 &,bool) , ImPlot::TagY , SimNode_ExtFuncCall , implotTempFn>(lib,"TagY","ImPlot::TagY")
		->args({"y","col","round"})
		->arg_init(2,new ExprConstBool(false))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:957:17
	makeExtern< void (*)(int) , ImPlot::SetAxis , SimNode_ExtFuncCall , implotTempFn>(lib,"SetAxis","ImPlot::SetAxis")
		->args({"axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
}
}

