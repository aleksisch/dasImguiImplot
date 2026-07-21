options gen2
options _comment_hygiene = true
options indenting = 4

module imgui_implot_app public

// ImPlot test/recording driver — a thin delegate over dasImgui's generalized
// `imgui_playwright::with_imgui_app`. The only implot-specific knowledge here is:
// load the dasImguiImplot module alongside dasImgui, and resolve
// `modules/dasImguiImplot/...` feature paths under the implot module root. All
// spawn/port/headless/worker/ready/shutdown machinery lives once in with_imgui_app.

require imgui/imgui_playwright public   // with_imgui_app, ImguiApp, post_command, snapshot, wait_*, find_widget
require daslib/fio                      // dir_name
require daslib/module_path              // get_this_module_dir

def private implot_module_root() : string {
    // get_this_module_dir() = <implot-root>/daslib ; one dir up = the root.
    return dir_name(get_this_module_dir())
}

def public with_implot_app(feature_path : string;
                           body : block<(app : ImguiApp) : void>) {
    //! Spawn `daslang-live` against an implot feature with BOTH dasImgui and
    //! dasImguiImplot loaded, run `body` while alive, then shut down. The implot module
    //! is an extra `-load_module` and MUST follow dasImgui, which it requires.
    let root = implot_module_root()
    with_imgui_app(feature_path, [root], root, "modules/dasImguiImplot/", body)
}

def public with_implot_recording_app(feature_path : string;
                                     output_apng_basename : string;
                                     max_seconds : int;
                                     body : block<(app : ImguiApp) : void>) {
    //! Native-fps recording session against an implot tutorial feature. A separate
    //! overload rather than a default `fps`, because gen2's trailing-block sugar can't
    //! see through a default parameter between the last positional and the block.
    with_implot_recording_app(feature_path, output_apng_basename, max_seconds, RECORD_FPS, body)
}

def public with_implot_recording_app(feature_path : string;
                                     output_apng_basename : string;
                                     max_seconds : int;
                                     fps : int;
                                     body : block<(app : ImguiApp) : void>) {
    //! Record an `.apng` of an implot feature with BOTH dasImgui and dasImguiImplot
    //! loaded — the recording counterpart of `with_implot_app`. Relative `feature_path`
    //! and the `.apng` asset dir both resolve under the implot root.
    let root = implot_module_root()
    with_recording_app(feature_path, output_apng_basename, max_seconds, fps,
                       [root], root, root, body)
}
