# Custom widgets

Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches, the full featured [`@widget`](@ref) macro and the simple to use but more basic [`@manipulate`](@ref) macro.

## The recipe macro

```@docs
@widget
```

### Auxiliary functions

```@docs
Widgets.@map
@output!
@display!
Widgets.@layout
@layout!
```

## A simpler approach: the manipulate macro

```@docs
@manipulate
```
