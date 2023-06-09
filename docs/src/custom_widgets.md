# Custom widgets

Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches: the full-featured `Widget` type, and the simpler but more basic [`@manipulate`](@ref) macro.

## The Widget type

The `Widget` type can be used to create custom widgets. This type is parametric, with the parameter being the name of the widget, and it takes as argument a `OrderedDict` of children.

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
w = Interact.Widget{:mywidget}(d, output=output)
```

Finally, the [`@layout!`](@ref) macro allows us to set the widget layout:

```julia
@layout! w hbox(vbox(:label, :button), observe(_)) # observe(_) refers to the output of the widget
```

```@docs
@layout!
Interact.@layout
```

## Defining custom widgets without depending on Interact

This is only relevant for package authors; it is not necessary to depend on Interact to define custom widgets. One can instead use the low-dependency package [Widgets](https://github.com/piever/Widgets.jl) that defines (but does not export) all standard widgets. For example:

```julia
# in the package MyPackage defining the recipe:
using Widgets
function myrecipe(i)
    label = "My recipe"
    wdg = Widgets.dropdown(i)
    Widget(["label" => label, "dropdown" => wdg])
end

# The user would then do:
using MyPackage, Interact

myrecipe(["a", "b", "c"])
```

## A simpler approach: the manipulate macro

```@docs
@manipulate
```
