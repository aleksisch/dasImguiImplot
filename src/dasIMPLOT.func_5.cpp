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
void Module_dasIMPLOT::initFunctions_5() {
// from implot.h:1016:17
	makeExtern< bool (*)(const char *) , ImPlot::IsLegendEntryHovered , SimNode_ExtFuncCall , implotTempFn>(lib,"IsLegendEntryHovered","ImPlot::IsLegendEntryHovered")
		->args({"label_id"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1023:17
	makeExtern< bool (*)() , ImPlot::BeginDragDropTargetPlot , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropTargetPlot","ImPlot::BeginDragDropTargetPlot")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1025:17
	makeExtern< bool (*)(int) , ImPlot::BeginDragDropTargetAxis , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropTargetAxis","ImPlot::BeginDragDropTargetAxis")
		->args({"axis"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1027:17
	makeExtern< bool (*)() , ImPlot::BeginDragDropTargetLegend , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropTargetLegend","ImPlot::BeginDragDropTargetLegend")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1029:17
	makeExtern< void (*)() , ImPlot::EndDragDropTarget , SimNode_ExtFuncCall , implotTempFn>(lib,"EndDragDropTarget","ImPlot::EndDragDropTarget")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1035:17
	makeExtern< bool (*)(int) , ImPlot::BeginDragDropSourcePlot , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropSourcePlot","ImPlot::BeginDragDropSourcePlot")
		->args({"flags"})
		->arg_init(0,new ExprConstInt(0))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1037:17
	makeExtern< bool (*)(int,int) , ImPlot::BeginDragDropSourceAxis , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropSourceAxis","ImPlot::BeginDragDropSourceAxis")
		->args({"axis","flags"})
		->arg_type(0,makeType<ImAxis_>(lib))
		->arg_init(1,new ExprConstInt(0))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1039:17
	makeExtern< bool (*)(const char *,int) , ImPlot::BeginDragDropSourceItem , SimNode_ExtFuncCall , implotTempFn>(lib,"BeginDragDropSourceItem","ImPlot::BeginDragDropSourceItem")
		->args({"label_id","flags"})
		->arg_init(1,new ExprConstInt(0))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1041:17
	makeExtern< void (*)() , ImPlot::EndDragDropSource , SimNode_ExtFuncCall , implotTempFn>(lib,"EndDragDropSource","ImPlot::EndDragDropSource")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1077:25
	makeExtern< ImPlotStyle & (*)() , ImPlot::GetStyle , SimNode_ExtFuncCallRef , implotTempFn>(lib,"GetStyle","ImPlot::GetStyle")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1080:17
	makeExtern< void (*)(ImPlotStyle *) , ImPlot::StyleColorsAuto , SimNode_ExtFuncCall , implotTempFn>(lib,"StyleColorsAuto","ImPlot::StyleColorsAuto")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1082:17
	makeExtern< void (*)(ImPlotStyle *) , ImPlot::StyleColorsClassic , SimNode_ExtFuncCall , implotTempFn>(lib,"StyleColorsClassic","ImPlot::StyleColorsClassic")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1084:17
	makeExtern< void (*)(ImPlotStyle *) , ImPlot::StyleColorsDark , SimNode_ExtFuncCall , implotTempFn>(lib,"StyleColorsDark","ImPlot::StyleColorsDark")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1086:17
	makeExtern< void (*)(ImPlotStyle *) , ImPlot::StyleColorsLight , SimNode_ExtFuncCall , implotTempFn>(lib,"StyleColorsLight","ImPlot::StyleColorsLight")
		->args({"dst"})
		->arg_init(0,new ExprConstPtr())
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1093:17
	makeExtern< void (*)(int,unsigned int) , ImPlot::PushStyleColor , SimNode_ExtFuncCall , implotTempFn>(lib,"PushStyleColor","ImPlot::PushStyleColor")
		->args({"idx","col"})
		->arg_type(0,makeType<ImPlotCol_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1094:17
	makeExtern< void (*)(int,const ImVec4 &) , ImPlot::PushStyleColor , SimNode_ExtFuncCall , implotTempFn>(lib,"PushStyleColor","ImPlot::PushStyleColor")
		->args({"idx","col"})
		->arg_type(0,makeType<ImPlotCol_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1096:17
	makeExtern< void (*)(int) , ImPlot::PopStyleColor , SimNode_ExtFuncCall , implotTempFn>(lib,"PopStyleColor","ImPlot::PopStyleColor")
		->args({"count"})
		->arg_init(0,new ExprConstInt(1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1099:17
	makeExtern< void (*)(int,float) , ImPlot::PushStyleVar , SimNode_ExtFuncCall , implotTempFn>(lib,"PushStyleVar","ImPlot::PushStyleVar")
		->args({"idx","val"})
		->arg_type(0,makeType<ImPlotStyleVar_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1101:17
	makeExtern< void (*)(int,int) , ImPlot::PushStyleVar , SimNode_ExtFuncCall , implotTempFn>(lib,"PushStyleVar","ImPlot::PushStyleVar")
		->args({"idx","val"})
		->arg_type(0,makeType<ImPlotStyleVar_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1103:17
	makeExtern< void (*)(int,const ImVec2 &) , ImPlot::PushStyleVar , SimNode_ExtFuncCall , implotTempFn>(lib,"PushStyleVar","ImPlot::PushStyleVar")
		->args({"idx","val"})
		->arg_type(0,makeType<ImPlotStyleVar_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
}
}

