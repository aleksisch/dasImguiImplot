.. _tutorial_implot_multi_series:

############
Multi series
############

The same chart, now with the **v2 DSL** ``imgui_implot_boost_v2``. The ``plot``
scope here is more than RAII: it is a *snapshot-registered* container. Each frame
it serializes the plot's geometry, axis limits, hovered flag, and mouse-plot
position into the dasImgui snapshot rail, keyed by the window + plot identifiers
(``PLOT_WIN/WAVES``) — which is exactly what the headless tests assert on. The
item wrappers are OR-typed (``float | double | int``), so one call site handles any
element type, and ``SetNext*`` styling colors the next item.

.. code-block:: das

   plot(WAVES, (title = "waves", size = float2(-1.0f, 480.0f), flags = ImPlotFlags.None)) {
       setup_axes("sample", "value")
       setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
       next_line_style(float4(0.30f, 0.70f, 1.00f, 1.00f), 2.0f)
       plot_line("sin", g_sin)
       plot_line("cos", g_cos)
       next_marker_style(ImPlotMarker.Circle, 4.0f)
       plot_scatter("samples", g_pts_x, g_pts_y)   // int / float / double all work
   }

Source: ``examples/tutorial/multi_series.das``.

.. literalinclude:: ../../../examples/tutorial/multi_series.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: multi_series.mp4

The ``plot`` snapshot scope
===========================

``plot(IDENT, (title, size, flags)) { ... }`` is a ``[container]`` macro: the bare
``IDENT`` (``WAVES``) becomes the plot's identifier in the snapshot tree, nested
under its window (``PLOT_WIN/WAVES``). Geometry and the ImPlot queries
(``GetPlotLimits`` / ``IsPlotHovered`` / ``GetPlotMousePos``) are captured *between*
``BeginPlot`` and ``EndPlot`` — the only window where they are valid — so a test
reads them straight back out of the payload. This is the hook the whole
:ref:`testing layer <stdlib_implot_testing_section>` is built on.

OR-typed items
==============

``plot_line`` / ``plot_scatter`` / ``plot_bars`` accept
``array<float> | array<double> | array<int>`` in one signature. The second plot in
the example feeds ``plot_bars`` an ``array<int>`` directly — no conversion, no
separate overload at the call site.

Per-item styling
================

``next_line_style(col, weight)`` and ``next_marker_style(marker, size)`` set the
appearance of the **next** item only (ImPlot's ``SetNext*`` model). Call them
immediately before the item you want to style.

Legend toggle
=============

Every item with a label gets a legend entry, and **clicking an entry hides or shows
that series** — ImPlot handles this for free; the data is still submitted each frame,
it just isn't drawn. The ``plot`` scope serializes the legend into the snapshot — one
entry per series carrying its label, its ``shown`` flag, whether it is ``hovered``, and
its clickable rect — so a test or recording can target an entry by name and verify the
toggle landed. The recording above clicks the *cos* entry to hide the curve and clicks
it again to bring it back, asserting ``shown`` flips each time.

The playwright verb ``legend_toggle(session, "cos")`` drives this the way a person does:
it moves the cursor onto the entry, waits until the entry actually reports ``hovered``
(``wait_for_legend_hover``), and only then clicks — so the synthetic press can't land
before the hover registers. ``wait_for_series_shown(session, "cos", false)`` is the gate
that the click took effect.
