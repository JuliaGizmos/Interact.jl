# Interact

[![Build Status](https://travis-ci.org/JuliaGizmos/Interact.jl.svg?branch=master)](https://travis-ci.org/JuliaGizmos/Interact.jl)

Interact.jl allows you to use interactive widgets such as sliders, dropdowns and checkboxes to play with your Julia code:

[<img src="https://user-images.githubusercontent.com/6333339/41034492-a797bb62-6981-11e8-9c36-d7cb1f4a6f81.png" width="489">](https://vimeo.com/273565899)

## Getting Started

To install Interact, run the following command in the Julia REPL:
```{.julia execute="false"}
Pkg.add("Interact")
```

## Example notebooks

The best way to learn to use the interactive widgets is to try out the example notebooks in the doc/notebooks/ directory. Start up IJulia from doc/notebooks/:

```julia
using IJulia
notebook()
```

## Learning more

[Documentation](https://piever.github.io/InteractBase.jl/latest/), a [tutorial](https://github.com/piever/InteractBase.jl/blob/master/docs/examples/tutorial.ipynb) and a list of [all available widgets](https://piever.github.io/InteractBase.jl/latest/api_reference.html) are available for the InteractBase package, on which Interact is based. Simply replace `using InteractBase, InteractBulma` with `using Interact`.
