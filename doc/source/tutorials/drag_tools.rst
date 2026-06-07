.. _tutorial_implot_drag_tools:

##########
Drag tools
##########

Interactive handles you drag inside a plot. ``drag_point`` is a draggable
``(x, y)`` marker, ``drag_line_x`` a draggable vertical line (a threshold),
``drag_rect`` a draggable rectangle (a region of interest). Unlike the plot items,
a drag tool owns mutable state — the value being dragged — so the caller passes a
**persistent** state struct (a global). The value updates in place each frame and
serializes into the snapshot under ``<plot>/<id>``, so a test can read the handle's
screen bbox, synth-drag it, and assert the bound value moved.

.. code-block:: das

   var g_pt : DragPointState        // persistent: holds the dragged (x, y)
   ...
   plot(WAVES, (title = "interactive", size = float2(-1.0f, 620.0f), flags = ImPlotFlags.None)) {
       plot_line("sin", g_sin)
       drag_rect(g_roi, "roi", float4(1.0f, 0.0f, 1.0f, 0.35f))
       drag_line_x(g_thresh, "thresh", float4(0.2f, 1.0f, 0.3f, 1.0f), 2.0f)
       drag_point(g_pt, "p0", float4(1.0f, 0.9f, 0.1f, 1.0f), 6.0f)   // drawn last -> grabs first
   }

Source: ``examples/tutorial/drag_tools.das``.

.. literalinclude:: ../../../examples/tutorial/drag_tools.das
   :language: das
   :linenos:

Walkthrough
===========

.. video:: drag_tools.mp4

The recording drives each handle with real synthetic input and self-verifies the
bound value moved. The yellow point follows the cursor in ``x`` and ``y``; the green
threshold line slides along ``x``; and the magenta region shows its **two modes** —
grab the body (near the center) to move the whole rectangle, with all four bounds
travelling together, or grab a **corner** to resize it, where only that corner moves.
A missed grab or a frozen handle fails the recording at teardown.

Persistent state
================

Each tool takes a ``var`` state struct the caller keeps alive across frames —
``DragPointState{x, y, held}``, ``DragLineState{value, held}``,
``DragRectState{x_min, y_min, x_max, y_max, held}``. The wrapper writes the new
value back through it each frame, and ``held`` is true on the frames the handle is
grabbed. Initialize them in ``init`` and read them wherever you need the current
value.

Overlap and draw order
======================

Drag tools grab by an invisible rect around the handle. If two handles' grab rects
overlap, one steals the active-id and the wrong tool moves — so the example keeps
the point, the threshold line, and the ROI **spatially separated**, and draws them
back-to-front so the point (drawn last) sits on top and grabs first.

Driving them in tests
=====================

The handle's snapshot path is ``handle_path(session, id)`` (e.g.
``PLOT_WIN/WAVES/p0``). The :ref:`playwright layer <stdlib_implot_testing_section>`
reads ``drag_point_value`` / ``drag_line_value`` / ``drag_rect_value`` from the
payload, and ``wait_for_point_moved`` gates a synthetic ``drag`` actually landing —
which is how ``test_drag_tools`` proves the synthetic drag moves the bound value
exactly as a real mouse would.
