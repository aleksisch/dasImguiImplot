.. _tutorial_implot_subplots:

########
Subplots
########

A grid of linked plots that share one region. ``subplots`` opens a ``rows × cols``
grid; each ``plot`` inside fills the next cell in turn. The grid manages cell size
and (optionally) shared axes, panning, and zoom — so the per-plot ``size`` argument
is ignored inside a grid. Both the grid and every cell register in the snapshot
tree, the cells nested under the grid.

.. code-block:: das

   subplots(GRID, (title = "trig grid", rows = 2, cols = 2,
                   size = float2(-1.0f, 640.0f), flags = ImPlotSubplotFlags.None)) {
       plot(P_SIN,  (title = "sin",    size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) { plot_line("sin", g_sin) }
       plot(P_COS,  (title = "cos",    size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) { plot_line("cos", g_cos) }
       plot(P_DAMP, (title = "damped", size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) { plot_line("damped", g_damp) }
       plot(P_BARS, (title = "bars",   size = float2(-1.0f, -1.0f), flags = ImPlotFlags.None)) { plot_bars("bars", g_bars) }
   }

Source: ``examples/tutorial/subplots.das``.

.. literalinclude:: ../../../examples/tutorial/subplots.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: subplots.mp4

The grid container
==================

Like ``plot``, ``subplots`` is a ``[container]`` macro: the bare ``IDENT`` (``GRID``)
plus a named tuple of the remaining arguments (``rows`` / ``cols`` / ``size`` /
``flags``), then a body. Note the **named** arguments — a positional call fails to
compile (``required argument 'flags' has no default``). The body simply issues
``rows * cols`` ``plot`` scopes; ImPlot drops each into the next cell.

Nested snapshot paths
=====================

The grid registers as ``PLOT_WIN/GRID`` and each cell nests beneath it —
``PLOT_WIN/GRID/P_SIN``, ``…/P_COS``, and so on. The ``test_subplots`` regression
opens both the grid (asserting ``BeginSubplots`` returned true) and the first cell
by its nested path, confirming the cells snapshot independently.

Box zoom one cell
=================

Every cell is independently interactive. Right-drag a box inside a cell — the
tick-marked rubber band in the walkthrough — and that cell zooms to the box.
Because this grid uses ``ImPlotSubplotFlags.None`` (no linked axes), only the boxed
cell zooms; the other three keep their full range. Linking is opt-in: add
``ImPlotSubplotFlags.LinkAllX`` / ``LinkAllY`` (or the per-row/col variants) to make
the cells share an axis, so a zoom or pan in one drives them all. The recording
drives the right-drag with real synthetic input and asserts the boxed cell's range
shrank while a neighbour's stayed put, so a zoom that bled across cells fails it.
