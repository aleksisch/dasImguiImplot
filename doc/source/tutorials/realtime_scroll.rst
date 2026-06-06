.. _tutorial_implot_realtime_scroll:

###############
Realtime scroll
###############

A streaming chart: each frame appends a sample to a capped buffer and re-pins the
x axis to a window that ends at "now", so the plot scrolls as data arrives. The
load-bearing detail is the **condition** on the axis limits —
``ImPlotCond.Always`` re-applies the range every frame, where the default
``ImPlotCond.Once`` would set it on the first frame and then let the user pan.

.. code-block:: das

   g_t += DT                                // advance the clock
   g_xs |> push(g_t); g_fast |> push(...)   // append one sample
   if (length(g_xs) > MAX_POINTS) {         // drop the oldest -> fixed-width window
       g_xs |> erase(0); g_fast |> erase(0)
   }
   plot(SCROLL, (title = "scrolling signals", size = float2(-1.0f, 600.0f), flags = ImPlotFlags.None)) {
       setup_axes("time (s)", "value")
       setup_axes_limits(g_t - HISTORY, g_t, -1.2lf, 1.2lf, ImPlotCond.Always)
       plot_line("fast", g_xs, g_fast)
   }

Source: ``examples/tutorial/realtime_scroll.das``.

.. literalinclude:: ../../../examples/tutorial/realtime_scroll.das
   :language: das
   :linenos:

The rolling buffer
==================

The buffer is three parallel ``array<double>`` (one x, two y) trimmed together:
``push`` appends the new sample, and once the length exceeds ``MAX_POINTS`` an
``erase(0)`` drops the oldest. ``MAX_POINTS`` is sized at roughly
``HISTORY / DT`` so the buffer holds exactly the visible window.

Pinning the x window
====================

``setup_axes_limits(g_t - HISTORY, g_t, …, ImPlotCond.Always)`` keeps the x range
a fixed ``HISTORY``-wide window whose right edge is the current time ``g_t``. Because
``g_t`` advances every frame, the left edge climbs — which is what the
``test_realtime_scroll`` regression checks: it waits for ``x_min`` to pass ``0.5``,
proving the window is genuinely scrolling rather than static.
