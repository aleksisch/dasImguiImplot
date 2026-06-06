The v2 DSL for `ImPlot <https://github.com/epezent/implot>`_. A chart is a ``plot``
scope — ``plot(IDENT, (title, size, flags)) { ... }`` — that brackets
``BeginPlot`` / ``EndPlot`` so the end call can't be skipped, runs its body only
when the plot is visible, and **serializes the plot's per-frame state** (screen
geometry, axis limits, hovered, mouse-plot-pos) into the dasImgui snapshot rail
under the plot's container path. That snapshot hook is what makes a plot testable
from the :ref:`playwright layer <stdlib_implot_testing_section>`; the query
functions it reads (``GetPlotPos`` / ``GetPlotLimits`` / ``IsPlotHovered`` / …) are
only valid between ``BeginPlot`` and ``EndPlot``, so the capture happens eagerly
in-scope.

Items inside a scope are **OR-typed** over ``float | double | int`` — one
``plot_line`` / ``plot_scatter`` / ``plot_bars`` / … call site regardless of the
element type — with paired ``xs`` / ``ys`` overloads for explicit x/y series.
``Setup*`` wrappers configure axes and the legend; ``SetNext*`` wrappers style the
next item (auto-sentinel defaults mirror ImPlot's "auto"). The interactive
**drag tools** (``drag_point`` / ``drag_line_x`` / ``drag_line_y`` / ``drag_rect``)
each own a persistent state struct the caller passes in: the bound value updates in
place as the handle is dragged, and serializes into the snapshot under
``<plot>/<id>`` with the handle's screen bbox (computed from its data position via
``PlotToPixels``) so a test can target and drag it.
