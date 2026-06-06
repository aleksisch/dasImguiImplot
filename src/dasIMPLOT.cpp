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
#include "dasIMPLOT.struct.impl.inc"
namespace das {
#include "dasIMPLOT.enum.class.inc"
#include "dasIMPLOT.struct.class.inc"
#include "dasIMPLOT.func.aot.inc"
Module_dasIMPLOT::Module_dasIMPLOT() : Module("implot") {
}
bool Module_dasIMPLOT::initDependencies() {
	if ( initialized ) return true;
	auto mod_imgui = Module::require("imgui");
	if ( !mod_imgui ) return false;
	if ( !mod_imgui->initDependencies() ) return false;
	initialized = true;
	lib.addModule(this);
	lib.addBuiltInModule();
	lib.addModule(mod_imgui);
	initAotAlias();
	#include "dasIMPLOT.const.inc"
	#include "dasIMPLOT.enum.add.inc"
	#include "dasIMPLOT.dummy.add.inc"
	#include "dasIMPLOT.struct.add.inc"
	#include "dasIMPLOT.struct.postadd.inc"
	#include "dasIMPLOT.alias.add.inc"
	#include "dasIMPLOT.func.reg.inc"
	initMain();
	return true;
}
REGISTER_DYN_MODULE(Module_dasIMPLOT,Module_dasIMPLOT);
}
REGISTER_MODULE_IN_NAMESPACE(Module_dasIMPLOT,das);

