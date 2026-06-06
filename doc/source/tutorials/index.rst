.. _tutorials_implot:

##########################
  dasImguiImplot tutorials
##########################

Step-by-step walkthroughs of the ImPlot surface. Each tutorial pairs an annotated
source file under ``examples/tutorial/`` with prose narrating the construction; the
interaction tutorials are additionally backed by a headless regression under
``tests/integration/`` that drives the same gesture.

The annotated example sources are the best starting point — each runs standalone
(windowed), headless (``--headless``), and live (``daslang-live``):

* `line_plot <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/line_plot.das>`_
  — the simplest chart with the v1 thin wrapper (``with_plot`` + ``plot_line``).
* `multi_series <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/multi_series.das>`_
  — the v2 snapshot ``plot`` scope: multi-type items, per-item styling, two plots.
* `drag_tools <https://github.com/borisbat/dasImguiImplot/blob/master/examples/tutorial/drag_tools.das>`_
  — interactive draggable point / threshold line / ROI rect, each with a
  snapshot-serialized value a test can drive.

Narrated, self-verifying recordings of each are planned; this page will grow a
per-tutorial toctree as they land.
