# Widgets

## What is a widget?

A widget is just a graphical component we can generate from Julia that has an output.
The output of a widget is a [`Observable`](@ref), and can be accessed with `observe`.

A `Widget` itself behaves pretty much like a [`Observable`](@ref), and the techniques discussed in [Observables](@ref) apply. For example:

```@repl manual
using Interact
s = slider(1:100);
s[]
Interact.@on print(string("The value is ", &s))
s[] = 12;
```

## Text input

These are widgets to select text input entered by the user. For numbers, use [`spinbox`](@ref); for strings, use [`textbox`](@ref). String entries ([`textbox`](@ref) and [`autocomplete`](@ref)) are initialized as `""`, whereas [`spinbox`](@ref) defaults to `nothing`.

```@docs
spinbox
textbox
textarea
autocomplete
```

## Type input

These are widgets to select a specific, non-text input type. So far, `Date`, `Time`, `Color`, and `Bool` are supported. Types that allow a empty field (`Date` and `Time`) are initialized as `nothing` by default, whereas `Color` and `Bool` are initialized with the default HTML value (`colorant"black"` and `false` respectively).

```@docs
datepicker
timepicker
colorpicker
checkbox
toggle
```

## File input

```@docs
filepicker
opendialog
savedialog
```

## Range input

```@docs
slider
rangeslider
rangepicker
```

## Callback input

```@docs
button
```
## HTML5 input

All of the inputs above are implemented by wrapping the `input` tag of HTML5, which can be accessed more directly as follows:

```@docs
InteractBase.input
```

## Option input

```@docs
dropdown
radiobuttons
checkboxes
toggles
togglebuttons
tabs
```

## Output

```@docs
latex
alert
highlight
InteractBase.notifications
togglecontent
tabulator
mask
```

## Create widgets automatically from a Julia variable

```@docs
widget
```
