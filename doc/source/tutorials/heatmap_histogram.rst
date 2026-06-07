.. _tutorial_implot_heatmap_histogram:

#################
Heatmap histogram
#################

The two statistical / 2D items, side by side. ``plot_heatmap`` renders a
``rows × cols`` grid (row-major) mapped through the active colormap; ``histogram``
bins a flat sample array into a 1D distribution and returns the largest bin count.
Together they cover the "show me the shape of this data" cases.

.. code-block:: das

   plot(HEAT, (title = "heatmap", size = float2(560.0f, 560.0f), flags = ImPlotFlags.None)) {
       setup_axes("col", "row")
       plot_heatmap("vals", g_heat, ROWS, COLS, 0.0lf, 0.0lf, "")   // auto-scale, no labels
   }
   same_line()
   plot(HIST, (title = "histogram", size = float2(-1.0f, 560.0f), flags = ImPlotFlags.None)) {
       setup_axes("value", "count")
       histogram("samples", g_samples, int(ImPlotBin.Sturges))
   }

Source: ``examples/tutorial/heatmap_histogram.das``.

.. literalinclude:: ../../../examples/tutorial/heatmap_histogram.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: heatmap_histogram.mp4

A guided tour of the two statistical items. The cursor sweeps diagonally across the
heatmap — each cell takes its color from its value through the active colormap, so
the structure in the data shows up as a pattern of colors — then glides to the
histogram, which bins a flat sample array into bars whose shape is the distribution.
There is no interaction to teach beyond the shapes; the recording self-verifies that
both plots render *and* that the synthetic cursor genuinely lands hovered over the
grid, so a dead frame or a missed cursor fails at teardown. A *sequential* colormap
that runs a smooth ramp — the natural fit for a heatmap — is shown in
:ref:`colormaps and style <tutorial_implot_colormaps_and_style>`.

Heatmaps
========

``plot_heatmap(id, values, rows, cols, lo, hi, fmt)`` draws ``values`` (a
``rows*cols`` row-major array) as a grid of colored cells. ``lo == hi`` (both ``0``)
auto-scales the color range to the data; pass explicit bounds to pin it. The format
string labels each cell with its value — ``fmt = ""`` (as here) draws no labels,
which reads better on a dense grid. Cells sample the active colormap, so wrapping a
heatmap in :ref:`with_colormap <tutorial_implot_colormaps_and_style>` recolors it.

Histograms
==========

``histogram(id, values, bins)`` bins ``values`` and returns the largest bin count
(or density, with the ``Density`` flag). ``bins`` is a positive count *or* an
``ImPlotBin`` method — ``Sturges`` / ``Sqrt`` / ``Rice`` / ``Scott`` — cast to int,
which picks the bin count from the sample size. An all-zero range auto-ranges to the
data. (The name is ``histogram``, not ``plot_histogram``: dasImgui already owns that
widget name for ImGui's sparkline.)
