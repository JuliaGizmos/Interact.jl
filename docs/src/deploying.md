# Deploying the web app

Interact works with the following frontends:

- [Juno](http://junolab.org) - The hottest Julia IDE
- [IJulia](https://github.com/JuliaLang/IJulia.jl) - Jupyter notebooks (and Jupyter Lab) for Julia
- [Blink](https://github.com/JunoLab/Blink.jl) - An [Electron](http://electron.atom.io/) wrapper you can use to make Desktop apps
- [Mux](https://github.com/JuliaWeb/Mux.jl) - A web server framework

## Jupyter notebook/lab and Juno

Simply use `display`:

```julia
using Interact
ui = button()
display(ui)
```

Note that using Interact in Jupyter Lab requires installing an extension first:

```julia
cd(Pkg.dir("WebIO", "assets"))
;jupyter labextension install webio
;jupyter labextension enable webio/jupyterlab_entry
```

## Electron window

To deploy the app as a standalone Electron window, one would use [Blink.jl](https://github.com/JunoLab/Blink.jl):

```julia
using Interact, Blink
w = Window()
body!(w, ui);
```

## Browser

The app can also be served in a webpage:

```julia
using Interact, Mux
WebIO.webio_serve(page("/", req -> ui), rand(8000:9000)) # serve on a random port
```
