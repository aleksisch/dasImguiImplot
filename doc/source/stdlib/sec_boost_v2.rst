.. _stdlib_implot_boost_v2_section:

******************************
Boost v2 — the ImPlot DSL
******************************

The DSL spine of dasImguiImplot: the ``plot`` / ``subplots`` scopes that serialize
each plot's per-frame state into the snapshot rail, the OR-typed item wrappers
(``plot_line`` / ``plot_scatter`` / ``plot_bars`` / … over float | double | int),
the ``Setup*`` axis/legend and ``SetNext*`` styling wrappers, the interactive drag
tools (``drag_point`` / ``drag_line_x`` / ``drag_line_y`` / ``drag_rect``), and the
data↔pixel coordinate helpers.

.. toctree::

   generated/imgui_implot_boost_v2.rst
