The integration-test entry point. ``with_implot_app(feature_path) $(app) { ... }``
spawns ``daslang-live`` against an ImPlot feature with **both** the dasImgui and
dasImguiImplot modules loaded, runs the block against the live app, then shuts
down — panicking on ready-timeout, test-timeout, or non-zero exit so the
surrounding ``[test]`` fails.

It is a thin delegate over dasImgui's ``imgui_playwright::with_imgui_app``: the
only ImPlot-specific knowledge is loading the implot module alongside dasImgui (a
daspkg dependency, so it loads after it) and resolving
``modules/dasImguiImplot/...`` feature paths under the implot module root. All the
spawn / port / headless / worker-index / ready / shutdown machinery lives once in
``with_imgui_app``. ``with_implot_recording_app`` is the same delegate threading
APNG capture through ``with_recording_app`` for tutorial recordings.
