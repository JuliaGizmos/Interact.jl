# Widgets

## Text input

These are widgets to select text input that's typed in by the user. For numbers use [`spinbox`](@ref) and for strings use [`textbox`](@ref). String entries ([`textbox`](@ref) and [`autocomplete`](@ref)) are initialized as `""`, whereas [`spinbox`](@ref) defaults to `nothing`, which corresponds to the empty entry.

```@docs
spinbox
textbox
textarea
autocomplete
```

## Type input

These are widgets to select a specific, non-text, type of input. So far, `Date`, `Time`, `Color` and `Bool` are supported. Types that allow a empty field (`Date` and `Time`) are initialized as `nothing` by default, whereas `Color` and `Bool` are initialized with the default HTML value (`colorant"black"` and `false` respectively).

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
```

## Range input

```@docs
slider
```

## Callback input

```@docs
button
```
## HTML5 input

All of the inputs above are implemented wrapping the `input` tag of HTML5 which can be accessed more directly as follows:

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
tabulator
```

## Output

```@docs
latex
alert
highlight
InteractBase.notifications
togglecontent
```

## Create widgets automatically from a Julia variable

```@docs
widget
```
