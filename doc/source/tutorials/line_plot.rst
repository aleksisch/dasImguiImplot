.. _tutorial_implot_line_plot:

#########
Line plot
#########

The simplest ImPlot chart. A plot is an RAII scope — the ``plot`` container guarantees
the matching ``EndPlot`` — and inside it each ``plot_line`` draws one y-series. ImPlot
shares dasImgui's ImGui context, so there is nothing to wire up beyond creating an
``ImPlotContext`` once. The ``plot`` container also serializes the plot's per-frame state
(geometry, axis limits, hovered, mouse position) into the snapshot, which is what lets a
test or recording read and drive it.

.. code-block:: das

   g_ctx = implot::CreateContext()          // once, after the ImGui context
   plot(WAVES, (title = "waves", size = float2(-1.0f, 620.0f), flags = ImPlotFlags.None)) {
       setup_axes("sample", "value")
       setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)   // initial range, cond=Once
       plot_line("sin", g_sin)              // x = sample index
       plot_line("cos", g_cos)
   }

Source: ``examples/tutorial/line_plot.das``.

.. literalinclude:: ../../../examples/tutorial/line_plot.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: line_plot.mp4

The ImPlot context
==================

``implot::CreateContext()`` returns an ``ImPlotContext?`` that holds ImPlot's
per-frame state. Create it once in ``init`` (after ``harness_init`` has made the
ImGui context) and ``DestroyContext`` it at shutdown. The name is qualified
``implot::`` because dasImgui also exports a ``CreateContext``.

The plot scope
==============

``plot(IDENT, (title, size, flags)) { ... }`` opens a plot and closes it for you. A
``size`` of ``float2(-1.0f, 620.0f)`` means *fill the available width, 620 px tall* — the
``-1`` sentinel is ImPlot's "use the remaining space on that axis". ``setup_axes`` labels
the axes and ``setup_axes_limits`` fixes the *initial* visible range; both must run before
any item is drawn in the scope. The limits default to ``ImPlotCond.Once``, so they seed the
first frame and then leave the user free to pan and zoom.

The ``IDENT`` (``WAVES``) is a bareword the container uses to register the plot in the
snapshot — that is what distinguishes the v2 ``plot`` from the v1 ``imgui_implot_boost``
``with_plot``, which is otherwise the same scope but registers nothing.

View navigation
===============

ImPlot views are interactive out of the box, and these gestures work on every plot in the
rest of the tutorials:

- **Pan** — left-drag inside the plot area; the whole view slides under the cursor.
- **Zoom** — scroll the wheel over the plot; it zooms around the point under the cursor.
- **Fit** — double-click anywhere in the plot to snap the axes back to the data bounds.

Because the gestures change the axis limits (and the ``plot`` scope serializes those), the
recording above drives each one for real and asserts the limits actually moved — a no-op
would fail the recording.

Items
=====

``plot_line(label, ys)`` draws ``ys`` against an implicit ``x = 0, 1, 2, …`` (the
sample index). The two-argument form ``plot_line(label, xs, ys)`` takes an explicit
x series instead. The next tutorial, :ref:`tutorial_implot_multi_series`, adds scatter,
bars, and per-item styling, and shows how to toggle a series from the legend.
