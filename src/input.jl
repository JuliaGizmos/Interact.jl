_basename(v::AbstractArray) = basename.(v)
_basename(::Nothing) = nothing
_basename(v) = basename(v)

"""
`filepicker(label="Choose a file..."; multiple=false, accept="*")`

Create a widget to select files.
If `multiple=true` the observable will hold an array containing the paths of all
selected files. Use `accept` to only accept some formats, e.g. `accept=".csv"`
"""
function filepicker(::WidgetTheme, lbl="Choose a file..."; attributes=PropDict(),
    label=lbl, className="", multiple=false, value=multiple ? String[] : "",  kwargs...)

    (value isa AbstractObservable) || (value = Observable{Any}(value))
    filename = Observable{Any}(_basename(value[]))

    if multiple
        onFileUpload = js"""function (data, e){
            var files = e.target.files;
            var fileArray = Array.from(files);
            this.filename(fileArray.map(function (el) {return el.name;}));
            return this.path(fileArray.map(function (el) {return el.path;}));
        }
        """
    else
        onFileUpload = js"""function(data, e) {
            var files = e.target.files;
            this.filename(files[0].name);
            return this.path(files[0].path);
        }
        """
    end
    multiple && (attributes=merge(attributes, PropDict(:multiple => true)))
    attributes = merge(attributes, PropDict(:type => "file", :style => "display: none;",
        Symbol("data-bind") => "event: {change: onFileUpload}"))
    className = mergeclasses(getclass(:input, "file"), className)
    template = dom"div[style=display:flex; align-items:center;]"(
        node(:label, className=getclass(:input, "file", "label"))(
            node(:input; className=className, attributes=attributes, kwargs...),
            node(:span,
                node(:span, (node(:i, className = getclass(:input, "file", "icon"))), className=getclass(:input, "file", "span", "icon")),
                node(:span, label, className=getclass(:input, "file", "span", "label")),
                className=getclass(:input, "file", "span"))
        ),
        node(:span, attributes = Dict("data-bind" => " text: filename() == '' ? 'No file chosen' : filename()"),
            className = getclass(:input, "file", "name"))
    )

    observs = ["path" => value, "filename" => filename]
    ui = knockout(template, observs, methods = ["onFileUpload" => onFileUpload])
    slap_design!(ui)
    Widget{:filepicker}(observs, scope = ui, output = ui["path"], layout = node(:div, className = "field interact-widget")∘Widgets.scope)
end

"""
`opendialog(; value = String[], label = "Open", icon = "far fa-folder-open", options...)`

Creates an [Electron openDialog](https://electronjs.org/docs/api/dialog#dialogshowopendialogbrowserwindow-options-callback).
`value` is the list of selected files or folders. `options` (given as keyword arguments) correspond to
`options` of the Electron dialog. This widget will not work in the browser but only in an Electron window.

## Examples

```jldoctest
julia> ui = Interact.opendialog(; properties = ["showHiddenFiles", "multiSelections"], filters = [(; name = "Text", extensions = ["txt", "md"])]);

julia> ui[]
0-element Array{String,1}
```
"""
opendialog(::WidgetTheme; value = String[], label = "Open", icon = "far fa-folder-open", kwargs...) =
    dialog(js"showOpenDialog"; value = value, label = label, icon = icon, kwargs...)

"""
`savedialog(; value = String[], label = "Open", icon = "far fa-folder-open", options...)`

Create an [Electron saveDialog](https://electronjs.org/docs/api/dialog#dialogshowsavedialogbrowserwindow-options-callback).
`value` is the list of selected files or folders. `options` (given as keyword arguments) correspond to
`options` of the Electron dialog. This widget will not work in the browser but only in an Electron window.

## Examples

```jldoctest
julia> ui = Interact.savedialog(; properties = ["showHiddenFiles"], filters = [(; name = "Text", extensions = ["txt", "md"])]);

julia> ui[]
""
```
"""
savedialog(::WidgetTheme; value = "", label = "Save", icon = "far fa-save", kwargs...) =
    dialog(js"showSaveDialog"; value = value, label = label, icon = icon, kwargs...)

function dialog(dialogtype; value, className = "", label = "dialog", icon = nothing, options...)
    (value isa AbstractObservable) || (value = Observable(value))
    scp = Scope()
    setobservable!(scp, "output", value)
    clicks = Observable(scp, "clicks", 0)
    callback = @js function (val)
        $value[] = val
    end
    onimport(scp, js"""
    function () {
        const { dialog } = require('electron').remote;
        this.dialog = dialog;
    }
    """)
    onjs(clicks, js"""
    function (val) {
        console.log(this.dialog.$dialogtype($options, $callback));
    }
    """)
    className = mergeclasses(getclass(:button), className)
    content = if icon === nothing
        (label,)
    else
        iconNode = node(:span, node(:i, className = icon), className = "icon")
        (iconNode, node(:span, label))
    end
    btn = node(:button, content...,
        events=Dict("click" => @js event -> ($clicks[] = $clicks[] + 1)),
        className = className)
    scp.dom = btn
    slap_design!(scp)
    Widget{:dialog}([]; output = value, scope = scp, layout = Widgets.scope)
end

_parse(::Type{S}, x) where{S} = parse(S, x)
function _parse(::Type{Dates.Time}, x)
    segments = split(x, ':')
    length(segments) >= 2 && all(!isempty, segments) || return nothing
    h, m = parse.(Int, segments)
    Dates.Time(h, m)
end

function _string(x::Dates.Time)
    h = Dates.hour(x)
    m = Dates.minute(x)
    string(lpad(h, 2, "0"), ":", lpad(m, 2, "0"))
end
_string(x::Dates.Date) = string(x)

"""
`datepicker(value::Union{Dates.Date, Observable, Nothing}=nothing)`

Create a widget to select dates.
"""
function datepicker end

"""
`timepicker(value::Union{Dates.Time, Observable, Nothing}=nothing)`

Create a widget to select times.
"""
function timepicker end

for (func, typ, str, unit) in [(:timepicker, :(Dates.Time), "time", Dates.Second), (:datepicker, :(Dates.Date), "date", Dates.Day) ]
    @eval begin
        function $func(::WidgetTheme, val=nothing; value=val, kwargs...)
            (value isa AbstractObservable) || (value = Observable{Union{$typ, Nothing}}(value))
            f = x -> x === nothing ? "" : _string(x)
            g = t -> _parse($typ, t)
            pair = ObservablePair(value, f=f, g=g)
            ui = input(pair.second; typ=$str, kwargs...)
            Widget{$(Expr(:quote, func))}(ui, output = value)
        end

        function $func(T::WidgetTheme, vals::AbstractRange, val=medianelement(vals); value=val, kwargs...)
            f = x -> x === nothing ? "" : _string(x)
            fs = x -> x === nothing ? "" : split(string(convert($unit, x)), ' ')[1]
            min, max = extrema(vals)
            $func(T; value=value, min=f(min), max=f(max), step=fs(step(vals)), kwargs...)
        end
    end
end

"""
`colorpicker(value::Union{Color, Observable}=colorant"#000000")`

Create a widget to select colors.
"""
function colorpicker(::WidgetTheme, val=colorant"#000000"; value=val, kwargs...)
    (value isa AbstractObservable) || (value = Observable{Color}(value))
    f = t -> "#"*hex(t)
    g = t -> parse(Colorant,t)
    pair = ObservablePair(value, f=f, g=g)
    ui = input(pair.second; typ="color", kwargs...)
    Widget{:colorpicker}(ui, output = value)
end

"""
`spinbox([range,] label=""; value=nothing)`

Create a widget to select numbers with placeholder `label`. An optional `range` first argument
specifies maximum and minimum value accepted as well as the step. Use `step="any"` to allow all
decimal numbers.
"""
function spinbox(::WidgetTheme, label=""; value=nothing, placeholder=label, isinteger=nothing, kwargs...)
    isinteger === nothing || @warn "`isinteger` is deprecated"
    if !isa(value, AbstractObservable)
        T = something(isinteger, isa(value, Integer)) ? Int : Float64
        value = Observable{Union{T, Nothing}}(value)
    end
    ui = input(value; isnumeric=true, placeholder=placeholder, typ="number", kwargs...)
    Widget{:spinbox}(ui, output = value)
end

spinbox(T::WidgetTheme, vals::AbstractRange, args...; value=first(vals), kwargs...) =
    spinbox(T, args...; value=value, min=minimum(vals), max=maximum(vals), step=step(vals), kwargs...)

"""
`autocomplete(options, label=""; value="")`

Create a textbox input with autocomplete options specified by `options`, with `value`
as initial value and `label` as label.
"""
function autocomplete(::WidgetTheme, options, args...; attributes=PropDict(), kwargs...)
    (options isa AbstractObservable) || (options = Observable{Any}(options))
    option_array = _js_array(options)
    s = gensym()
    attributes = merge(attributes, PropDict(:list => s))
    t = textbox(args...; extra_obs=["options_js" => option_array], attributes=attributes, kwargs...)
    Widgets.scope(t).dom = node(:div,
        Widgets.scope(t).dom,
        node(:datalist, node(:option, attributes=Dict("data-bind"=>"value : key"));
            attributes = Dict("data-bind" => "foreach : options_js", "id" => s))
    )
    w = Widget{:autocomplete}(t)
    w[:options] = options
    w
end

"""
`input(o; typ="text")`

Create an HTML5 input element of type `type` (e.g. "text", "color", "number", "date") with `o`
as initial value.
"""
function input(::WidgetTheme, o; extra_js=js"", extra_obs=[], label=nothing, typ="text", wdgtyp=typ,
    className="", style=Dict(), isnumeric=Knockout.isnumeric(o),
    computed=[], attributes=Dict(), bind="value", bindto="value", valueUpdate="input", changes=0, kwargs...)

    (o isa AbstractObservable) || (o = Observable(o))
    (changes isa AbstractObservable) || (changes = Observable(changes))
    data = Pair{String, Any}["changes" => changes, bindto => o]
    if isnumeric && bind == "value"
        bind = "numericValue"
    end
    append!(data, (string(key) => val for (key, val) in extra_obs))
    countChanges = js_lambda("this.changes(this.changes()+1)")
    attrDict = merge(
        attributes,
        Dict(:type => typ,
            Symbol("data-bind") => "$bind: $bindto, valueUpdate: '$valueUpdate', event: {change: $countChanges}"
        )
    )
    className = mergeclasses(getclass(:input, wdgtyp), className)
    template = node(:input; className=className, attributes=attrDict, style=style, kwargs...)()
    ui = knockout(template, data, extra_js; computed=computed)
    (label != nothing) && (ui.dom = flex_row(wdglabel(label), ui.dom))
    slap_design!(ui)
    Widget{:input}(data, scope = ui, output = ui[bindto], layout = node(:div, className = "field interact-widget")∘Widgets.scope)
end

function input(::WidgetTheme; typ="text", kwargs...)
    if typ in ["checkbox", "radio"]
        o = false
    elseif typ in ["number", "range"]
        o = 0.0
    else
        o = ""
    end
    input(o; typ=typ, kwargs...)
end

"""
`button(content... = "Press me!"; value=0)`

A button. `content` goes inside the button.
Note the button `content` supports a special `clicks` variable, that gets incremented by `1`
with each click e.g.: `button("clicked {{clicks}} times")`.
The `clicks` variable is initialized at `value=0`. Given a button `b`, `b["is-loading"]` defines
whether the button is in a loading state (spinning wheel). Use `b["is-loading"][]=true` or
`b["is-loading"][]=false` respectively to display or take away the spinner.
"""
function button(::WidgetTheme, content...; label = "Press me!", value = 0, style = Dict{String, Any}(),
    className = getclass(:button, "primary"), attributes=Dict(), kwargs...)
    isempty(content) && (content = (label,))
    (value isa AbstractObservable) || (value = Observable(value))
    loading = Observable(false)
    className = "delete" in split(className, ' ') ? className : mergeclasses(getclass(:button), className)
    countClicks = js_lambda("this.clicks(this.clicks()+1)")
    attrdict = merge(
        Dict("data-bind"=>"click: $countClicks, css: {'is-loading' : loading}"),
        attributes
    )
    template = node(:button, content...; className=className, attributes=attrdict, style=style, kwargs...)
    button = knockout(template, ["clicks" => value, "loading" => loading])
    slap_design!(button)
    Widget{:button}(["is-loading" => loading], scope = button, output = value,
        layout = node(:div, className = "field interact-widget")∘Widgets.scope)
end

for wdg in [:toggle, :checkbox]
    @eval begin
        $wdg(::WidgetTheme, value, lbl::AbstractString=""; label=lbl, kwargs...) =
            $wdg(gettheme(); value=value, label=label, kwargs...)

        $wdg(::WidgetTheme, label::AbstractString, val=false; value=val, kwargs...) =
            $wdg(gettheme(); value=value, label=label, kwargs...)

        $wdg(::WidgetTheme, value::AbstractString, label::AbstractString; kwargs...) =
            error("value cannot be a string")

        function $wdg(::WidgetTheme; bind="checked", valueUpdate="change", value=false, label="", labelclass="", kwargs...)
            s = gensym() |> string
            (label isa Tuple) || (label = (label,))
            widgettype = $(Expr(:quote, wdg))
            wdgtyp = string(widgettype)
            labelclass = mergeclasses(getclass(:input, wdgtyp, "label"), labelclass)
            ui = input(value; bind=bind, typ="checkbox", valueUpdate="change", wdgtyp=wdgtyp, id=s, kwargs...)
            Widgets.scope(ui).dom = node(:div, className = "field interact-widget")(Widgets.scope(ui).dom, dom"label[className=$labelclass, for=$s]"(label...))
            Widget{widgettype}(ui)
        end
    end
end

"""
`checkbox(value::Union{Bool, AbstractObservable}=false; label)`

A checkbox.
e.g. `checkbox(label="be my friend?")`
"""
function checkbox end

"""
`toggle(value::Union{Bool, AbstractObservable}=false; label)`

A toggle switch.
e.g. `toggle(label="be my friend?")`
"""
function toggle end

"""
`textbox(hint=""; value="")`

Create a text input area with an optional placeholder `hint`
e.g. `textbox("enter number:")`. Use `typ=...` to specify the type of text. For example
`typ="email"` or `typ="password"`. Use `multiline=true` to display a `textarea` spanning
several lines.
"""
function textbox(::WidgetTheme, hint=""; multiline=false, placeholder=hint, value="", typ="text", kwargs...)
    multiline && return textarea(gettheme(); placeholder=placeholder, value=value, kwargs...)
    Widget{:textbox}(input(value; typ=typ, placeholder=placeholder, kwargs...))
end

"""
`textarea(hint=""; value="")`

Create a textarea with an optional placeholder `hint`
e.g. `textarea("enter number:")`. Use `rows=...` to specify how many rows to display
"""
function textarea(::WidgetTheme, hint=""; label=nothing, className="",
    placeholder=hint, value="", attributes=Dict(), style=Dict(), bind="value", valueUpdate = "input", kwargs...)

    (value isa AbstractObservable) || (value = Observable(value))
    attrdict = convert(PropDict, attributes)
    attrdict[:placeholder] = placeholder
    attrdict["data-bind"] = "$bind: value, valueUpdate: '$valueUpdate'"
    className = mergeclasses(getclass(:textarea), className)
    template = node(:textarea; className=className, attributes=attrdict, style=style, kwargs...)
    ui = knockout(template, ["value" => value])
    (label != nothing) && (ui.dom = flex_row(wdglabel(label), ui.dom))
    slap_design!(ui)
    Widget{:textarea}(scope = ui, output = ui["value"], layout = node(:div, className = "field interact-widget")∘Widgets.scope)
end

function wdglabel(T::WidgetTheme, text; padt=5, padr=10, padb=0, padl=10,
    className="", style = Dict(), kwargs...)

    className = mergeclasses(getclass(:wdglabel), className)
    padding = Dict(:padding=>"$(padt)px $(padr)px $(padb)px $(padl)px")
    node(:label, text; className=className, style = merge(padding, style), kwargs...)
end

function flex_row(a,b,c=dom"div"())
    node(
        :div,
        node(:div, a, className = "interact-flex-row-left"),
        node(:div, b, className = "interact-flex-row-center"),
        node(:div, c, className = "interact-flex-row-right"),
        className = "interact-flex-row interact-widget"
    )
end

flex_row(a) = node(:div, a, className = "interact-flex-row interact-widget")
