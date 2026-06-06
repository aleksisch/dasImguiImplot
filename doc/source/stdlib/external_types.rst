.. _stdlib_implot_external_types_section:

**************
External types
**************

Types defined by C++-bound sister modules — ImPlot's ``implot`` core binding and
dasImgui's ``imgui_playwright`` — that dasImguiImplot references but does not own.
This page anchors their labels so the generated module pages link without dangling
references; follow the upstream links for the authoritative definitions.
(Daslang-core types such as ``json::JsonValue`` resolve against the `daslang
documentation <https://daslang.io/doc/>`_ via intersphinx.)

.. _enum-implot-ImAxis:

``implot::ImAxis``
==================

An axis selector — ``X1`` / ``X2`` / ``X3`` (the three x axes) and ``Y1`` / ``Y2``
/ ``Y3`` (the three y axes), plus ``Count``. Passed to ``setup_axis`` /
``setup_axis_limits`` and the coordinate helpers to pick which axis pair a value
projects against (``X1`` / ``Y1`` are the defaults).

.. _enum-implot-ImPlotAxisFlags:

``implot::ImPlotAxisFlags``
===========================

Per-axis configuration bits — ``NoLabel``, ``NoGridLines``, ``NoTickMarks``,
``NoTickLabels``, ``Opposite``, ``Foreground``, ``Invert``, ``AutoFit``,
``RangeFit``, ``LockMin``, ``LockMax``, … (plus the ``Lock`` / ``NoDecorations`` /
``AuxDefault`` presets). Passed to ``setup_axes`` / ``setup_axis``.

.. _enum-implot-ImPlotCond:

``implot::ImPlotCond``
======================

When an axis-limit setter applies — ``Once`` (the default; set on first frame, the
user can pan/zoom after) or ``Always`` (re-apply every frame, pinning the range).
Passed to ``setup_axes_limits`` / ``setup_axis_limits`` / ``next_axes_limits``.

.. _enum-implot-ImPlotMarker:

``implot::ImPlotMarker``
========================

The scatter / line marker glyph — ``None``, ``Circle``, ``Square``, ``Diamond``,
``Up``, ``Down``, ``Left``, ``Right``, ``Cross``, ``Plus``, ``Asterisk``. Passed to
``next_marker_style`` to style the next item's markers.

.. _enum-implot-ImPlotLocation:

``implot::ImPlotLocation``
==========================

A 9-cell anchor for the legend / a label — ``Center``, ``North``, ``South``,
``West``, ``East`` and the corner combinations (``NorthWest`` … ``SouthEast``).
Passed to ``setup_legend``.

.. _enum-implot-ImPlotLegendFlags:

``implot::ImPlotLegendFlags``
=============================

Legend behavior bits — ``NoButtons``, ``NoHighlightItem``, ``NoHighlightAxis``,
``NoMenus``, ``Outside``, ``Horizontal``, ``Sort``. Passed to ``setup_legend``.

.. _enum-implot-ImPlotTextFlags:

``implot::ImPlotTextFlags``
===========================

Text-item bits — ``Vertical`` (render the label rotated 90°). Passed to
``plot_text``.

.. _enum-implot-ImPlotDummyFlags:

``implot::ImPlotDummyFlags``
============================

Placeholder bits for ``plot_dummy`` (a legend entry with no drawn data); ``None``
in practice.

.. _enum-implot-ImPlotDragToolFlags:

``implot::ImPlotDragToolFlags``
===============================

Drag-tool behavior bits — ``NoCursors`` (don't change the mouse cursor on hover),
``NoFit`` (a held tool doesn't trigger an auto-fit), ``NoInputs`` (display only,
not draggable), ``Delayed`` (apply the new value one frame late). Passed to
``drag_point`` / ``drag_line_x`` / ``drag_line_y`` / ``drag_rect``.

.. _struct-imgui_playwright-ImguiApp:

``imgui_playwright::ImguiApp``
==============================

The live-app handle from dasImgui's ``imgui_playwright`` testing harness — the base
URL, feature path, and transport for a running ``daslang-live`` instance.
``with_implot_app`` hands one to its block; ``implot_open`` wraps it in a
:ref:`PlotSession <stdlib_implot_testing_section>`. See the `dasImgui documentation
<https://github.com/borisbat/dasImgui>`_.
