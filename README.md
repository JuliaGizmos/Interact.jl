# Interact

Interact.jl allows you to use interactive widgets such as sliders, dropdowns and checkboxes to play with your Julia code.

![Screenshot](http://i.imgur.com/xLWjmNb.png)

## Getting Started

To install Interact, run the following command in the Julia REPL:
```{.julia execute="false"}
Pkg.add("Interact")
```

**Note:** Interact only works with IPython/Jupyter version 3.0 or higher.

To start using it in an IJulia notebook, include it:
```{.julia execute="false"}
using Interact
```
[`GtkInteract`](https://github.com/jverzani/GtkInteract.jl) provides Gtk support for Interact, letting you use tools like `Winston` for plotting.

## Example notebooks

The best way to learn to use the interactive widgets is to try out the example notebooks in the doc/notebooks/ directory. Start up IJulia from doc/notebooks/:

```{.shell execute="false"}
ipython notebook --profile julia
```
Interact needs IJulia to be running on Jupyter/IPython 3.x or Jupyter 4.x.
For Jupyter 4.x, the Python packages `jupyter` and `ipywidgets` must be installed.

If you installed `ipywidgets` with a non-conda installer, you will need to enable the extension using the following command:
```
jupyter nbextension enable --py widgetsnbextension
```
