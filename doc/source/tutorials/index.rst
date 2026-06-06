.. _tutorials_implot:

##########################
  dasImguiImplot tutorials
##########################

Step-by-step walkthroughs of the ImPlot surface. Each tutorial pairs an annotated
source file under ``examples/tutorial/`` with prose narrating the construction.
Every example runs three ways unchanged — standalone (windowed), headless
(``--headless``), and live (``daslang-live``) — because they are all built on the
dasImgui harness. The interaction tutorials are additionally backed by a headless
regression under ``tests/integration/`` that drives or asserts on the same plot
(e.g. ``test_query_and_hover`` moves the synthetic cursor onto the plot below and
checks the reported position).

The tutorials build up in order: a first chart, then the v2 snapshot scope, the
item families (areas, real-time, multiple axes, grids, statistics), and finally
the interactive surface (drag tools, colormaps, live query).

.. toctree::
   :maxdepth: 1

   line_plot.rst
   multi_series.rst
   shaded_and_stairs.rst
   realtime_scroll.rst
   multi_axes.rst
   subplots.rst
   heatmap_histogram.rst
   drag_tools.rst
   colormaps_and_style.rst
   query_and_hover.rst

Narrated, self-verifying screen recordings of each tutorial are a planned
follow-up; each page will grow a ``Walkthrough`` section with its recording as
they land.
