# Interact

[![Build Status](https://travis-ci.org/JuliaGizmos/Interact.jl.svg?branch=master)](https://travis-ci.org/JuliaGizmos/Interact.jl)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaGizmos.github.io/Interact.jl/latest)

Interact.jl allows you to use interactive widgets such as sliders, dropdowns and checkboxes to play with your Julia code:

[<img src="https://user-images.githubusercontent.com/6333339/41034492-a797bb62-6981-11e8-9c36-d7cb1f4a6f81.png" width="489">](https://vimeo.com/273565899)

## Getting Started

To install Interact, run the following command in the Julia REPL:
```{.julia execute="false"}
Pkg.add("Interact")
```

## Example notebooks

The best way to learn to use the interactive widgets is to try out the example notebooks and the tutorial in the doc/notebooks/ directory. Start up IJulia from doc/notebooks/:

```julia
using IJulia
notebook()
```

## Learning more

To learn more, check out the [documentation](https://JuliaGizmos.github.io/Interact.jl/latest/) and the list of [all available widgets](https://JuliaGizmos.github.io/Interact.jl/latest/api_reference.html).
