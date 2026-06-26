// this file is generated via Daslang automatic binder
// all user modifications will be lost after this file is re-generated

// from implot.h:116:6
class Enumeration_ImAxis_ : public das::Enumeration {
public:
	Enumeration_ImAxis_() : das::Enumeration("ImAxis") {
		external = true;
		cppName = "ImAxis_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("X1", "ImAxis_X1", int64_t(ImAxis_::ImAxis_X1), das::LineInfo());
		addIEx("X2", "ImAxis_X2", int64_t(ImAxis_::ImAxis_X2), das::LineInfo());
		addIEx("X3", "ImAxis_X3", int64_t(ImAxis_::ImAxis_X3), das::LineInfo());
		addIEx("Y1", "ImAxis_Y1", int64_t(ImAxis_::ImAxis_Y1), das::LineInfo());
		addIEx("Y2", "ImAxis_Y2", int64_t(ImAxis_::ImAxis_Y2), das::LineInfo());
		addIEx("Y3", "ImAxis_Y3", int64_t(ImAxis_::ImAxis_Y3), das::LineInfo());
		addIEx("COUNT", "ImAxis_COUNT", int64_t(ImAxis_::ImAxis_COUNT), das::LineInfo());
	}
};

// from implot.h:130:6
class Enumeration_ImPlotFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotFlags_() : das::Enumeration("ImPlotFlags") {
		external = true;
		cppName = "ImPlotFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotFlags_None", int64_t(ImPlotFlags_::ImPlotFlags_None), das::LineInfo());
		addIEx("NoTitle", "ImPlotFlags_NoTitle", int64_t(ImPlotFlags_::ImPlotFlags_NoTitle), das::LineInfo());
		addIEx("NoLegend", "ImPlotFlags_NoLegend", int64_t(ImPlotFlags_::ImPlotFlags_NoLegend), das::LineInfo());
		addIEx("NoMouseText", "ImPlotFlags_NoMouseText", int64_t(ImPlotFlags_::ImPlotFlags_NoMouseText), das::LineInfo());
		addIEx("NoInputs", "ImPlotFlags_NoInputs", int64_t(ImPlotFlags_::ImPlotFlags_NoInputs), das::LineInfo());
		addIEx("NoMenus", "ImPlotFlags_NoMenus", int64_t(ImPlotFlags_::ImPlotFlags_NoMenus), das::LineInfo());
		addIEx("NoBoxSelect", "ImPlotFlags_NoBoxSelect", int64_t(ImPlotFlags_::ImPlotFlags_NoBoxSelect), das::LineInfo());
		addIEx("NoChild", "ImPlotFlags_NoChild", int64_t(ImPlotFlags_::ImPlotFlags_NoChild), das::LineInfo());
		addIEx("NoFrame", "ImPlotFlags_NoFrame", int64_t(ImPlotFlags_::ImPlotFlags_NoFrame), das::LineInfo());
		addIEx("Equal", "ImPlotFlags_Equal", int64_t(ImPlotFlags_::ImPlotFlags_Equal), das::LineInfo());
		addIEx("Crosshairs", "ImPlotFlags_Crosshairs", int64_t(ImPlotFlags_::ImPlotFlags_Crosshairs), das::LineInfo());
		addIEx("CanvasOnly", "ImPlotFlags_CanvasOnly", int64_t(ImPlotFlags_::ImPlotFlags_CanvasOnly), das::LineInfo());
	}
};

// from implot.h:146:6
class Enumeration_ImPlotAxisFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotAxisFlags_() : das::Enumeration("ImPlotAxisFlags") {
		external = true;
		cppName = "ImPlotAxisFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotAxisFlags_None", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_None), das::LineInfo());
		addIEx("NoLabel", "ImPlotAxisFlags_NoLabel", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoLabel), das::LineInfo());
		addIEx("NoGridLines", "ImPlotAxisFlags_NoGridLines", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoGridLines), das::LineInfo());
		addIEx("NoTickMarks", "ImPlotAxisFlags_NoTickMarks", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoTickMarks), das::LineInfo());
		addIEx("NoTickLabels", "ImPlotAxisFlags_NoTickLabels", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoTickLabels), das::LineInfo());
		addIEx("NoInitialFit", "ImPlotAxisFlags_NoInitialFit", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoInitialFit), das::LineInfo());
		addIEx("NoMenus", "ImPlotAxisFlags_NoMenus", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoMenus), das::LineInfo());
		addIEx("NoSideSwitch", "ImPlotAxisFlags_NoSideSwitch", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoSideSwitch), das::LineInfo());
		addIEx("NoHighlight", "ImPlotAxisFlags_NoHighlight", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoHighlight), das::LineInfo());
		addIEx("Opposite", "ImPlotAxisFlags_Opposite", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_Opposite), das::LineInfo());
		addIEx("Foreground", "ImPlotAxisFlags_Foreground", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_Foreground), das::LineInfo());
		addIEx("Invert", "ImPlotAxisFlags_Invert", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_Invert), das::LineInfo());
		addIEx("AutoFit", "ImPlotAxisFlags_AutoFit", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_AutoFit), das::LineInfo());
		addIEx("RangeFit", "ImPlotAxisFlags_RangeFit", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_RangeFit), das::LineInfo());
		addIEx("PanStretch", "ImPlotAxisFlags_PanStretch", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_PanStretch), das::LineInfo());
		addIEx("LockMin", "ImPlotAxisFlags_LockMin", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_LockMin), das::LineInfo());
		addIEx("LockMax", "ImPlotAxisFlags_LockMax", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_LockMax), das::LineInfo());
		addIEx("Lock", "ImPlotAxisFlags_Lock", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_Lock), das::LineInfo());
		addIEx("NoDecorations", "ImPlotAxisFlags_NoDecorations", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_NoDecorations), das::LineInfo());
		addIEx("AuxDefault", "ImPlotAxisFlags_AuxDefault", int64_t(ImPlotAxisFlags_::ImPlotAxisFlags_AuxDefault), das::LineInfo());
	}
};

// from implot.h:170:6
class Enumeration_ImPlotSubplotFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotSubplotFlags_() : das::Enumeration("ImPlotSubplotFlags") {
		external = true;
		cppName = "ImPlotSubplotFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotSubplotFlags_None", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_None), das::LineInfo());
		addIEx("NoTitle", "ImPlotSubplotFlags_NoTitle", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_NoTitle), das::LineInfo());
		addIEx("NoLegend", "ImPlotSubplotFlags_NoLegend", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_NoLegend), das::LineInfo());
		addIEx("NoMenus", "ImPlotSubplotFlags_NoMenus", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_NoMenus), das::LineInfo());
		addIEx("NoResize", "ImPlotSubplotFlags_NoResize", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_NoResize), das::LineInfo());
		addIEx("NoAlign", "ImPlotSubplotFlags_NoAlign", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_NoAlign), das::LineInfo());
		addIEx("ShareItems", "ImPlotSubplotFlags_ShareItems", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_ShareItems), das::LineInfo());
		addIEx("LinkRows", "ImPlotSubplotFlags_LinkRows", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_LinkRows), das::LineInfo());
		addIEx("LinkCols", "ImPlotSubplotFlags_LinkCols", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_LinkCols), das::LineInfo());
		addIEx("LinkAllX", "ImPlotSubplotFlags_LinkAllX", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_LinkAllX), das::LineInfo());
		addIEx("LinkAllY", "ImPlotSubplotFlags_LinkAllY", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_LinkAllY), das::LineInfo());
		addIEx("ColMajor", "ImPlotSubplotFlags_ColMajor", int64_t(ImPlotSubplotFlags_::ImPlotSubplotFlags_ColMajor), das::LineInfo());
	}
};

// from implot.h:186:6
class Enumeration_ImPlotLegendFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotLegendFlags_() : das::Enumeration("ImPlotLegendFlags") {
		external = true;
		cppName = "ImPlotLegendFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotLegendFlags_None", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_None), das::LineInfo());
		addIEx("NoButtons", "ImPlotLegendFlags_NoButtons", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_NoButtons), das::LineInfo());
		addIEx("NoHighlightItem", "ImPlotLegendFlags_NoHighlightItem", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_NoHighlightItem), das::LineInfo());
		addIEx("NoHighlightAxis", "ImPlotLegendFlags_NoHighlightAxis", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_NoHighlightAxis), das::LineInfo());
		addIEx("NoMenus", "ImPlotLegendFlags_NoMenus", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_NoMenus), das::LineInfo());
		addIEx("Outside", "ImPlotLegendFlags_Outside", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_Outside), das::LineInfo());
		addIEx("Horizontal", "ImPlotLegendFlags_Horizontal", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_Horizontal), das::LineInfo());
		addIEx("Sort", "ImPlotLegendFlags_Sort", int64_t(ImPlotLegendFlags_::ImPlotLegendFlags_Sort), das::LineInfo());
	}
};

// from implot.h:198:6
class Enumeration_ImPlotMouseTextFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotMouseTextFlags_() : das::Enumeration("ImPlotMouseTextFlags") {
		external = true;
		cppName = "ImPlotMouseTextFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotMouseTextFlags_None", int64_t(ImPlotMouseTextFlags_::ImPlotMouseTextFlags_None), das::LineInfo());
		addIEx("NoAuxAxes", "ImPlotMouseTextFlags_NoAuxAxes", int64_t(ImPlotMouseTextFlags_::ImPlotMouseTextFlags_NoAuxAxes), das::LineInfo());
		addIEx("NoFormat", "ImPlotMouseTextFlags_NoFormat", int64_t(ImPlotMouseTextFlags_::ImPlotMouseTextFlags_NoFormat), das::LineInfo());
		addIEx("ShowAlways", "ImPlotMouseTextFlags_ShowAlways", int64_t(ImPlotMouseTextFlags_::ImPlotMouseTextFlags_ShowAlways), das::LineInfo());
	}
};

// from implot.h:206:6
class Enumeration_ImPlotDragToolFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotDragToolFlags_() : das::Enumeration("ImPlotDragToolFlags") {
		external = true;
		cppName = "ImPlotDragToolFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotDragToolFlags_None", int64_t(ImPlotDragToolFlags_::ImPlotDragToolFlags_None), das::LineInfo());
		addIEx("NoCursors", "ImPlotDragToolFlags_NoCursors", int64_t(ImPlotDragToolFlags_::ImPlotDragToolFlags_NoCursors), das::LineInfo());
		addIEx("NoFit", "ImPlotDragToolFlags_NoFit", int64_t(ImPlotDragToolFlags_::ImPlotDragToolFlags_NoFit), das::LineInfo());
		addIEx("NoInputs", "ImPlotDragToolFlags_NoInputs", int64_t(ImPlotDragToolFlags_::ImPlotDragToolFlags_NoInputs), das::LineInfo());
		addIEx("Delayed", "ImPlotDragToolFlags_Delayed", int64_t(ImPlotDragToolFlags_::ImPlotDragToolFlags_Delayed), das::LineInfo());
	}
};

// from implot.h:215:6
class Enumeration_ImPlotColormapScaleFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotColormapScaleFlags_() : das::Enumeration("ImPlotColormapScaleFlags") {
		external = true;
		cppName = "ImPlotColormapScaleFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotColormapScaleFlags_None", int64_t(ImPlotColormapScaleFlags_::ImPlotColormapScaleFlags_None), das::LineInfo());
		addIEx("NoLabel", "ImPlotColormapScaleFlags_NoLabel", int64_t(ImPlotColormapScaleFlags_::ImPlotColormapScaleFlags_NoLabel), das::LineInfo());
		addIEx("Opposite", "ImPlotColormapScaleFlags_Opposite", int64_t(ImPlotColormapScaleFlags_::ImPlotColormapScaleFlags_Opposite), das::LineInfo());
		addIEx("Invert", "ImPlotColormapScaleFlags_Invert", int64_t(ImPlotColormapScaleFlags_::ImPlotColormapScaleFlags_Invert), das::LineInfo());
	}
};

// from implot.h:223:6
class Enumeration_ImPlotItemFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotItemFlags_() : das::Enumeration("ImPlotItemFlags") {
		external = true;
		cppName = "ImPlotItemFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotItemFlags_None", int64_t(ImPlotItemFlags_::ImPlotItemFlags_None), das::LineInfo());
		addIEx("NoLegend", "ImPlotItemFlags_NoLegend", int64_t(ImPlotItemFlags_::ImPlotItemFlags_NoLegend), das::LineInfo());
		addIEx("NoFit", "ImPlotItemFlags_NoFit", int64_t(ImPlotItemFlags_::ImPlotItemFlags_NoFit), das::LineInfo());
	}
};

// from implot.h:230:6
class Enumeration_ImPlotLineFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotLineFlags_() : das::Enumeration("ImPlotLineFlags") {
		external = true;
		cppName = "ImPlotLineFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotLineFlags_None", int64_t(ImPlotLineFlags_::ImPlotLineFlags_None), das::LineInfo());
		addIEx("Segments", "ImPlotLineFlags_Segments", int64_t(ImPlotLineFlags_::ImPlotLineFlags_Segments), das::LineInfo());
		addIEx("Loop", "ImPlotLineFlags_Loop", int64_t(ImPlotLineFlags_::ImPlotLineFlags_Loop), das::LineInfo());
		addIEx("SkipNaN", "ImPlotLineFlags_SkipNaN", int64_t(ImPlotLineFlags_::ImPlotLineFlags_SkipNaN), das::LineInfo());
		addIEx("NoClip", "ImPlotLineFlags_NoClip", int64_t(ImPlotLineFlags_::ImPlotLineFlags_NoClip), das::LineInfo());
		addIEx("Shaded", "ImPlotLineFlags_Shaded", int64_t(ImPlotLineFlags_::ImPlotLineFlags_Shaded), das::LineInfo());
	}
};

// from implot.h:240:6
class Enumeration_ImPlotScatterFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotScatterFlags_() : das::Enumeration("ImPlotScatterFlags") {
		external = true;
		cppName = "ImPlotScatterFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotScatterFlags_None", int64_t(ImPlotScatterFlags_::ImPlotScatterFlags_None), das::LineInfo());
		addIEx("NoClip", "ImPlotScatterFlags_NoClip", int64_t(ImPlotScatterFlags_::ImPlotScatterFlags_NoClip), das::LineInfo());
	}
};

// from implot.h:246:6
class Enumeration_ImPlotStairsFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotStairsFlags_() : das::Enumeration("ImPlotStairsFlags") {
		external = true;
		cppName = "ImPlotStairsFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotStairsFlags_None", int64_t(ImPlotStairsFlags_::ImPlotStairsFlags_None), das::LineInfo());
		addIEx("PreStep", "ImPlotStairsFlags_PreStep", int64_t(ImPlotStairsFlags_::ImPlotStairsFlags_PreStep), das::LineInfo());
		addIEx("Shaded", "ImPlotStairsFlags_Shaded", int64_t(ImPlotStairsFlags_::ImPlotStairsFlags_Shaded), das::LineInfo());
	}
};

// from implot.h:253:6
class Enumeration_ImPlotShadedFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotShadedFlags_() : das::Enumeration("ImPlotShadedFlags") {
		external = true;
		cppName = "ImPlotShadedFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotShadedFlags_None", int64_t(ImPlotShadedFlags_::ImPlotShadedFlags_None), das::LineInfo());
	}
};

// from implot.h:258:6
class Enumeration_ImPlotBarsFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotBarsFlags_() : das::Enumeration("ImPlotBarsFlags") {
		external = true;
		cppName = "ImPlotBarsFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotBarsFlags_None", int64_t(ImPlotBarsFlags_::ImPlotBarsFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotBarsFlags_Horizontal", int64_t(ImPlotBarsFlags_::ImPlotBarsFlags_Horizontal), das::LineInfo());
	}
};

// from implot.h:264:6
class Enumeration_ImPlotBarGroupsFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotBarGroupsFlags_() : das::Enumeration("ImPlotBarGroupsFlags") {
		external = true;
		cppName = "ImPlotBarGroupsFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotBarGroupsFlags_None", int64_t(ImPlotBarGroupsFlags_::ImPlotBarGroupsFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotBarGroupsFlags_Horizontal", int64_t(ImPlotBarGroupsFlags_::ImPlotBarGroupsFlags_Horizontal), das::LineInfo());
		addIEx("Stacked", "ImPlotBarGroupsFlags_Stacked", int64_t(ImPlotBarGroupsFlags_::ImPlotBarGroupsFlags_Stacked), das::LineInfo());
	}
};

// from implot.h:271:6
class Enumeration_ImPlotErrorBarsFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotErrorBarsFlags_() : das::Enumeration("ImPlotErrorBarsFlags") {
		external = true;
		cppName = "ImPlotErrorBarsFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotErrorBarsFlags_None", int64_t(ImPlotErrorBarsFlags_::ImPlotErrorBarsFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotErrorBarsFlags_Horizontal", int64_t(ImPlotErrorBarsFlags_::ImPlotErrorBarsFlags_Horizontal), das::LineInfo());
	}
};

// from implot.h:277:6
class Enumeration_ImPlotStemsFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotStemsFlags_() : das::Enumeration("ImPlotStemsFlags") {
		external = true;
		cppName = "ImPlotStemsFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotStemsFlags_None", int64_t(ImPlotStemsFlags_::ImPlotStemsFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotStemsFlags_Horizontal", int64_t(ImPlotStemsFlags_::ImPlotStemsFlags_Horizontal), das::LineInfo());
	}
};

// from implot.h:283:6
class Enumeration_ImPlotInfLinesFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotInfLinesFlags_() : das::Enumeration("ImPlotInfLinesFlags") {
		external = true;
		cppName = "ImPlotInfLinesFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotInfLinesFlags_None", int64_t(ImPlotInfLinesFlags_::ImPlotInfLinesFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotInfLinesFlags_Horizontal", int64_t(ImPlotInfLinesFlags_::ImPlotInfLinesFlags_Horizontal), das::LineInfo());
	}
};

// from implot.h:289:6
class Enumeration_ImPlotPieChartFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotPieChartFlags_() : das::Enumeration("ImPlotPieChartFlags") {
		external = true;
		cppName = "ImPlotPieChartFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotPieChartFlags_None", int64_t(ImPlotPieChartFlags_::ImPlotPieChartFlags_None), das::LineInfo());
		addIEx("Normalize", "ImPlotPieChartFlags_Normalize", int64_t(ImPlotPieChartFlags_::ImPlotPieChartFlags_Normalize), das::LineInfo());
	}
};

// from implot.h:295:6
class Enumeration_ImPlotHeatmapFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotHeatmapFlags_() : das::Enumeration("ImPlotHeatmapFlags") {
		external = true;
		cppName = "ImPlotHeatmapFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotHeatmapFlags_None", int64_t(ImPlotHeatmapFlags_::ImPlotHeatmapFlags_None), das::LineInfo());
		addIEx("ColMajor", "ImPlotHeatmapFlags_ColMajor", int64_t(ImPlotHeatmapFlags_::ImPlotHeatmapFlags_ColMajor), das::LineInfo());
	}
};

// from implot.h:301:6
class Enumeration_ImPlotHistogramFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotHistogramFlags_() : das::Enumeration("ImPlotHistogramFlags") {
		external = true;
		cppName = "ImPlotHistogramFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotHistogramFlags_None", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_None), das::LineInfo());
		addIEx("Horizontal", "ImPlotHistogramFlags_Horizontal", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_Horizontal), das::LineInfo());
		addIEx("Cumulative", "ImPlotHistogramFlags_Cumulative", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_Cumulative), das::LineInfo());
		addIEx("Density", "ImPlotHistogramFlags_Density", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_Density), das::LineInfo());
		addIEx("NoOutliers", "ImPlotHistogramFlags_NoOutliers", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_NoOutliers), das::LineInfo());
		addIEx("ColMajor", "ImPlotHistogramFlags_ColMajor", int64_t(ImPlotHistogramFlags_::ImPlotHistogramFlags_ColMajor), das::LineInfo());
	}
};

// from implot.h:311:6
class Enumeration_ImPlotDigitalFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotDigitalFlags_() : das::Enumeration("ImPlotDigitalFlags") {
		external = true;
		cppName = "ImPlotDigitalFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotDigitalFlags_None", int64_t(ImPlotDigitalFlags_::ImPlotDigitalFlags_None), das::LineInfo());
	}
};

// from implot.h:316:6
class Enumeration_ImPlotImageFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotImageFlags_() : das::Enumeration("ImPlotImageFlags") {
		external = true;
		cppName = "ImPlotImageFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotImageFlags_None", int64_t(ImPlotImageFlags_::ImPlotImageFlags_None), das::LineInfo());
	}
};

// from implot.h:321:6
class Enumeration_ImPlotTextFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotTextFlags_() : das::Enumeration("ImPlotTextFlags") {
		external = true;
		cppName = "ImPlotTextFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotTextFlags_None", int64_t(ImPlotTextFlags_::ImPlotTextFlags_None), das::LineInfo());
		addIEx("Vertical", "ImPlotTextFlags_Vertical", int64_t(ImPlotTextFlags_::ImPlotTextFlags_Vertical), das::LineInfo());
	}
};

// from implot.h:327:6
class Enumeration_ImPlotDummyFlags_ : public das::Enumeration {
public:
	Enumeration_ImPlotDummyFlags_() : das::Enumeration("ImPlotDummyFlags") {
		external = true;
		cppName = "ImPlotDummyFlags_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotDummyFlags_None", int64_t(ImPlotDummyFlags_::ImPlotDummyFlags_None), das::LineInfo());
	}
};

// from implot.h:332:6
class Enumeration_ImPlotCond_ : public das::Enumeration {
public:
	Enumeration_ImPlotCond_() : das::Enumeration("ImPlotCond") {
		external = true;
		cppName = "ImPlotCond_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("None", "ImPlotCond_None", int64_t(ImPlotCond_::ImPlotCond_None), das::LineInfo());
		addIEx("Always", "ImPlotCond_Always", int64_t(ImPlotCond_::ImPlotCond_Always), das::LineInfo());
		addIEx("Once", "ImPlotCond_Once", int64_t(ImPlotCond_::ImPlotCond_Once), das::LineInfo());
	}
};

// from implot.h:340:6
class Enumeration_ImPlotCol_ : public das::Enumeration {
public:
	Enumeration_ImPlotCol_() : das::Enumeration("ImPlotCol") {
		external = true;
		cppName = "ImPlotCol_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("Line", "ImPlotCol_Line", int64_t(ImPlotCol_::ImPlotCol_Line), das::LineInfo());
		addIEx("Fill", "ImPlotCol_Fill", int64_t(ImPlotCol_::ImPlotCol_Fill), das::LineInfo());
		addIEx("MarkerOutline", "ImPlotCol_MarkerOutline", int64_t(ImPlotCol_::ImPlotCol_MarkerOutline), das::LineInfo());
		addIEx("MarkerFill", "ImPlotCol_MarkerFill", int64_t(ImPlotCol_::ImPlotCol_MarkerFill), das::LineInfo());
		addIEx("ErrorBar", "ImPlotCol_ErrorBar", int64_t(ImPlotCol_::ImPlotCol_ErrorBar), das::LineInfo());
		addIEx("FrameBg", "ImPlotCol_FrameBg", int64_t(ImPlotCol_::ImPlotCol_FrameBg), das::LineInfo());
		addIEx("PlotBg", "ImPlotCol_PlotBg", int64_t(ImPlotCol_::ImPlotCol_PlotBg), das::LineInfo());
		addIEx("PlotBorder", "ImPlotCol_PlotBorder", int64_t(ImPlotCol_::ImPlotCol_PlotBorder), das::LineInfo());
		addIEx("LegendBg", "ImPlotCol_LegendBg", int64_t(ImPlotCol_::ImPlotCol_LegendBg), das::LineInfo());
		addIEx("LegendBorder", "ImPlotCol_LegendBorder", int64_t(ImPlotCol_::ImPlotCol_LegendBorder), das::LineInfo());
		addIEx("LegendText", "ImPlotCol_LegendText", int64_t(ImPlotCol_::ImPlotCol_LegendText), das::LineInfo());
		addIEx("TitleText", "ImPlotCol_TitleText", int64_t(ImPlotCol_::ImPlotCol_TitleText), das::LineInfo());
		addIEx("InlayText", "ImPlotCol_InlayText", int64_t(ImPlotCol_::ImPlotCol_InlayText), das::LineInfo());
		addIEx("AxisText", "ImPlotCol_AxisText", int64_t(ImPlotCol_::ImPlotCol_AxisText), das::LineInfo());
		addIEx("AxisGrid", "ImPlotCol_AxisGrid", int64_t(ImPlotCol_::ImPlotCol_AxisGrid), das::LineInfo());
		addIEx("AxisTick", "ImPlotCol_AxisTick", int64_t(ImPlotCol_::ImPlotCol_AxisTick), das::LineInfo());
		addIEx("AxisBg", "ImPlotCol_AxisBg", int64_t(ImPlotCol_::ImPlotCol_AxisBg), das::LineInfo());
		addIEx("AxisBgHovered", "ImPlotCol_AxisBgHovered", int64_t(ImPlotCol_::ImPlotCol_AxisBgHovered), das::LineInfo());
		addIEx("AxisBgActive", "ImPlotCol_AxisBgActive", int64_t(ImPlotCol_::ImPlotCol_AxisBgActive), das::LineInfo());
		addIEx("Selection", "ImPlotCol_Selection", int64_t(ImPlotCol_::ImPlotCol_Selection), das::LineInfo());
		addIEx("Crosshairs", "ImPlotCol_Crosshairs", int64_t(ImPlotCol_::ImPlotCol_Crosshairs), das::LineInfo());
		addIEx("COUNT", "ImPlotCol_COUNT", int64_t(ImPlotCol_::ImPlotCol_COUNT), das::LineInfo());
	}
};

// from implot.h:368:6
class Enumeration_ImPlotStyleVar_ : public das::Enumeration {
public:
	Enumeration_ImPlotStyleVar_() : das::Enumeration("ImPlotStyleVar") {
		external = true;
		cppName = "ImPlotStyleVar_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("LineWeight", "ImPlotStyleVar_LineWeight", int64_t(ImPlotStyleVar_::ImPlotStyleVar_LineWeight), das::LineInfo());
		addIEx("Marker", "ImPlotStyleVar_Marker", int64_t(ImPlotStyleVar_::ImPlotStyleVar_Marker), das::LineInfo());
		addIEx("MarkerSize", "ImPlotStyleVar_MarkerSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MarkerSize), das::LineInfo());
		addIEx("MarkerWeight", "ImPlotStyleVar_MarkerWeight", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MarkerWeight), das::LineInfo());
		addIEx("FillAlpha", "ImPlotStyleVar_FillAlpha", int64_t(ImPlotStyleVar_::ImPlotStyleVar_FillAlpha), das::LineInfo());
		addIEx("ErrorBarSize", "ImPlotStyleVar_ErrorBarSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_ErrorBarSize), das::LineInfo());
		addIEx("ErrorBarWeight", "ImPlotStyleVar_ErrorBarWeight", int64_t(ImPlotStyleVar_::ImPlotStyleVar_ErrorBarWeight), das::LineInfo());
		addIEx("DigitalBitHeight", "ImPlotStyleVar_DigitalBitHeight", int64_t(ImPlotStyleVar_::ImPlotStyleVar_DigitalBitHeight), das::LineInfo());
		addIEx("DigitalBitGap", "ImPlotStyleVar_DigitalBitGap", int64_t(ImPlotStyleVar_::ImPlotStyleVar_DigitalBitGap), das::LineInfo());
		addIEx("PlotBorderSize", "ImPlotStyleVar_PlotBorderSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_PlotBorderSize), das::LineInfo());
		addIEx("MinorAlpha", "ImPlotStyleVar_MinorAlpha", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MinorAlpha), das::LineInfo());
		addIEx("MajorTickLen", "ImPlotStyleVar_MajorTickLen", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MajorTickLen), das::LineInfo());
		addIEx("MinorTickLen", "ImPlotStyleVar_MinorTickLen", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MinorTickLen), das::LineInfo());
		addIEx("MajorTickSize", "ImPlotStyleVar_MajorTickSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MajorTickSize), das::LineInfo());
		addIEx("MinorTickSize", "ImPlotStyleVar_MinorTickSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MinorTickSize), das::LineInfo());
		addIEx("MajorGridSize", "ImPlotStyleVar_MajorGridSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MajorGridSize), das::LineInfo());
		addIEx("MinorGridSize", "ImPlotStyleVar_MinorGridSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MinorGridSize), das::LineInfo());
		addIEx("PlotPadding", "ImPlotStyleVar_PlotPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_PlotPadding), das::LineInfo());
		addIEx("LabelPadding", "ImPlotStyleVar_LabelPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_LabelPadding), das::LineInfo());
		addIEx("LegendPadding", "ImPlotStyleVar_LegendPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_LegendPadding), das::LineInfo());
		addIEx("LegendInnerPadding", "ImPlotStyleVar_LegendInnerPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_LegendInnerPadding), das::LineInfo());
		addIEx("LegendSpacing", "ImPlotStyleVar_LegendSpacing", int64_t(ImPlotStyleVar_::ImPlotStyleVar_LegendSpacing), das::LineInfo());
		addIEx("MousePosPadding", "ImPlotStyleVar_MousePosPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_MousePosPadding), das::LineInfo());
		addIEx("AnnotationPadding", "ImPlotStyleVar_AnnotationPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_AnnotationPadding), das::LineInfo());
		addIEx("FitPadding", "ImPlotStyleVar_FitPadding", int64_t(ImPlotStyleVar_::ImPlotStyleVar_FitPadding), das::LineInfo());
		addIEx("PlotDefaultSize", "ImPlotStyleVar_PlotDefaultSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_PlotDefaultSize), das::LineInfo());
		addIEx("PlotMinSize", "ImPlotStyleVar_PlotMinSize", int64_t(ImPlotStyleVar_::ImPlotStyleVar_PlotMinSize), das::LineInfo());
		addIEx("COUNT", "ImPlotStyleVar_COUNT", int64_t(ImPlotStyleVar_::ImPlotStyleVar_COUNT), das::LineInfo());
	}
};

// from implot.h:402:6
class Enumeration_ImPlotScale_ : public das::Enumeration {
public:
	Enumeration_ImPlotScale_() : das::Enumeration("ImPlotScale") {
		external = true;
		cppName = "ImPlotScale_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("Linear", "ImPlotScale_Linear", int64_t(ImPlotScale_::ImPlotScale_Linear), das::LineInfo());
		addIEx("Time", "ImPlotScale_Time", int64_t(ImPlotScale_::ImPlotScale_Time), das::LineInfo());
		addIEx("Log10", "ImPlotScale_Log10", int64_t(ImPlotScale_::ImPlotScale_Log10), das::LineInfo());
		addIEx("SymLog", "ImPlotScale_SymLog", int64_t(ImPlotScale_::ImPlotScale_SymLog), das::LineInfo());
	}
};

// from implot.h:410:6
class Enumeration_ImPlotMarker_ : public das::Enumeration {
public:
	Enumeration_ImPlotMarker_() : das::Enumeration("ImPlotMarker") {
		external = true;
		cppName = "ImPlotMarker_";
		baseType = (das::Type) das::ToBasicType<int>::type;
		addIEx("None", "ImPlotMarker_None", int64_t(ImPlotMarker_::ImPlotMarker_None), das::LineInfo());
		addIEx("Circle", "ImPlotMarker_Circle", int64_t(ImPlotMarker_::ImPlotMarker_Circle), das::LineInfo());
		addIEx("Square", "ImPlotMarker_Square", int64_t(ImPlotMarker_::ImPlotMarker_Square), das::LineInfo());
		addIEx("Diamond", "ImPlotMarker_Diamond", int64_t(ImPlotMarker_::ImPlotMarker_Diamond), das::LineInfo());
		addIEx("Up", "ImPlotMarker_Up", int64_t(ImPlotMarker_::ImPlotMarker_Up), das::LineInfo());
		addIEx("Down", "ImPlotMarker_Down", int64_t(ImPlotMarker_::ImPlotMarker_Down), das::LineInfo());
		addIEx("Left", "ImPlotMarker_Left", int64_t(ImPlotMarker_::ImPlotMarker_Left), das::LineInfo());
		addIEx("Right", "ImPlotMarker_Right", int64_t(ImPlotMarker_::ImPlotMarker_Right), das::LineInfo());
		addIEx("Cross", "ImPlotMarker_Cross", int64_t(ImPlotMarker_::ImPlotMarker_Cross), das::LineInfo());
		addIEx("Plus", "ImPlotMarker_Plus", int64_t(ImPlotMarker_::ImPlotMarker_Plus), das::LineInfo());
		addIEx("Asterisk", "ImPlotMarker_Asterisk", int64_t(ImPlotMarker_::ImPlotMarker_Asterisk), das::LineInfo());
		addIEx("COUNT", "ImPlotMarker_COUNT", int64_t(ImPlotMarker_::ImPlotMarker_COUNT), das::LineInfo());
	}
};

// from implot.h:426:6
class Enumeration_ImPlotColormap_ : public das::Enumeration {
public:
	Enumeration_ImPlotColormap_() : das::Enumeration("ImPlotColormap") {
		external = true;
		cppName = "ImPlotColormap_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("Deep", "ImPlotColormap_Deep", int64_t(ImPlotColormap_::ImPlotColormap_Deep), das::LineInfo());
		addIEx("Dark", "ImPlotColormap_Dark", int64_t(ImPlotColormap_::ImPlotColormap_Dark), das::LineInfo());
		addIEx("Pastel", "ImPlotColormap_Pastel", int64_t(ImPlotColormap_::ImPlotColormap_Pastel), das::LineInfo());
		addIEx("Paired", "ImPlotColormap_Paired", int64_t(ImPlotColormap_::ImPlotColormap_Paired), das::LineInfo());
		addIEx("Viridis", "ImPlotColormap_Viridis", int64_t(ImPlotColormap_::ImPlotColormap_Viridis), das::LineInfo());
		addIEx("Plasma", "ImPlotColormap_Plasma", int64_t(ImPlotColormap_::ImPlotColormap_Plasma), das::LineInfo());
		addIEx("Hot", "ImPlotColormap_Hot", int64_t(ImPlotColormap_::ImPlotColormap_Hot), das::LineInfo());
		addIEx("Cool", "ImPlotColormap_Cool", int64_t(ImPlotColormap_::ImPlotColormap_Cool), das::LineInfo());
		addIEx("Pink", "ImPlotColormap_Pink", int64_t(ImPlotColormap_::ImPlotColormap_Pink), das::LineInfo());
		addIEx("Jet", "ImPlotColormap_Jet", int64_t(ImPlotColormap_::ImPlotColormap_Jet), das::LineInfo());
		addIEx("Twilight", "ImPlotColormap_Twilight", int64_t(ImPlotColormap_::ImPlotColormap_Twilight), das::LineInfo());
		addIEx("RdBu", "ImPlotColormap_RdBu", int64_t(ImPlotColormap_::ImPlotColormap_RdBu), das::LineInfo());
		addIEx("BrBG", "ImPlotColormap_BrBG", int64_t(ImPlotColormap_::ImPlotColormap_BrBG), das::LineInfo());
		addIEx("PiYG", "ImPlotColormap_PiYG", int64_t(ImPlotColormap_::ImPlotColormap_PiYG), das::LineInfo());
		addIEx("Spectral", "ImPlotColormap_Spectral", int64_t(ImPlotColormap_::ImPlotColormap_Spectral), das::LineInfo());
		addIEx("Greys", "ImPlotColormap_Greys", int64_t(ImPlotColormap_::ImPlotColormap_Greys), das::LineInfo());
	}
};

// from implot.h:446:6
class Enumeration_ImPlotLocation_ : public das::Enumeration {
public:
	Enumeration_ImPlotLocation_() : das::Enumeration("ImPlotLocation") {
		external = true;
		cppName = "ImPlotLocation_";
		baseType = (das::Type) das::ToBasicType<unsigned int>::type;
		addIEx("Center", "ImPlotLocation_Center", int64_t(ImPlotLocation_::ImPlotLocation_Center), das::LineInfo());
		addIEx("North", "ImPlotLocation_North", int64_t(ImPlotLocation_::ImPlotLocation_North), das::LineInfo());
		addIEx("South", "ImPlotLocation_South", int64_t(ImPlotLocation_::ImPlotLocation_South), das::LineInfo());
		addIEx("West", "ImPlotLocation_West", int64_t(ImPlotLocation_::ImPlotLocation_West), das::LineInfo());
		addIEx("East", "ImPlotLocation_East", int64_t(ImPlotLocation_::ImPlotLocation_East), das::LineInfo());
		addIEx("NorthWest", "ImPlotLocation_NorthWest", int64_t(ImPlotLocation_::ImPlotLocation_NorthWest), das::LineInfo());
		addIEx("NorthEast", "ImPlotLocation_NorthEast", int64_t(ImPlotLocation_::ImPlotLocation_NorthEast), das::LineInfo());
		addIEx("SouthWest", "ImPlotLocation_SouthWest", int64_t(ImPlotLocation_::ImPlotLocation_SouthWest), das::LineInfo());
		addIEx("SouthEast", "ImPlotLocation_SouthEast", int64_t(ImPlotLocation_::ImPlotLocation_SouthEast), das::LineInfo());
	}
};

// from implot.h:459:6
class Enumeration_ImPlotBin_ : public das::Enumeration {
public:
	Enumeration_ImPlotBin_() : das::Enumeration("ImPlotBin") {
		external = true;
		cppName = "ImPlotBin_";
		baseType = (das::Type) das::ToBasicType<int>::type;
		addIEx("Sqrt", "ImPlotBin_Sqrt", int64_t(ImPlotBin_::ImPlotBin_Sqrt), das::LineInfo());
		addIEx("Sturges", "ImPlotBin_Sturges", int64_t(ImPlotBin_::ImPlotBin_Sturges), das::LineInfo());
		addIEx("Rice", "ImPlotBin_Rice", int64_t(ImPlotBin_::ImPlotBin_Rice), das::LineInfo());
		addIEx("Scott", "ImPlotBin_Scott", int64_t(ImPlotBin_::ImPlotBin_Scott), das::LineInfo());
	}
};

