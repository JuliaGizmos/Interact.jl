# Interact

## Getting Started

To install Interact, run the following in the Julia REPL:
```{.julia execute="false"}
Pkg.clone("git://github.com/shashi/Interact.jl.git")
```

You will also need [`IJuliaWidgets.jl`](https://github.com/shashi/IJuliaWidgets.jl) for Interact to function inside IJulia Notebooks:
```{.julia execute="false"}
Pkg.clone("git://github.com/shashi/IJuliaWidgets.jl.git")
```
This of course assumes that you have a fairly recent [`IJulia`](https://github.com/JuliaLang/IJulia.jl) set up.

To start using, import both React and Interact into your IJulia notebook.
```{.julia execute="true"}
using React, Interact
```

## Example notebooks

The best way to learn to use the interactive widgets is to try out the example notebooks in the doc/notebooks/ directory. Start up IJulia from doc/notebooks/:

```{.shell execute="false"}
ipython notebook --profile julia
```

A full API documentation is in the works.

Interact has been tested with IPython 2.1.0+
