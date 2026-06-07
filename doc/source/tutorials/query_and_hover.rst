.. _tutorial_implot_query_and_hover:

###############
Query and hover
###############

Read the cursor's position *in plot data coordinates* live, and annotate it. Inside
a plot scope ``IsPlotHovered()`` tells you the cursor is over the plot area and
``GetPlotMousePos()`` gives its position in data coordinates — so the example draws
a vertical crosshair and a text label that follow the mouse. The v2 ``plot`` scope
also serializes ``hovered`` + mouse-plot-pos into its snapshot, so a headless test
can move the synthetic cursor onto the plot and assert on exactly the values the
annotation uses.

.. code-block:: das

   plot(CHART, (title = "hover me", size = float2(-1.0f, 600.0f), flags = ImPlotFlags.None)) {
       setup_axes("x", "y")
       setup_axes_limits(0.0lf, double(N), -1.2lf, 1.2lf)
       plot_line("signal", g_wave)
       if (IsPlotHovered()) {
           let mp = GetPlotMousePos(ImAxis.X1, ImAxis.Y1)   // data coords
           g_cursor_x[0] = mp.x
           plot_inf_lines("cursor", g_cursor_x)             // vertical crosshair
           plot_text("({mp.x:.1f}, {mp.y:.2f})", mp.x, mp.y, float2(10.0f, 10.0f))
       }
   }

Source: ``examples/tutorial/query_and_hover.das``.

.. literalinclude:: ../../../examples/tutorial/query_and_hover.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: query_and_hover.mp4

The recording glides the cursor across the plot with real synthetic input: the
vertical crosshair and the ``(x, y)`` label track it every frame, and ImPlot's
corner mouse readout updates alongside. It self-verifies that ``hovered`` flips true
and ``GetPlotMousePos`` resolves into the band the cursor was aimed at — left, then
right — so a dead hover or a frozen readout fails at teardown.

Live query
==========

``IsPlotHovered()`` and ``GetPlotMousePos(x_axis, y_axis)`` are only valid between
``BeginPlot`` and ``EndPlot``, so call them inside the scope body. ``GetPlotMousePos``
returns an ``ImPlotPoint`` (``.x`` / ``.y`` doubles) in data coordinates — already
projected through the axes, so a cursor at screen-x maps to the data value under it.

Annotating the cursor
=====================

``plot_inf_lines(id, [x])`` draws an infinite vertical line at each x in the array —
here a one-element array reused each frame for the crosshair (kept as a global to
avoid a per-frame allocation). ``plot_text(text, x, y, pix_offset)`` anchors a label
at a data point, offset by screen pixels so it sits beside the cursor rather than
under it. The label uses ``fmt`` precision specifiers in the interpolation —
``{mp.x:.1f}`` / ``{mp.y:.2f}`` — so it reads ``(74.0, -0.19)`` instead of full
double precision.

Testing the hover
=================

``test_query_and_hover`` calls ``move_to(d, plot_center(...))`` to put the
synthetic cursor on the plot, ``wait_for_hovered`` until the snapshot reports it,
then reads ``plot_mouse_pos`` and asserts it falls inside the axis range — the same
synthetic-equals-real path the drag tools rely on.
