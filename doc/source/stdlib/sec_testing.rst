.. _stdlib_implot_testing_section:

****************
Testing harness
****************

The ImPlot testing toolkit: ``with_implot_app`` spawns ``daslang-live`` with both
modules loaded for an integration ``[test]``, and the ``imgui_implot_playwright``
layer (``implot_open`` → ``PlotSession`` + ``plot_*`` / ``drag_*`` readers and
``wait_for_*`` polls) drives and inspects the live plot on top of dasImgui's
``imgui_playwright``.

.. toctree::

   generated/imgui_implot_app.rst
   generated/imgui_implot_playwright.rst
