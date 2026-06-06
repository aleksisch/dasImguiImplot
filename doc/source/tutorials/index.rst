.. _tutorials_implot:

##########################
  dasImguiImplot tutorials
##########################

Step-by-step walkthroughs of the ImPlot surface. Each tutorial pairs an annotated
source file under ``examples/tutorial/`` with prose narrating the construction; the
interaction tutorials are additionally backed by a headless regression under
``tests/integration/`` that drives the same gesture.

The annotated example sources are the best starting point — each runs standalone
(windowed), headless (``--headless``), and live (``daslang-live``). They build up in
order, and each (except the two simplest) is backed by a headless regression under
``tests/integration/`` that drives or asserts on the same plot:

* `line_plot <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/line_plot.das>`_
  — the simplest chart with the v1 thin wrapper (``with_plot`` + ``plot_line``).
* `multi_series <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/multi_series.das>`_
  — the v2 snapshot ``plot`` scope: multi-type items (``float|double|int``), per-item
  styling, two plots in one window.
* `shaded_and_stairs <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/shaded_and_stairs.das>`_
  — filled areas and step plots: ``plot_shaded_between`` (a band), ``plot_shaded``
  (fill to a baseline), ``plot_stairs``.
* `realtime_scroll <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/realtime_scroll.das>`_
  — a rolling buffer streamed each frame against an x window pinned with
  ``ImPlotCond.Always`` so the plot scrolls.
* `multi_axes <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/multi_axes.das>`_
  — a second y axis (``setup_axis(ImAxis.Y2, …)``) with ``set_axis`` routing an item
  to it; two series on wildly different scales.
* `subplots <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/subplots.das>`_
  — a ``subplots`` grid; each cell is its own snapshot-registered ``plot``.
* `heatmap_histogram <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/heatmap_histogram.das>`_
  — the statistical items: ``plot_heatmap`` (a 2D grid) beside ``histogram`` (a 1D
  distribution).
* `drag_tools <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/drag_tools.das>`_
  — interactive draggable point / threshold line / ROI rect, each with a
  snapshot-serialized value a test can drive.
* `colormaps_and_style <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/colormaps_and_style.das>`_
  — ``with_colormap`` so items + heatmaps auto-color from a pushed colormap, plus the
  matching ``colormap_scale`` colorbar.
* `query_and_hover <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/query_and_hover.das>`_
  — read ``GetPlotMousePos`` / ``IsPlotHovered`` live and annotate the cursor with
  ``plot_text`` + a crosshair.

Narrated, self-verifying recordings of each are planned; this page will grow a
per-tutorial toctree as they land.
