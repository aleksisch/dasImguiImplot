// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

// from implot.h:467:8
struct ImPlotPoint_GeneratedAnnotation : ManagedStructureAnnotation<ImPlotPoint> {
	virtual bool isLocal() const override { return true; }
	virtual bool canBePlacedInContainer() const override { return true; }
	ImPlotPoint_GeneratedAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("ImPlotPoint", ml, "ImPlotPoint") {
	}
	void init () {
		addField<DAS_BIND_MANAGED_FIELD(x)>("x","x");
		addField<DAS_BIND_MANAGED_FIELD(y)>("y","y");
	}
};

// from implot.h:481:8
struct ImPlotRange_GeneratedAnnotation : ManagedStructureAnnotation<ImPlotRange> {
	virtual bool isLocal() const override { return true; }
	virtual bool canBePlacedInContainer() const override { return true; }
	ImPlotRange_GeneratedAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("ImPlotRange", ml, "ImPlotRange") {
	}
	void init () {
		addField<DAS_BIND_MANAGED_FIELD(Min)>("Min","Min");
		addField<DAS_BIND_MANAGED_FIELD(Max)>("Max","Max");
	}
};

// from implot.h:491:8
struct ImPlotRect_GeneratedAnnotation : ManagedStructureAnnotation<ImPlotRect> {
	virtual bool isLocal() const override { return true; }
	virtual bool canBePlacedInContainer() const override { return true; }
	ImPlotRect_GeneratedAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("ImPlotRect", ml, "ImPlotRect") {
	}
	void init () {
		addField<DAS_BIND_MANAGED_FIELD(X)>("X","X");
		addField<DAS_BIND_MANAGED_FIELD(Y)>("Y","Y");
	}
};

// from implot.h:505:8
struct ImPlotStyle_GeneratedAnnotation : ManagedStructureAnnotation<ImPlotStyle> {
	virtual bool isLocal() const override { return true; }
	virtual bool canBePlacedInContainer() const override { return true; }
	ImPlotStyle_GeneratedAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("ImPlotStyle", ml, "ImPlotStyle") {
	}
	void init () {
		addField<DAS_BIND_MANAGED_FIELD(LineWeight)>("LineWeight","LineWeight");
		addField<DAS_BIND_MANAGED_FIELD(Marker)>("Marker","Marker");
		addField<DAS_BIND_MANAGED_FIELD(MarkerSize)>("MarkerSize","MarkerSize");
		addField<DAS_BIND_MANAGED_FIELD(MarkerWeight)>("MarkerWeight","MarkerWeight");
		addField<DAS_BIND_MANAGED_FIELD(FillAlpha)>("FillAlpha","FillAlpha");
		addField<DAS_BIND_MANAGED_FIELD(ErrorBarSize)>("ErrorBarSize","ErrorBarSize");
		addField<DAS_BIND_MANAGED_FIELD(ErrorBarWeight)>("ErrorBarWeight","ErrorBarWeight");
		addField<DAS_BIND_MANAGED_FIELD(DigitalBitHeight)>("DigitalBitHeight","DigitalBitHeight");
		addField<DAS_BIND_MANAGED_FIELD(DigitalBitGap)>("DigitalBitGap","DigitalBitGap");
		addField<DAS_BIND_MANAGED_FIELD(PlotBorderSize)>("PlotBorderSize","PlotBorderSize");
		addField<DAS_BIND_MANAGED_FIELD(MinorAlpha)>("MinorAlpha","MinorAlpha");
		addField<DAS_BIND_MANAGED_FIELD(MajorTickLen)>("MajorTickLen","MajorTickLen");
		addField<DAS_BIND_MANAGED_FIELD(MinorTickLen)>("MinorTickLen","MinorTickLen");
		addField<DAS_BIND_MANAGED_FIELD(MajorTickSize)>("MajorTickSize","MajorTickSize");
		addField<DAS_BIND_MANAGED_FIELD(MinorTickSize)>("MinorTickSize","MinorTickSize");
		addField<DAS_BIND_MANAGED_FIELD(MajorGridSize)>("MajorGridSize","MajorGridSize");
		addField<DAS_BIND_MANAGED_FIELD(MinorGridSize)>("MinorGridSize","MinorGridSize");
		addField<DAS_BIND_MANAGED_FIELD(PlotPadding)>("PlotPadding","PlotPadding");
		addField<DAS_BIND_MANAGED_FIELD(LabelPadding)>("LabelPadding","LabelPadding");
		addField<DAS_BIND_MANAGED_FIELD(LegendPadding)>("LegendPadding","LegendPadding");
		addField<DAS_BIND_MANAGED_FIELD(LegendInnerPadding)>("LegendInnerPadding","LegendInnerPadding");
		addField<DAS_BIND_MANAGED_FIELD(LegendSpacing)>("LegendSpacing","LegendSpacing");
		addField<DAS_BIND_MANAGED_FIELD(MousePosPadding)>("MousePosPadding","MousePosPadding");
		addField<DAS_BIND_MANAGED_FIELD(AnnotationPadding)>("AnnotationPadding","AnnotationPadding");
		addField<DAS_BIND_MANAGED_FIELD(FitPadding)>("FitPadding","FitPadding");
		addField<DAS_BIND_MANAGED_FIELD(PlotDefaultSize)>("PlotDefaultSize","PlotDefaultSize");
		addField<DAS_BIND_MANAGED_FIELD(PlotMinSize)>("PlotMinSize","PlotMinSize");
		addField<DAS_BIND_MANAGED_FIELD(Colors)>("Colors","Colors");
		addField<ImPlotColormap_,offsetof(ManagedType,Colormap)>("Colormap","Colormap")
			.adjustAot("das_reinterpret<ImPlotColormap_>::pass(",")");
		addField<DAS_BIND_MANAGED_FIELD(UseLocalTime)>("UseLocalTime","UseLocalTime");
		addField<DAS_BIND_MANAGED_FIELD(UseISO8601)>("UseISO8601","UseISO8601");
		addField<DAS_BIND_MANAGED_FIELD(Use24HourClock)>("Use24HourClock","Use24HourClock");
	}
};

// from implot.h:562:8
struct ImPlotInputMap_GeneratedAnnotation : ManagedStructureAnnotation<ImPlotInputMap> {
	virtual bool isLocal() const override { return true; }
	virtual bool canBePlacedInContainer() const override { return true; }
	ImPlotInputMap_GeneratedAnnotation(ModuleLibrary & ml) : ManagedStructureAnnotation ("ImPlotInputMap", ml, "ImPlotInputMap") {
	}
	void init () {
		addField<DAS_BIND_MANAGED_FIELD(Pan)>("Pan","Pan");
		addField<DAS_BIND_MANAGED_FIELD(PanMod)>("PanMod","PanMod");
		addField<DAS_BIND_MANAGED_FIELD(Fit)>("Fit","Fit");
		addField<DAS_BIND_MANAGED_FIELD(Select)>("Select","Select");
		addField<DAS_BIND_MANAGED_FIELD(SelectCancel)>("SelectCancel","SelectCancel");
		addField<DAS_BIND_MANAGED_FIELD(SelectMod)>("SelectMod","SelectMod");
		addField<DAS_BIND_MANAGED_FIELD(SelectHorzMod)>("SelectHorzMod","SelectHorzMod");
		addField<DAS_BIND_MANAGED_FIELD(SelectVertMod)>("SelectVertMod","SelectVertMod");
		addField<DAS_BIND_MANAGED_FIELD(Menu)>("Menu","Menu");
		addField<DAS_BIND_MANAGED_FIELD(OverrideMod)>("OverrideMod","OverrideMod");
		addField<DAS_BIND_MANAGED_FIELD(ZoomMod)>("ZoomMod","ZoomMod");
		addField<DAS_BIND_MANAGED_FIELD(ZoomRate)>("ZoomRate","ZoomRate");
	}
};

