.. _tutorial_implot_shaded_and_stairs:

#################
Shaded and stairs
#################

Filled areas and step plots. Three items cover the common "area" shapes:
``plot_shaded_between`` fills the region *between two y series* (a confidence /
envelope band), ``plot_shaded`` fills between a series and a horizontal baseline,
and ``plot_stairs`` draws a sample-and-hold step line. ``next_fill_style`` colors
the next filled item, just as ``next_line_style`` colors the next line.

.. code-block:: das

   plot(BAND, (title = "confidence band", size = float2(-1.0f, 420.0f), flags = ImPlotFlags.None)) {
       setup_axes("x", "value")
       setup_axes_limits(0.0lf, double(N), -1.6lf, 1.6lf)
       next_fill_style(float4(0.30f, 0.65f, 1.00f, 0.35f))
       plot_shaded_between("band", g_x, g_lo, g_hi)   // fill between two curves
       next_line_style(float4(0.20f, 0.55f, 1.00f, 1.00f), 2.0f)
       plot_line("mean", g_x, g_mid)
   }

Source: ``examples/tutorial/shaded_and_stairs.das``.

.. literalinclude:: ../../../examples/tutorial/shaded_and_stairs.das
   :language: das
   :linenos:

Bands between two series
========================

``plot_shaded_between(id, xs, ys1, ys2)`` fills the vertical region between
``ys1`` and ``ys2`` at each x. The example builds a band whose half-width grows
with x, so the fill is visibly wider on the right — a typical way to show a
confidence interval around the ``mean`` line drawn on top of it.

Fill to a baseline
==================

``plot_shaded(id, values, yref)`` fills between ``values`` and the horizontal line
``y = yref`` (default ``0``). In the second plot it fills the area under the step
series; pass a non-zero ``yref`` to fill toward a different baseline.

Step plots
==========

``plot_stairs(id, values)`` connects samples with horizontal-then-vertical
segments instead of straight lines — the right shape for piecewise-constant data
(counts per bucket, a held signal).
