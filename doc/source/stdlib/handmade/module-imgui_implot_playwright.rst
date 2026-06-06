The ImPlot-aware test layer over dasImgui's ``imgui_playwright``. ``implot_open(app,
plot_path)`` waits for a plot to render and returns a ``PlotSession`` — just the
``(app, plot_path)`` pair, since ImPlot is stateless (there is no editor handle to
capture, unlike the node-editor's ``EditorSession``).

The readers pull the plot's serialized per-frame state out of the snapshot payload:
``plot_axis_limits`` → ``AxisLimits``, ``plot_visible`` / ``plot_hovered``,
``plot_mouse_pos`` (data coords), ``plot_bbox`` / ``plot_center`` (screen, for
synthetic-move targets). For drag tools, ``handle_path(s, id)`` resolves a handle's
snapshot path and ``drag_point_value`` / ``drag_line_value`` / ``drag_rect_value`` /
``drag_held`` read its bound value. The ``wait_for_*`` polls gate an assertion on a
state change actually landing: ``wait_for_axis_limits`` (axis convergence after a
``SetupAxisLimits`` / zoom / fit), ``wait_for_hovered`` (a synthetic move onto the
plot), ``wait_for_point_moved`` (a synthetic drag moving a point off its baseline).
