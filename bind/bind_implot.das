options gen2
options _comment_hygiene = true
require cbind/cbind_boost
require daslib/fio
require daslib/defer
require daslib/strings_boost

// Binding generator for ImPlot v0.16 — mirrors dasImguiNodeEditor/bind/bind_imgui_node_editor.das.
// Parses implot.h via libclang and emits the committed C++ binding (src/dasIMPLOT.*).
// ImPlot's Plot* functions are templates (skipped by libclang) — those are hand-written
// forwarders in src/dasIMPLOT.main.cpp. Everything else (enums, structs, Begin/End,
// Setup*, query, drag tools, style/colormap) is generated here.
// Run: daslang bind/bind_implot.das   (needs a daslang build with dasClangBind enabled)

class ImplotGen : CppGenBind {
    override include_parse_file = false
    override func_to_stdout = false
    override generate_constant_decl = true
    implot_skip_func : table<string; bool>
    def ImplotGen {
        bind_root = "{get_das_root()}/modules/dasImguiImplot/src"
        bind_module = "dasIMPLOT"
        bind_das_module = "implot"
        let pfn = "implot.h"
        let pfp = "{get_das_root()}/modules/dasImguiImplot/implot/"
        let i_imgui = "{get_das_root()}/modules/dasImgui/imgui/"
        let args <- array<string>(
            "-xc++-header",
            "-std=c++1z",
            "-I{get_full_file_name(i_imgui)}",
            "-I{get_full_file_name(pfp)}",
            "-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS",
            "-DIMPLOT_DISABLE_OBSOLETE_FUNCTIONS",
            "-D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH=1"
        )
        func_per_chunk = 20
        super(pfn, pfp, args)
        init_rename()
        openAllFiles()
    }
    def override get_module_temp_fn : string {
        return ", implotTempFn"
    }
    def init_rename {
        // ImVec2/ImVec4 come from the imgui module (cb_dasIMGUI.h aliases them to
        // float2/float4); mark them as aot aliases so implot signatures bind by value.
        aot_alias <- {
            "ImVec2" => true,
            "ImVec4" => true,
            "ImColor" => true
        }
        // Enum prefix-strip map (ImPlotFlags_X -> ImPlotFlags.X). Covers both flag
        // enums and value enums; the loop below also marks them combinable (harmless
        // for value enums, mirrors node-editor's wholesale marking).
        alias2type <- {
            "ImAxis"                   => "ImAxis_",
            "ImPlotFlags"              => "ImPlotFlags_",
            "ImPlotAxisFlags"          => "ImPlotAxisFlags_",
            "ImPlotSubplotFlags"       => "ImPlotSubplotFlags_",
            "ImPlotLegendFlags"        => "ImPlotLegendFlags_",
            "ImPlotMouseTextFlags"     => "ImPlotMouseTextFlags_",
            "ImPlotDragToolFlags"      => "ImPlotDragToolFlags_",
            "ImPlotColormapScaleFlags" => "ImPlotColormapScaleFlags_",
            "ImPlotItemFlags"          => "ImPlotItemFlags_",
            "ImPlotLineFlags"          => "ImPlotLineFlags_",
            "ImPlotScatterFlags"       => "ImPlotScatterFlags_",
            "ImPlotStairsFlags"        => "ImPlotStairsFlags_",
            "ImPlotShadedFlags"        => "ImPlotShadedFlags_",
            "ImPlotBarsFlags"          => "ImPlotBarsFlags_",
            "ImPlotBarGroupsFlags"     => "ImPlotBarGroupsFlags_",
            "ImPlotErrorBarsFlags"     => "ImPlotErrorBarsFlags_",
            "ImPlotStemsFlags"         => "ImPlotStemsFlags_",
            "ImPlotInfLinesFlags"      => "ImPlotInfLinesFlags_",
            "ImPlotPieChartFlags"      => "ImPlotPieChartFlags_",
            "ImPlotHeatmapFlags"       => "ImPlotHeatmapFlags_",
            "ImPlotHistogramFlags"     => "ImPlotHistogramFlags_",
            "ImPlotDigitalFlags"       => "ImPlotDigitalFlags_",
            "ImPlotImageFlags"         => "ImPlotImageFlags_",
            "ImPlotTextFlags"          => "ImPlotTextFlags_",
            "ImPlotDummyFlags"         => "ImPlotDummyFlags_",
            "ImPlotCond"               => "ImPlotCond_",
            "ImPlotCol"                => "ImPlotCol_",
            "ImPlotStyleVar"           => "ImPlotStyleVar_",
            "ImPlotScale"              => "ImPlotScale_",
            "ImPlotMarker"             => "ImPlotMarker_",
            "ImPlotColormap"           => "ImPlotColormap_",
            "ImPlotLocation"           => "ImPlotLocation_",
            "ImPlotBin"                => "ImPlotBin_"
        }
        // ImPlot value structs are double-based (ImPlotPoint{double x,y}, ImPlotRange,
        // ImPlotRect) — daslang has no double-vector type to alias to, so bind them as
        // managed structs. ImPlotStyle/ImPlotInputMap likewise bound as structs.
        local_type_names <- {
            "ImPlotPoint"    => true,
            "ImPlotRange"    => true,
            "ImPlotRect"     => true,
            "ImPlotStyle"    => true,
            "ImPlotInputMap" => true
        }
        // ShowDemoWindow is implemented in implot_demo.cpp, which we don't compile.
        implot_skip_func <- {
            "ImPlot::ShowDemoWindow" => true
        }
        for (v in values(alias2type)) {
            enums_with_flags.insert(v, true)
        }
    }
    def override skip_anyFunction(var c : CXCursor; isMethod : bool) {
        if (AnyGenBind`skip_anyFunction(self, c, isMethod)) {
            return true
        }
        let function_name = namespace_name(string(clang_getCursorSpelling(c)))
        if (implot_skip_func |> key_exists(function_name)) {
            to_log(LOG_INFO, "skipping IMPLOT blocked function {function_name} at {clang_getCursorLocationDescription(c)}")
            return true
        }
        return false
    }
    def override isArgByValue(name : string) {
        return true
    }
    def override generateModuleHPrefix {
        module_h_file |> fwrite("#include \"cb_dasIMGUI.h\"\n")
        module_h_file |> fwrite("#include \"cb_dasIMPLOT.h\"\n")
        module_h_file |> fwrite("#include \"need_dasIMGUI.h\"\n")
    }
}

[export]
def main {
    var cgb = new ImplotGen()
    defer <| $() {
        unsafe {
            delete cgb
        }
    }
    cgb.require_modules <- [ "imgui" ]
    cgb.already_defined <- {
        "ImGuiContext" => true
    }
    cgb->generate()
    cgb->genCMakeDecl("DAS_IMPLOT_BIND")
}
