.. _tutorial_implot_colormaps_and_style:

###################
Colormaps and style
###################

Push a colormap and the items + heatmaps inside it auto-color from it; draw the
matching colorbar with ``colormap_scale``. A colormap maps a normalized ``t`` in
``[0,1]`` to a color — ``with_colormap`` makes one active for a scope, every
auto-colored ``plot_line`` takes the next color in the map, and a heatmap samples
its cells from it.

.. code-block:: das

   with_colormap(ImPlotColormap.Viridis) {
       plot(HEAT, (title = "heatmap (Viridis)", size = float2(560.0f, 480.0f), flags = ImPlotFlags.None)) {
           setup_axes("col", "row")
           plot_heatmap("vals", g_heat, ROWS, COLS, 0.0lf, 1.0lf, "")
       }
       same_line()
       colormap_scale("scale", 0.0lf, 1.0lf, ImPlotColormap.Viridis, float2(80.0f, 480.0f))
   }

Source: ``examples/tutorial/colormaps_and_style.das``.

.. literalinclude:: ../../../examples/tutorial/colormaps_and_style.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: colormaps_and_style.mp4

A guided tour of the two ways a colormap shows up. The cursor drifts to the
colorbar beside the heatmap — Viridis is a *sequential* colormap, so the bar reads
as a smooth ramp from low to high (the natural fit for a heatmap, and the
sequential-ramp case forward-referenced from
:ref:`heatmap and histogram <tutorial_implot_heatmap_histogram>`) — then glides to
the six auto-colored series, each taking the next color from one Spectral scope. The
recording self-verifies that both plots render at every beat.

.. note::

   Changing a colormap **live** does not recolor *existing* auto-colored items: ImPlot
   caches each item's color by id on first draw, so ``with_colormap`` only colors items
   created inside its scope for the first time. To recolor a steady set of items after a
   colormap switch, call ImPlot's ``BustColorCache(plot_title)`` (clears the cache so the
   items re-pull) or set each item's color explicitly from ``sample_colormap`` /
   ``GetColormapColor``.

The colormap scope
==================

``with_colormap(cmap) { ... }`` pushes ``cmap`` for the body and pops it after — the
RAII form, so the pop can't be skipped. ``cmap`` is the ``ImPlotColormap`` enum
(``Deep`` / ``Viridis`` / ``Plasma`` / ``Jet`` / ``Spectral`` / ``Greys`` / …); the
binding exposes ImPlot's typedef-int colormap handle directly as that enum. For
manual control, ``push_colormap`` / ``pop_colormap`` are the non-scoped pair.

The colorbar
============

``colormap_scale(label_id, lo, hi, cmap, size)`` draws a vertical colorbar legend
spanning ``[lo, hi]`` for ``cmap``. Pass the *same* colormap you pushed so the bar
matches the heatmap beside it. (The parameter is ``label_id``, not ``label`` —
``label`` is a reserved word.) The colormap is a required argument here because the
native ``ColormapScale`` takes a real colormap, not the ``IMPLOT_AUTO`` sentinel.

Auto-colored series
===================

In the second plot, six ``plot_line`` calls inside a ``with_colormap(Spectral)``
scope each take the next color from the map — no per-series color set. This is the
usual way to color a family of related series consistently.

``sample_colormap(t, cmap)`` returns the color at ``t`` in ``[0,1]`` directly, for
when you need a colormap color outside a plot (a legend swatch, a custom drawing).
