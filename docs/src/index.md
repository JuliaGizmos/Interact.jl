# Interact

Interact uses web technologies to let you create straightforward graphical user interfaces (GUIs) for your Julia code. These GUIs can be used in jupyter notebooks, in the Juno IDE plot pane, in an Electron window, or in the browser.

To understand how to use it, go through the [Tutorial](@ref), which is also available [here](https://github.com/JuliaGizmos/Interact.jl/blob/master/doc/notebooks/tutorial.ipynb) as a Jupyter notebook.

[InteractBase](https://github.com/piever/InteractBase.jl), [Knockout](https://github.com/JuliaGizmos/Knockout.jl), and [WebIO](https://github.com/JuliaGizmos/WebIO.jl) provide the widgets and allow for communication between Julia and Javascript.

## Overview

Creating an app in Interact requires three ingredients:

- [Observables](@ref): references that listen to changes in other references
- [Widgets](@ref): interactive graphical elements
- [Layout](@ref): tools for combining various widgets in a display

The [Tutorial](@ref) provides a quick overview of how these tools work together.

## CSS framework

Interact widgets are styled with the [Bulma](https://bulma.io/) CSS framework by default (the previously-supported [UIkit](https://getuikit.com/) backend is now deprecated). Because Bulma is a pure CSS framework (no extra Javascript), Julia is fully in control of manipulating the DOM, which leaves less surface area for bugs.

To switch between unstyled and Bulma-styled widgets in the middle of a session, use the following:

```julia
settheme!(:nativehtml)
settheme!(:bulma)
```

## Deployment

InteractBase works with the following frontends:

- [Juno](http://junolab.org) - The hottest Julia IDE
- [IJulia](https://github.com/JuliaLang/IJulia.jl) - Jupyter notebooks (and Jupyter Lab) for Julia
- [Blink](https://github.com/JunoLab/Blink.jl) - An [Electron](http://electron.atom.io/) wrapper you can use to make Desktop apps
- [Mux](https://github.com/JuliaWeb/Mux.jl) - A web server framework


See [Deploying the web app](@ref) for instructions.
