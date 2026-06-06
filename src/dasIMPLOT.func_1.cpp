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
void Module_dasIMPLOT::initFunctions_1() {
	addCtorAndUsing<ImPlotPoint>(*this,lib,"ImPlotPoint","ImPlotPoint");
	addCtorAndUsing<ImPlotPoint,double,double>(*this,lib,"ImPlotPoint","ImPlotPoint")
		->args({"_x","_y"});
	addCtorAndUsing<ImPlotPoint,const ImVec2 &>(*this,lib,"ImPlotPoint","ImPlotPoint")
		->args({"p"});
	using _method_1 = das::das_call_member< double (ImPlotPoint::*)(size_t) const,&ImPlotPoint::operator[] >;
// from implot.h:472:13
	makeExtern<DAS_CALL_METHOD(_method_1), SimNode_ExtFuncCall , implotTempFn>(lib,"[]","das_call_member< double (ImPlotPoint::*)(size_t) const , &ImPlotPoint::operator[] >::invoke")
		->args({"self","idx"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_2 = das::das_call_member< double & (ImPlotPoint::*)(size_t),&ImPlotPoint::operator[] >;
// from implot.h:473:13
	makeExtern<DAS_CALL_METHOD(_method_2), SimNode_ExtFuncCallRef , implotTempFn>(lib,"[]","das_call_member< double & (ImPlotPoint::*)(size_t) , &ImPlotPoint::operator[] >::invoke")
		->args({"self","idx"})
		->addToModule(*this, SideEffects::worstDefault);
	addCtorAndUsing<ImPlotRange>(*this,lib,"ImPlotRange","ImPlotRange");
	addCtorAndUsing<ImPlotRange,double,double>(*this,lib,"ImPlotRange","ImPlotRange")
		->args({"_min","_max"});
	using _method_3 = das::das_call_member< bool (ImPlotRange::*)(double) const,&ImPlotRange::Contains >;
// from implot.h:485:10
	makeExtern<DAS_CALL_METHOD(_method_3), SimNode_ExtFuncCall , implotTempFn>(lib,"Contains","das_call_member< bool (ImPlotRange::*)(double) const , &ImPlotRange::Contains >::invoke")
		->args({"self","value"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_4 = das::das_call_member< double (ImPlotRange::*)() const,&ImPlotRange::Size >;
// from implot.h:486:12
	makeExtern<DAS_CALL_METHOD(_method_4), SimNode_ExtFuncCall , implotTempFn>(lib,"Size","das_call_member< double (ImPlotRange::*)() const , &ImPlotRange::Size >::invoke")
		->args({"self"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_5 = das::das_call_member< double (ImPlotRange::*)(double) const,&ImPlotRange::Clamp >;
// from implot.h:487:12
	makeExtern<DAS_CALL_METHOD(_method_5), SimNode_ExtFuncCall , implotTempFn>(lib,"Clamp","das_call_member< double (ImPlotRange::*)(double) const , &ImPlotRange::Clamp >::invoke")
		->args({"self","value"})
		->addToModule(*this, SideEffects::worstDefault);
	addCtorAndUsing<ImPlotRect>(*this,lib,"ImPlotRect","ImPlotRect");
	addCtorAndUsing<ImPlotRect,double,double,double,double>(*this,lib,"ImPlotRect","ImPlotRect")
		->args({"x_min","x_max","y_min","y_max"});
	using _method_6 = das::das_call_member< bool (ImPlotRect::*)(const ImPlotPoint &) const,&ImPlotRect::Contains >;
// from implot.h:495:10
	makeExtern<DAS_CALL_METHOD(_method_6), SimNode_ExtFuncCall , implotTempFn>(lib,"Contains","das_call_member< bool (ImPlotRect::*)(const ImPlotPoint &) const , &ImPlotRect::Contains >::invoke")
		->args({"self","p"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_7 = das::das_call_member< bool (ImPlotRect::*)(double,double) const,&ImPlotRect::Contains >;
// from implot.h:496:10
	makeExtern<DAS_CALL_METHOD(_method_7), SimNode_ExtFuncCall , implotTempFn>(lib,"Contains","das_call_member< bool (ImPlotRect::*)(double,double) const , &ImPlotRect::Contains >::invoke")
		->args({"self","x","y"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_8 = das::das_call_member< ImPlotPoint (ImPlotRect::*)() const,&ImPlotRect::Size >;
// from implot.h:497:17
	makeExtern<DAS_CALL_METHOD(_method_8), SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"Size","das_call_member< ImPlotPoint (ImPlotRect::*)() const , &ImPlotRect::Size >::invoke")
		->args({"self"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_9 = das::das_call_member< ImPlotPoint (ImPlotRect::*)(const ImPlotPoint &),&ImPlotRect::Clamp >;
// from implot.h:498:17
	makeExtern<DAS_CALL_METHOD(_method_9), SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"Clamp","das_call_member< ImPlotPoint (ImPlotRect::*)(const ImPlotPoint &) , &ImPlotRect::Clamp >::invoke")
		->args({"self","p"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_10 = das::das_call_member< ImPlotPoint (ImPlotRect::*)(double,double),&ImPlotRect::Clamp >;
// from implot.h:499:17
	makeExtern<DAS_CALL_METHOD(_method_10), SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"Clamp","das_call_member< ImPlotPoint (ImPlotRect::*)(double,double) , &ImPlotRect::Clamp >::invoke")
		->args({"self","x","y"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_11 = das::das_call_member< ImPlotPoint (ImPlotRect::*)() const,&ImPlotRect::Min >;
// from implot.h:500:17
	makeExtern<DAS_CALL_METHOD(_method_11), SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"Min","das_call_member< ImPlotPoint (ImPlotRect::*)() const , &ImPlotRect::Min >::invoke")
		->args({"self"})
		->addToModule(*this, SideEffects::worstDefault);
	using _method_12 = das::das_call_member< ImPlotPoint (ImPlotRect::*)() const,&ImPlotRect::Max >;
// from implot.h:501:17
	makeExtern<DAS_CALL_METHOD(_method_12), SimNode_ExtFuncCallAndCopyOrMove , implotTempFn>(lib,"Max","das_call_member< ImPlotPoint (ImPlotRect::*)() const , &ImPlotRect::Max >::invoke")
		->args({"self"})
		->addToModule(*this, SideEffects::worstDefault);
	addCtorAndUsing<ImPlotStyle>(*this,lib,"ImPlotStyle","ImPlotStyle");
}
}

