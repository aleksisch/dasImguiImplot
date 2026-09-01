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
void Module_dasIMPLOT::initFunctions_6() {
// from implot.h:1105:17
	makeExtern< void (*)(int) , ImPlot::PopStyleVar , SimNode_ExtFuncCall , implotTempFn>(lib,"PopStyleVar","ImPlot::PopStyleVar")
		->args({"count"})
		->arg_init(0,new ExprConstInt(1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1113:17
	makeExtern< void (*)(const ImVec4 &,float) , ImPlot::SetNextLineStyle , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextLineStyle","ImPlot::SetNextLineStyle")
		->args({"col","weight"})
		->arg_init(1,new ExprConstFloat(-1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1115:17
	makeExtern< void (*)(const ImVec4 &,float) , ImPlot::SetNextFillStyle , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextFillStyle","ImPlot::SetNextFillStyle")
		->args({"col","alpha_mod"})
		->arg_init(1,new ExprConstFloat(-1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1117:17
	makeExtern< void (*)(int,float,const ImVec4 &,float,const ImVec4 &) , ImPlot::SetNextMarkerStyle , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextMarkerStyle","ImPlot::SetNextMarkerStyle")
		->args({"marker","size","fill","weight","outline"})
		->arg_type(0,makeType<ImPlotMarker_>(lib))
		->arg_init(0,new ExprConstEnumeration(-1,makeType<ImPlotMarker_>(lib)))
		->arg_init(1,new ExprConstFloat(-1))
		->arg_init(3,new ExprConstFloat(-1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1119:17
	makeExtern< void (*)(const ImVec4 &,float,float) , ImPlot::SetNextErrorBarStyle , SimNode_ExtFuncCall , implotTempFn>(lib,"SetNextErrorBarStyle","ImPlot::SetNextErrorBarStyle")
		->args({"col","size","weight"})
		->arg_init(1,new ExprConstFloat(-1))
		->arg_init(2,new ExprConstFloat(-1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1122:19
	makeExtern< ImVec4 (*)() , ImPlot::GetLastItemColor , SimNode_ExtFuncCall , implotTempFn>(lib,"GetLastItemColor","ImPlot::GetLastItemColor")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1125:24
	makeExtern< const char * (*)(int) , ImPlot::GetStyleColorName , SimNode_ExtFuncCall , implotTempFn>(lib,"GetStyleColorName","ImPlot::GetStyleColorName")
		->args({"idx"})
		->arg_type(0,makeType<ImPlotCol_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1127:24
	makeExtern< const char * (*)(int) , ImPlot::GetMarkerName , SimNode_ExtFuncCall , implotTempFn>(lib,"GetMarkerName","ImPlot::GetMarkerName")
		->args({"idx"})
		->arg_type(0,makeType<ImPlotMarker_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1148:27
	makeExtern< int (*)(const char *,const ImVec4 *,int,bool) , ImPlot::AddColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"AddColormap","ImPlot::AddColormap")
		->args({"name","cols","size","qual"})
		->arg_init(3,new ExprConstBool(true))
		->res_type(makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1149:27
	makeExtern< int (*)(const char *,const unsigned int *,int,bool) , ImPlot::AddColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"AddColormap","ImPlot::AddColormap")
		->args({"name","cols","size","qual"})
		->arg_init(3,new ExprConstBool(true))
		->res_type(makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1152:16
	makeExtern< int (*)() , ImPlot::GetColormapCount , SimNode_ExtFuncCall , implotTempFn>(lib,"GetColormapCount","ImPlot::GetColormapCount")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1154:24
	makeExtern< const char * (*)(int) , ImPlot::GetColormapName , SimNode_ExtFuncCall , implotTempFn>(lib,"GetColormapName","ImPlot::GetColormapName")
		->args({"cmap"})
		->arg_type(0,makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1156:27
	makeExtern< int (*)(const char *) , ImPlot::GetColormapIndex , SimNode_ExtFuncCall , implotTempFn>(lib,"GetColormapIndex","ImPlot::GetColormapIndex")
		->args({"name"})
		->res_type(makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1159:17
	makeExtern< void (*)(int) , ImPlot::PushColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"PushColormap","ImPlot::PushColormap")
		->args({"cmap"})
		->arg_type(0,makeType<ImPlotColormap_>(lib))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1161:17
	makeExtern< void (*)(const char *) , ImPlot::PushColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"PushColormap","ImPlot::PushColormap")
		->args({"name"})
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1163:17
	makeExtern< void (*)(int) , ImPlot::PopColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"PopColormap","ImPlot::PopColormap")
		->args({"count"})
		->arg_init(0,new ExprConstInt(1))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1167:19
	makeExtern< ImVec4 (*)() , ImPlot::NextColormapColor , SimNode_ExtFuncCall , implotTempFn>(lib,"NextColormapColor","ImPlot::NextColormapColor")
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1173:16
	makeExtern< int (*)(int) , ImPlot::GetColormapSize , SimNode_ExtFuncCall , implotTempFn>(lib,"GetColormapSize","ImPlot::GetColormapSize")
		->args({"cmap"})
		->arg_type(0,makeType<ImPlotColormap_>(lib))
		->arg_init(0,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1175:19
	makeExtern< ImVec4 (*)(int,int) , ImPlot::GetColormapColor , SimNode_ExtFuncCall , implotTempFn>(lib,"GetColormapColor","ImPlot::GetColormapColor")
		->args({"idx","cmap"})
		->arg_type(1,makeType<ImPlotColormap_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
// from implot.h:1177:19
	makeExtern< ImVec4 (*)(float,int) , ImPlot::SampleColormap , SimNode_ExtFuncCall , implotTempFn>(lib,"SampleColormap","ImPlot::SampleColormap")
		->args({"t","cmap"})
		->arg_type(1,makeType<ImPlotColormap_>(lib))
		->arg_init(1,new ExprConstEnumeration(-1,makeType<ImPlotColormap_>(lib)))
		->addToModule(*this, SideEffects::worstDefault);
}
}

