# Recording tutorial videos (dasImguiImplot)

dasImguiImplot ships an MP4 per tutorial page under `doc/source/_static/tutorials/*.mp4`, each
cited from its RST with `.. video:: name.mp4`. A recording is produced by a **one-shell driver**
under `tests/integration/record_*.das` that spawns its own `daslang-live` host (the tutorial
feature file) and drives it over the live API. Every recording carries a **voiceover + music
soundtrack** and is **also a self-verifying integration test** — every interaction it narrates
is performed with real synthetic input and asserted against the plot's actual state.

This is the implot-specific recipe. The **pipeline tools and the deep mechanics are shared with
dasImgui** (`prepare_recording` / `convert_recording` live in the dasImgui repo). Read the
canonical pipeline skill once for the internals (fps_eff reclocking, the synchronous APNG writer,
the ffmpeg filtergraph, `hold_through_voice` / `say_begin` semantics):
<https://github.com/borisbat/dasImgui/blob/master/skills/recording.md>. This page covers what is
different for plots, plus the exact cross-repo commands.

Recording is NOT in CI (it needs a display). The headless `test_*.das` per tutorial is the CI
guard; the `record_*.das` driver is a manual artifact producer. Record **one tutorial at a time**
— concurrent driver runs collide on live-API port 9090, and each `.mp4` is reviewed before it ships.

## The three hard requirements (REQUIRED)

Identical to dasImgui. A recording that violates any of these is wrong and must not ship.

1. **Do what it teaches — drive it like a human.** Perform the real interaction the narration
   describes, using real synthetic input only (drag to pan, scroll to zoom, drag a handle, hover).
   Never shortcut a gesture by writing state directly. Pointing the caption at a plot without
   driving it is not a tutorial — *unless* the tutorial's subject is genuinely a static display
   (see the interaction model below).
2. **Self-verify every step.** A recording is an integration test. Each interaction is asserted
   against the plot's snapshot via the accumulate-on-miss verifiers (`record_check_changed` /
   `record_check_rendered`, re-exported from dasImgui's `imgui_playwright`): a miss is recorded and
   the recording **aborts loudly with a panic at `with_implot_recording_app` teardown** (after a
   clean `record_stop` + `/shutdown`), so a dud can never silently ship.
3. **Pace by the voice, not fixed sleeps.** `say_begin` returns the spoken line's dwell; perform
   the gesture under the voice and hold the caption for the remainder. For a hand-rolled gesture
   beat (most plot beats), measure real elapsed work with `ref_time_ticks()` / `get_time_usec()`
   and sleep only the remainder, so the next `say_begin` cannot fire early and overlap the voice.

Plus: **captions and voice strings must be ASCII.** The bundled ImGui font has no em-dash / arrow /
smart-quote glyph (`?` tofu in the caption). And for the **voice** specifically, use plain spaces,
not hyphens — Kokoro pauses on a hyphen ("right click", not "right-click"; "double click", not
"double-click"). Numbers read better spelled out ("two hundred", not "200").

## Ship / no-ship checklist

- [ ] Does what it teaches, driven like a human (real synth gesture, never state-poke). *(req 1)*
- [ ] Self-verifies every interaction via `record_check_*`; a no-op aborts at teardown. *(req 2)*
- [ ] Paced by the voice; no hand-tuned `sleep` for the dwell. *(req 3)*
- [ ] Caption terse (eye) vs voice natural (ear); **ASCII only**, plain spaces in voice.
- [ ] Example is correct — the feature `.das` compiles, runs, demonstrates cleanly (fix it in this pass).
- [ ] Page is accurate — the RST matches the current example and `.. video::`-cites the fresh `.mp4`.
- [ ] Recording is clean — `dropped == 0`, sidecar frames == APNG `nb_read_frames`, voice + bed muxed,
      ffprobe `video.dur ≈ audio.dur`, mp4 ≈ 0.5–1.5 MB, **eyeballed and approved**.

A dasImgui/implot library bug surfaced while fixing a tutorial ships as its **own immediate PR**,
not buried in the recording commit.

## The interaction model for plots

Plots are not clickable widgets, so "drive it like a human" splits into two honest modes (same
split node-editor uses for nodes):

- **Real-gesture** — the tutorial's subject *is* an interaction. Perform + verify it:
  `drag_tools` (drag the handles → `wait_for_point_moved`), `query_and_hover` (hover →
  `wait_for_hovered` + `plot_mouse_pos`), `realtime_scroll` (narrate over the live animation,
  assert `x_min` advances).
- **Display-tour** — the subject is the *item type*, not an interaction. Move the cursor to the
  plot or to a specific data feature (via `plot_to_pixels`), `record_check_rendered` the plot, and
  narrate. This is a legitimate tutorial (node-editor's `first_graph` set the bar).

**The no-repeat rule (Boris):** each tutorial shows **at most one new interaction**, introduced
the first time it is natural, and **never repeats** one already shown. Where nothing new applies,
it is a display-tour. The series as a whole teaches the full interactive surface with no redundancy.
Current assignment (firm up per-tutorial at live-probe time):

| Tutorial | New interaction | |
|---|---|---|
| `line_plot` | pan (drag) + zoom (scroll) + fit (double-click) — view-nav, taught first | rail-free |
| `multi_series` | legend-click → toggle a series | needs the legend rail |
| `multi_axes` | drag one axis to rescale just it | maybe axis-region rail |
| `subplots` | box-select zoom in one cell (right-drag) | rail-free |
| `drag_tools` | drag the handles (subject) | exists |
| `query_and_hover` | hover → value readout (subject) | exists |
| `realtime_scroll` | live auto-scroll | rail-free |
| others | display-tour (interaction already shown) | — |

### Verify primitives (implot_playwright)

The v2 `plot` container serializes the plot into the snapshot; these read it (all keyed on a
`PlotSession` from `implot_open(app, "WIN/PLOT")`):

- `plot_visible(snap, s)` / `record_check_rendered(app, path, true)` — the plot drew this frame.
- `plot_axis_limits(snap, s)` + `wait_for_axis_limits(s, x0,x1,y0,y1)` — gate an axis change landing.
- `plot_hovered(snap, s)` + `wait_for_hovered(s, true)` ; `plot_mouse_pos(snap, s)` (data coords).
- `plot_bbox` / `plot_center` ; `plot_to_pixels` / `pixels_to_plot` — aim the cursor at *data*.
- drag tools: `handle_path(s, id)`, `drag_point_value` / `drag_line_value` / `drag_rect_value`,
  `wait_for_point_moved`.
- For "the axes moved" without a known target, capture `write_json(widget_payload_field(snap, path,
  "x_max"))` before the gesture and `record_check_changed(app, path, "x_max", before)` after.
  (`x_min` is omitted from the payload when it is exactly 0 — the `@optional`-zero trap — so verify
  on `x_max`, which the seeded examples keep non-zero.)

## Author by live-probing, not guessing

Determine the gesture live, then bake the proven sequence into the driver. Launch the host with
**both** modules loaded and set user-control off before any synth input:

```
mcp__daslang__live_launch  file=<implot>/examples/tutorial/<scene>.das  load_modules=[<dasImgui>, <implot>]
mcp__daslang__live_command name=set_user_control args={"enabled":false}
mcp__daslang__live_command name=imgui_snapshot            # plot bbox + axis limits + hovered
mcp__daslang__live_command name=imgui_mouse_play args={"events":[...]}   # try the gesture
mcp__daslang__live_command name=imgui_mouse_scroll args={"x":0,"y":3}    # zoom
mcp__daslang__live_command name=imgui_snapshot            # confirm the axes/value moved
```

Full-restart the host between tries (interactive state contaminates the next probe). Proven gesture
sequences (verified on `line_plot`):

- **Pan** — a **continuous multi-waypoint** left-drag (move to start, press, walk several
  intermediate `move` waypoints with the button held, release). ImPlot integrates `io.MouseDelta`
  per frame, so a single from→to jump (what `drag` / `drag_along` post) does **not** pan. Drive it
  with a driver-local `pan_drag` helper that emits the waypoints.
- **Zoom** — `imgui_mouse_scroll {x:0, y:N}` with the cursor over the plot; positive `y` zooms in,
  around the cursor. Burst a few notches across the voice for a visible zoom.
- **Fit** — a double left-click (two press/release pairs ~40 ms apart in one `imgui_mouse_play`);
  the axes snap to the data bounds.

## The pipeline (cross-repo)

The three tools live in the dasImgui repo; run each with **both** modules loaded so the driver
compiles. `<daslang>` = a daslang build tree, `<dasImgui>` / `<implot>` = the two repos (append
`.exe` on Windows).

**1. prepare** — TTS the `say()` / `say_begin()` voice lines (Kokoro at `:8880`, voice `bf_emma`),
writing `voiceover/<stem>.manifest.json`. Pass `--asset-root <implot>` so the manifest lands beside
where the implot APNG will be written (not in dasImgui).

```
<daslang>/bin/daslang -load_module <dasImgui> -load_module <implot> \
    <dasImgui>/utils/prepare_recording.das -- \
    --driver <implot>/tests/integration/record_<scene>.das \
    --asset-root <implot>
```

**2. record** — run the driver. `with_implot_recording_app` spawns the host, arms the voiceovers,
records the APNG, writes the sidecar, shuts down, and panics with any verification misses.

```
<daslang>/bin/daslang -load_module <dasImgui> -load_module <implot> \
    <implot>/tests/integration/record_<scene>.das
```

**3. convert** — render the music bed to the clip length and ffmpeg-mux APNG + bed + voiceovers to
MP4. Use `--bed-db -16` (the project bar).

```
<daslang>/bin/daslang -load_module <dasImgui> -load_module <implot> \
    <dasImgui>/utils/convert_recording.das -- \
    --apng <implot>/doc/source/_static/tutorials/<scene>.apng --bed-db -16
```

Most scenes land ~0.5–0.8 MB. A **full-motion** scene (e.g. `realtime_scroll`, where the whole
plot changes every frame) defeats H.264 inter-frame compression and runs several MB — add
`--preset veryslow` (smaller at the **same** quality; `realtime_scroll` went 2.77 → 1.54 MB this
way). Shrink with `--preset`, never by raising `--crf` (it stays `23`) — raising crf speckles the
dark background, which is the quality these clips can't spare.

Only the resulting `.mp4` is tracked. The `.apng`, `voiceover/*`, `*.manifest.json`,
`*.sidecar.json`, `*_music.wav`, `*.mp4.ffmpeg.txt` are intermediates and gitignored.

Verify before review: `ffprobe` the mp4 (`video.dur ≈ audio.dur`, `nb_read_frames` == record's
frame count, ~0.5–1.5 MB), and extract a few frames
(`ffmpeg -i <scene>.apng -vf "select=eq(n\,N)" -frames:v 1 -update 1 fN.png -y`) to eyeball the arc.

## The driver

`with_implot_recording_app(feature_path, apng_basename, max_seconds [, fps]) $(app) { ... }` —
`feature_path` is **relative to the implot root** (`"examples/tutorial/<scene>.das"`). Size
`max_seconds` for the *silent* run; the recorder auto-extends it by the summed voice dwell.

The driver requires `imgui/imgui_implot_app public` + `imgui/imgui_implot_playwright public` (which
re-export the dasImgui playwright + recording rails: `say` / `say_begin`, `move_to`,
`wait_for_mouse_idle`, `post_command`, `snapshot`, `record_check_*`). See
`tests/integration/record_line_plot.das` for the canonical pan/zoom/fit pattern (the `pan_drag` /
`scroll_zoom` / `double_click` helpers and the `say_begin` → lead → gesture → verify →
`hold_remainder` beat).

## Commit structure

Per scene `foo`, after eyeball approval:

1. `recording: foo` — `tests/integration/record_foo.das` + `doc/source/_static/tutorials/foo.mp4`
   (+ any example/`test_foo.das` fix made in the pass). Intermediates are gitignored.
2. `tutorial: foo RST` — `doc/source/tutorials/foo.rst` (`.. video:: foo.mp4`) + toctree if new.

A framework rail added while recording (e.g. the legend-toggle telemetry) ships as its **own PR**
with a headless test, before the recording that uses it.

## Note: the prepare scanner recognizes consumer wrappers

`prepare_recording` AST-scans the driver for the `with_*_recording_app` call to find the APNG
basename. It matches by suffix (`ends_with(name, "_recording_app")`), so `with_implot_recording_app`
is recognized like `with_recording_app` / `with_node_editor_recording_app`. (If a future fresh
checkout of dasImgui predates that fix, the symptom is `[prepare] no with_recording_app(...) APNG
basename found` — update the scanner's match.)
