.. dasImguiImplot documentation master file.

dasImguiImplot documentation
============================

Part of the daslang ecosystem. See also the `daslang documentation
<https://daslang.io/doc/>`_, `daslang.io <https://daslang.io>`_, and
`dasImgui <https://github.com/borisbat/dasImgui>`_ — this package's dependency.

dasImguiImplot is the daslang binding for
`ImPlot <https://github.com/epezent/implot>`_ (v0.16), an immediate-mode plotting
library for `Dear ImGui <https://github.com/ocornut/imgui>`_. It provides a v2
boost DSL (``plot`` / ``subplots`` scopes, OR-typed ``plot_line`` / ``plot_bars`` /
… items, ``Setup*`` / ``SetNext*`` styling, and draggable point / line / rect
tools), plus a Playwright-style testing harness layered on dasImgui's that
serializes each plot's per-frame state (geometry, axis limits, hovered,
mouse-plot-pos, drag values) into a queryable snapshot.

dasImguiImplot shares dasImgui's single ImGui context — both can be loaded
together, alongside `dasImguiNodeEditor
<https://github.com/borisbat/dasImguiNodeEditor>`_.

**Source code**: https://github.com/borisbat/dasImguiImplot

**Issues**: https://github.com/borisbat/dasImguiImplot/issues

Install
=======

dasImguiImplot depends on dasImgui; daspkg resolves the dependency:

.. code-block:: bash

   daslang utils/daspkg/main.das -- install github.com/borisbat/dasImguiImplot

Or add to your project's ``.das_package``:

.. code-block:: das

   [export]
   def dependencies(version : string) {
       require_package("github.com/borisbat/dasImguiImplot")
   }

Then run ``daspkg install``.

.. toctree::
   :maxdepth: 2
   :caption: Contents

   tutorials/index
   stdlib/index
