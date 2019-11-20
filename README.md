# Interact

[![Build Status](https://travis-ci.org/JuliaGizmos/Interact.jl.svg?branch=master)](https://travis-ci.org/JuliaGizmos/Interact.jl)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaGizmos.github.io/Interact.jl/latest)

Web-based widgets that talk to Julia. Use them for quick interactive explorations, to publish science, or to create complex reusable widgets using existing ones!

## Getting started

Interact's output can be displayed either within Jupyter/Jupyterlab notebooks, the Atom text editor, or as a stand-alone web page. Below are the set up instructions for each of these front ends:


### IJulia + Jupyter notebooks
To set up Interact to work in Jupyter notebooks, first install Interact, IJulia and WebIO packages. Then install the required Jupyter extension by running:

```julia
using WebIO
WebIO.install_jupyter_nbextension()
```
**Important:** If you performed this step while the Jupyter notebook server is running, you will need to restart it for the extension to take effect.

The `WebIO.install_jupyter_nbextension([jupyter])` function takes the path to the `jupyter` binary as an optional argument. If omitted, the installation first tries to find `jupyter` in your OS's default path. If it does not exist there, it tries to find a version that was installed using Conda.jl (which is the default when IJulia is installed without having an existing Jupyter set up, or by forcing it to install a copy via Conda.) If you have a `jupyter` binary in your OS path but also have a version installed via Conda and want to use the one installed via Conda, then you can set this keyword argument to be `WebIO.find_jupyter_cmd(force_conda_jupyter=true)`. For more information about the Jupyter integration, see [WebIO's documentation](https://juliagizmos.github.io/WebIO.jl/latest/providers/ijulia/). There is [more troubleshooting information here](https://juliagizmos.github.io/WebIO.jl/latest/troubleshooting/not-detected/).

### IJulia + JupyterLab

To set up Interact to work in JupyterLab, first install Interact, IJulia and WebIO packages. Then install the required JupyterLab extension by running:

```julia
using WebIO
WebIO.install_jupyter_labextension()
```
**Important:** If you performed this step while the JupyterLab server is running, you will need to restart it for the extension to take effect.

This function also takes the `jupyter` path as an optional argument. See the above subsection on installing on Jupyter notebooks for more description of the default behavior when this argument is omitted and pointers to troubleshooting information.

### Within the Atom text editor

If you have set up the Julia integration provided by [Juno](https://junolab.org/), evaluating any expression which returns an Interact-renderable object (such as a widget or the output of `@manipulate`) will show up in a plot-pane within the editor. No extra setup steps are required.

### As a standalone web page

Any Julia function that returns an Interact-renderable object (such as a widget or the output of an `@manipulate`) can be repurposed to run as a simple web page served by the Mux web app framework.
```julia
using Mux, WebIO
function app(req) # req is a Mux request dictionary
 ...
end
webio_serve(app, port=8000)
```
# Usage
## @manipulate

The simplest way to use Interact is via the `@manipulate` macro.

```julia
@manipulate for i=1:10, f=[sin, cos]
	f(i)
end
```

[<img src="https://user-images.githubusercontent.com/6333339/41034492-a797bb62-6981-11e8-9c36-d7cb1f4a6f81.png" width="489">](https://vimeo.com/273565899)
## Example notebooks

The best way to learn to use the interactive widgets is to try out the example notebooks and the tutorial in the doc/notebooks/ directory. Start up IJulia from doc/notebooks/:

```julia
using IJulia
notebook()
```

## Explore the wider widget ecosystem

- `CSSUtil`: wraps CSS functionality in easy Julia functions. Also renders
  markdown (and LaTeX).
- `TableView`: show a spreadsheet view of any Table datatype
- `CodeMirror`: syntax highlighting and code editing within Interact
- _Your cool package_. Let us know by opening an issue to add your
  WebIO/Interact-based package here!

## Learning more

To learn more, check out the [documentation](https://JuliaGizmos.github.io/Interact.jl/latest/) and the list of [all available widgets](https://juliagizmos.github.io/Interact.jl/latest/widgets/).
