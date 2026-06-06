.. _tutorial_implot_line_plot:

#########
Line plot
#########

The simplest ImPlot chart, with the v1 thin wrapper ``imgui_implot_boost``. A plot
is an RAII scope — ``with_plot`` guarantees the matching ``EndPlot`` — and inside
it each ``plot_line`` draws one y-series. ImPlot shares dasImgui's ImGui context,
so there is nothing to wire up beyond creating an ``ImPlotContext`` once.

.. code-block:: das

   g_ctx = implot::CreateContext()          // once, after the ImGui context
   with_plot("waves", float2(-1.0f, 620.0f)) {
       setup_axes("sample", "value")
       setup_axes_limits(0.0lf, 200.0lf, -1.5lf, 1.5lf)
       plot_line("sin", g_sin)              // x = sample index
       plot_line("cos", g_cos)
   }

Source: ``examples/tutorial/line_plot.das``.

.. literalinclude:: ../../../examples/tutorial/line_plot.das
   :language: das
   :linenos:

The ImPlot context
==================

``implot::CreateContext()`` returns an ``ImPlotContext?`` that holds ImPlot's
per-frame state. Create it once in ``init`` (after ``harness_init`` has made the
ImGui context) and ``DestroyContext`` it at shutdown. The name is qualified
``implot::`` because dasImgui also exports a ``CreateContext``.

The plot scope
==============

``with_plot(title, size)`` opens a plot and closes it for you. A ``size`` of
``float2(-1.0f, 620.0f)`` means *fill the available width, 620 px tall* — the ``-1``
sentinel is ImPlot's "use the remaining space on that axis". ``setup_axes`` labels
the axes and ``setup_axes_limits`` fixes the initial visible range; both must run
before any item is drawn in the scope.

Items
=====

``plot_line(label, ys)`` draws ``ys`` against an implicit ``x = 0, 1, 2, …`` (the
sample index). The two-argument form ``plot_line(label, xs, ys)`` takes an explicit
x series instead. The next tutorial, :ref:`tutorial_implot_multi_series`, moves to
the v2 ``plot`` scope and adds scatter, bars, and per-item styling.
