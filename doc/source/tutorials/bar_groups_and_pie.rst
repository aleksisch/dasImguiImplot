.. _tutorial_implot_bar_groups_and_pie:

##################################
Bar groups and pie
##################################

The two **categorical** items — the ones whose data points carry a *name*, not just
a number. ``plot_bar_groups`` draws several labelled series clustered into groups (a
grouped or stacked bar chart); ``plot_pie_chart`` splits a whole into named slices.
Both take their per-series labels as a plain ``array<string>``: a daslang string
array is already laid out as the ``const char* const[]`` block ImPlot wants, so the
labels pass straight through with no repacking — the same fact dasImgui's ``list_box``
relies on.

.. code-block:: das

   // 3 series x 4 groups, flat row-major (values[item*GROUPS + group])
   var g_bar_labels <- ["merchant", "consumer", "industrial"]
   var g_bar_values <- [10.0lf, 14.0lf,  9.0lf, 12.0lf,
                         8.0lf, 11.0lf, 13.0lf,  7.0lf,
                         6.0lf,  9.0lf, 15.0lf, 10.0lf]
   ...
   plot(BARS, (title = "quarterly volume", size = float2(560.0f, 560.0f), flags = ImPlotFlags.None)) {
       setup_axes("group", "value")
       plot_bar_groups(g_bar_labels, g_bar_values, ITEMS, GROUPS)
   }
   plot(PIE, (title = "budget split", size = float2(-1.0f, 560.0f), flags = ImPlotFlags.Equal)) {
       setup_axes("", "", ImPlotAxisFlags.NoDecorations, ImPlotAxisFlags.NoDecorations)
       setup_axes_limits(0.0lf, 1.0lf, 0.0lf, 1.0lf, ImPlotCond.Always)
       plot_pie_chart(g_pie_labels, g_pie_values, 0.5lf, 0.5lf, 0.45lf, "%.0f%%")
   }

Source: ``examples/tutorial/bar_groups_and_pie.das``.

.. literalinclude:: ../../../examples/tutorial/bar_groups_and_pie.das
   :language: das
   :linenos:

Bar groups
==========================

``plot_bar_groups(label_ids, values, item_count, group_count, group_size, shift, flags)``
plots ``item_count`` series across ``group_count`` clusters. ``values`` is one flat
array of ``item_count * group_count`` numbers in **row-major** order — series ``i``'s
value for group ``g`` is ``values[i*group_count + g]`` — and ``label_ids`` names one
series per row (the names appear in the legend, each in its series color). The groups
sit at integer x positions ``0 .. group_count-1`` by default. Two flags reshape the
chart without touching the data: ``ImPlotBarGroupsFlags.Stacked`` stacks the series
within each group instead of placing them side by side, and ``ImPlotBarGroupsFlags.Horizontal``
swaps the bars onto the y-axis.

Pie charts
==========================

``plot_pie_chart(label_ids, values, x, y, radius, label_fmt, angle0, flags)`` draws one
slice per ``(label_ids, values)`` pair, centered at data-coordinates ``(x, y)`` with
``radius`` in data units. A pie wants a **square, decoration-free** coordinate space:
set ``ImPlotFlags.Equal`` on the plot so the circle is not stretched, hide both axes with
``ImPlotAxisFlags.NoDecorations``, and pin the limits to ``[0,1] x [0,1]``. ``label_fmt`` is
a printf format applied to each slice's value (``"%.0f%%"`` here) — pass ``""`` to draw no
slice labels. Values need not sum to one; the ``Normalize`` flag forces a full circle when
they sum to less than one.

Coloring
==========================

Both items auto-color from the active colormap — series and slices take successive
colormap entries, exactly like the auto-colored lines in
:ref:`colormaps and style <tutorial_implot_colormaps_and_style>`. Wrap either plot in
``with_colormap(...)`` to recolor the whole family, or call ``next_fill_style(col)`` before
a single ``plot_bars`` to override one series.

Testing the categorical items
=============================

``test_bar_groups_and_pie`` opens both plots through the
:ref:`playwright layer <stdlib_implot_testing_section>` and asserts each rendered. The bar
plot pins its axis limits with ``ImPlotCond.Always``, so ``wait_for_axis_limits`` converging
proves the scope ran *past* ``plot_bar_groups`` — i.e. the labelled-series item submitted,
exercising the ``array<string>`` → ``const char* const[]`` path end to end on the real
headless render.
