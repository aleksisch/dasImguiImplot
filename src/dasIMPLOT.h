// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

#pragma once
#include "cb_dasIMGUI.h"
#include "cb_dasIMPLOT.h"
#include "need_dasIMGUI.h"
namespace das {
class Module_dasIMPLOT : public Module {
public:
	Module_dasIMPLOT();
protected:
virtual bool initDependencies() override;
	void initMain ();
	void initAotAlias ();
	virtual ModuleAotType aotRequire ( TextWriter & tw ) const override;
	#include "dasIMPLOT.func.decl.inc"
public:
	ModuleLibrary lib;
	bool initialized = false;
};
}

