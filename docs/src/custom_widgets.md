# Custom widgets

Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches, the full featured [`@widget`](@ref) macro and the simple to use but more basic [`@manipulate`](@ref) macro.

## The Widget type

The `Widget` type can be used to create custom widgets. The types is parametric, with the parameter being the name of the widget and it takes as argument a `OrderedDict` of children.

For example:

```julia
d = OrderedDict(:label => "My label", :button => button("My button"))
w = Interact.Widget{:mywidget}(d)
```

The [`@output!`](@ref) and [`@display!`](@ref) macros can be used to set the output of the widget and define how to display it.

```julia
@output! w $(:button) > 5 ? "You pressed me many times" : "You didn't press me enough"
@display! w dom"div"($(_.output), style = Dict("color" => "red"))
```

Finally the [`@layout!`](@ref) macro allows us to set the layout of the widget:

```julia
@layout! w hbox(vbox(:label, :button), _.display)
```

## The recipe macro

To simplify adding children to a custom widget (as well as to register it as a "widget recipe"), a `@widget` macro is provided.

See [Creating custom widgets](@ref) for examples.

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
Widgets.@nodeps
```

## A simpler approach: the manipulate macro

```@docs
@manipulate
```
