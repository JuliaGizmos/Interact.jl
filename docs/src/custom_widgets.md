# Custom widgets

Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches, the full featured `Widget` type and the simple to use but more basic [`@manipulate`](@ref) macro.

## The Widget type

The `Widget` type can be used to create custom widgets. The types is parametric, with the parameter being the name of the widget and it takes as argument a `OrderedDict` of children.

For example:

```julia
d = OrderedDict(:label => "My label", :button => button("My button"))
w = Widget{:mywidget}(d)
```

Children can be accessed and modified using `getindex` and `setindex!` on the `Widget` object:

```julia
println(w[:label])
w[:label] = "A new label"
```

Optionally, the `Widget` can have some output, which should be an `Observable`:

```julia
d = OrderedDict(:label => "My label", :button => button("My button"))
output = map(t -> t > 5 ? "You pressed me many times" : "You didn't press me enough", d[:button])
w = Interact.Widget{:mywidget}(d, output = output)
```

Finally the [`@layout!`](@ref) macro allows us to set the layout of the widget:

```julia
@layout! w hbox(vbox(:label, :button), observe(_)) # observe(_) refers to the output of the widget
```

```@docs
@layout!
Interact.@layout
```

## Auxiliary functions

Some auxiliary functions are provided to make working with `Observables` easier in the recipe process:

```@docs
Interact.@map
Interact.@map!
Interact.@on
```

## Defining custom widgets without depending on Interact

```@docs
Widgets.@nodeps
```

## A simpler approach: the manipulate macro

```@docs
@manipulate
```
