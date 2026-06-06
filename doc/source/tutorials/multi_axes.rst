.. _tutorial_implot_multi_axes:

##########
Multi axes
##########

Two y axes with independent ranges on one plot. Temperature (``0..30``) and
pressure (``~1000 hPa``) would be unreadable sharing a single axis, so pressure
gets its own right-hand y axis. Three calls do it: ``setup_axis`` enables the
second axis, ``setup_axis_limits`` ranges it, and ``set_axis`` routes the *next*
items onto it.

.. code-block:: das

   plot(CHART, (title = "weather", size = float2(-1.0f, 600.0f), flags = ImPlotFlags.None)) {
       setup_axes("hour", "temp (C)")
       setup_axis(ImAxis.Y2, "pressure (hPa)", ImPlotAxisFlags.AuxDefault)   // enable Y2
       setup_axis_limits(ImAxis.Y1, 0.0lf, 30.0lf)
       setup_axis_limits(ImAxis.Y2, 950.0lf, 1050.0lf)
       plot_line("temp", g_temp)        // default Y1
       set_axis(ImAxis.Y2)              // route what follows to Y2
       plot_line("pressure", g_press)
   }

Source: ``examples/tutorial/multi_axes.das``.

.. literalinclude:: ../../../examples/tutorial/multi_axes.das
   :language: das
   :linenos:

Enabling a second axis
======================

``setup_axis(ImAxis.Y2, label, ImPlotAxisFlags.AuxDefault)`` turns on the second
y axis with a sensible default style (auto-fit, opposite side). ImPlot supports up
to three of each — ``Y1`` / ``Y2`` / ``Y3`` and likewise for x. Each is ranged
independently with ``setup_axis_limits(axis, …)``.

Routing items to an axis
========================

Items go on whichever axis pair is *current*; ``Y1`` is the default. ``set_axis(axis)``
switches the current y axis so every item after it draws against that axis —
here, ``plot_line("pressure", …)`` lands on ``Y2``. The two-axis form
``set_axes(x_axis, y_axis)`` switches both at once. Because the snapshot captures
``GetPlotLimits(X1, Y1)``, the ``test_multi_axes`` regression asserts Y1 stays
``[0,30]`` — confirming pressure's ``[950,1050]`` lives on a genuinely separate axis.
