# Interact

Interact allows to create small GUIs in Julia based on web technology. These GUIs can be deployed in jupyter notebooks, in the Juno IDE plot pane, in an Electron window or in the browser.

To understand how to use it go through the [Tutorial](@ref). The tutorial is also available [here](https://github.com/JuliaGizmos/Interact.jl/blob/master/doc/notebooks/tutorial.ipynb) as a Jupyter notebook.

[InteractBase](https://github.com/piever/InteractBase.jl), [Knockout](https://github.com/JuliaGizmos/Knockout.jl) and [WebIO](https://github.com/JuliaGizmos/WebIO.jl) provide the logic that allows the communication between Julia and Javascript and the organization of the widgets.

## Overview

Creating an app in Interact requires three ingredients:

- [Observables](@ref): references that can listen to changes in other references
- [Widgets](@ref): the graphical elements that make up the app
- [Layout](@ref): tools to assemble together different widgets

To get a quick overview of how these tools work together, go to [Tutorial](@ref).

## CSS framework

Interact widgets are by default styled with the [Bulma](https://bulma.io/) CSS framework (the previously supported [UIkit](https://getuikit.com/) backend is now deprecated). Bulma is a pure CSS framework (no extra Javascript), which leaves Julia fully in control of manipulating the DOM (which in turn means less surface area for bugs).

To use unstyled widgets in the middle of the session (or to style them again) simply do:

```julia
settheme!(:nativehtml)
settheme!(:bulma)
```

respectively.

## Deployment

InteractBase works with the following frontends:

- [Juno](http://junolab.org) - The hottest Julia IDE
- [IJulia](https://github.com/JuliaLang/IJulia.jl) - Jupyter notebooks (and Jupyter Lab) for Julia
- [Blink](https://github.com/JunoLab/Blink.jl) - An [Electron](http://electron.atom.io/) wrapper you can use to make Desktop apps
- [Mux](https://github.com/JuliaWeb/Mux.jl) - A web server framework


See [Deploying the web app](@ref) for instructions.
