import Base: convert, haskey, setindex!, getindex
export slider, togglebutton, button,
       checkbox, textbox, textarea,
       radiobuttons, dropdown, selectone, selectmulti,
       togglebuttons, html, latex,
       progress, widget, selection_slider, fileuploader

const Empty = VERSION < v"0.4.0-dev" ? Nothing : Void

"""Helps init widget's value and signal depending on which ones were set"""
function init_wsigval(signal, value; default=value, typ=typeof(default))
    if signal == nothing
        if value == nothing
            value = default
        end
        signal = Signal(typ, value)
    else
        #signal set
        if value == nothing
            value = signal.value
        else
            #signal set and value set
            push!(signal, value)
        end
    end
    signal, value
end
### Input widgets

########################## Slider ############################

type Slider{T<:Number} <: InputWidget{T}
    signal::Signal{T}
    label::AbstractString
    value::T
    range::Range{T}
    orientation::String
    readout::Bool
    readout_format::AbstractString
    continuous_update::Bool
end

# differs from median(r) in that it always returns an element of the range
medianelement(r::Range) = r[(1+length(r))>>1]

slider(args...) = Slider(args...)
"""
    slider(range; value, signal, label="", readout=true, continuous_update=true)

Create a slider widget with the specified `range`. Optionally specify
the starting `value` (defaults to the median of `range`), provide the
(Reactive.jl) `signal` coupled to this slider, and/or specify a string
`label` for the widget.
"""
slider{T}(range::Range{T};
          value=nothing,
          signal=nothing,
          label="",
          orientation="horizontal",
          readout=true,
          readout_format=T <: Integer ? "d" : ".3f",
          continuous_update=true,
          syncsig=true) = begin
    signal, value = init_wsigval(signal, value; typ=T, default=medianelement(range))
    s = Slider(signal, label, value, range, orientation,
                readout, readout_format, continuous_update)
    if syncsig
        #keep the slider updated if the signal changes
        keep_updated(new_value) = begin
            if new_value != s.value
                s.value = new_value
                update_view(s)
            end
            nothing
        end
        preserve(map(keep_updated, signal; typ=Void))
    end
    s
end

######################### Checkbox ###########################

type Checkbox <: InputWidget{Bool}
    signal::Signal{Bool}
    label::AbstractString
    value::Bool
end

checkbox(args...) = Checkbox(args...)

"""
    checkbox(value=false; label="", signal)

Provide a checkbox with the specified starting (boolean)
`value`. Optional provide a `label` for this widget and/or the
(Reactive.jl) `signal` coupled to this widget.
"""
checkbox(value::Bool; signal=nothing, label="") = begin
    signal, value = init_wsigval(signal, value)
    Checkbox(signal, label, value)
end
checkbox(; label="", value=nothing, signal=nothing) = begin
    signal, value = init_wsigval(signal, value; default=false)
    Checkbox(signal, label, value)
end
###################### ToggleButton ########################

type ToggleButton <: InputWidget{Bool}
    signal::Signal{Bool}
    label::AbstractString
    value::Bool
end

togglebutton(args...) = ToggleButton(args...)

togglebutton(; label="", value=nothing, signal=nothing) = begin
    signal, value = init_wsigval(signal, value; default=false)
    ToggleButton(signal, label, value)
end

"""
    togglebutton(label=""; value=false, signal)

Create a toggle button. Optionally specify the `label`, the initial
state (`value=false` is off, `value=true` is on), and/or provide the
(Reactive.jl) `signal` coupled to this button.
"""
togglebutton(label; kwargs...) =
    togglebutton(label=label; kwargs...)

######################### Button ###########################

type Button{T} <: InputWidget{T}
    signal::Signal{T}
    label::AbstractString
    value::T
end

button(; value=nothing, label="", signal=Signal(value)) =
    Button(signal, label, value)

"""
    button(label; value=nothing, signal)

Create a push button. Optionally specify the `label`, the `value`
emitted when then button is clicked, and/or the (Reactive.jl) `signal`
coupled to this button.
"""
button(label; kwargs...) =
    button(label=label; kwargs...)

######################## Textbox ###########################

type Textbox{T} <: InputWidget{T}
    signal::Signal{T}
    label::String
    @compat range::Union{Empty, Range}
    value::T
end

function empty(t::Type)
    if is(t, Number) zero(t)
    elseif is(t, AbstractString) ""
    end
end

function Textbox(; label="",
                 value=nothing,
                 # Allow unicode characters even if initiated with ASCII
                 typ=String,
                 range=nothing,
                 signal=nothing,
                 syncsig=true)
    if isa(value, AbstractString) && range != nothing
        throw(ArgumentError(
               "You cannot set a range on a string textbox"
             ))
    end
    signal, value = init_wsigval(signal, value; typ=typ, default="")
    t = Textbox{typ}(signal, label, range, value)
    if syncsig
        #keep the slider updated if the signal changes
        keep_updated(new_value) = begin
            if string(new_value) != t.value
                t.value = string(new_value)
                update_view(t)
            end
            nothing
        end
        preserve(map(keep_updated, signal; typ=Void))
    end
    t

end

textbox(;kwargs...) = Textbox(;kwargs...)

"""
    textbox(value=""; label="", typ=typeof(value), range=nothing, signal)

Create a box for entering text. `value` is the starting value; if you
don't want to provide an initial value, you can constrain the type
with `typ`. Optionally provide a `label`, specify the allowed range
(e.g., `-10.0:10.0`) for numeric entries, and/or provide the
(Reactive.jl) `signal` coupled to this text box.
"""
textbox(val; kwargs...) =
    Textbox(value=val; kwargs...)
textbox(val::String; kwargs...) =
    Textbox(value=val; kwargs...)

parse_msg{T<:Number}(w::Textbox{T}, val::AbstractString) = parse_msg(w, parse(T, val))
function parse_msg{T<:Number}(w::Textbox{T}, val::Number)
    v = convert(T, val)
    if isa(w.range, Range)
        # force value to stay in range
        v = max(first(w.range),
                min(last(w.range), v))
    end
    v
end

######################### Textarea ###########################

type Textarea{AbstractString} <: InputWidget{AbstractString}
    signal::Signal{AbstractString}
    label::AbstractString
    value::AbstractString
end

textarea(args...) = Textarea(args...)

textarea(; label="",
         value=nothing,
         signal=nothing) = begin
    signal, value = init_wsigval(signal, value; default="")
    Textarea(signal, label, value)
end

"""
    textarea(value=""; label="", signal)

Creates an extended text-entry area. Optionally provide a `label`
and/or the (Reactive.jl) `signal` associated with this widget. The
`signal` updates when you type.
"""
textarea(val; kwargs...) =
    textarea(value=val; kwargs...)

##################### SelectionWidgets ######################

immutable OptionDict
    dict::OrderedDict
    invdict::Dict
end

Base.getindex(x::OptionDict, y) = getindex(x.dict, y)
Base.haskey(x::OptionDict, y) = haskey(x.dict, y)
Base.keys(x::OptionDict) = keys(x.dict)
Base.values(x::OptionDict) = values(x.dict)
function Base.setindex!(x::OptionDict, v, k)
    x.dict[k] = v
    x.invdict[v] = k
    v
end

type Options{view, T} <: InputWidget{T}
    signal::Signal
    label::AbstractString
    value::T
    value_label::AbstractString
    options::OptionDict
    icons::AbstractArray
    tooltips::AbstractArray
    readout::Bool
    orientation::AbstractString
end

Options(view::Symbol, options::OptionDict;
        label = "",
        value_label=first(keys(options)),
        value=nothing,
        icons=[],
        tooltips=[],
        typ=valtype(options.dict),
        signal=nothing,
        readout=true,
        orientation="horizontal",
        syncsig=true) = begin
    signal, value = init_wsigval(signal, value; typ=typ, default=options[value_label])
    typ = typeof(value)
    ow = Options{view, typ}(signal, label, value, value_label,
                    options, icons, tooltips, readout, orientation)
    if syncsig
        if view != :SelectMultiple
            #set up map that keeps the value_label in sync with the value
            #TODO handle SelectMultiple. Need something similar to handle_msg
            keep_label_updated(new_value) = begin
                if haskey(ow.options.invdict, new_value) &&
                  ow.value_label != ow.options.invdict[new_value]
                    ow.value_label = ow.options.invdict[new_value]
                    update_view(ow)
                end
                nothing
            end
            preserve(map(keep_label_updated, signal; typ=Void))
        end
        push!(signal, value)
    end
    ow
end

addoption(opts, v::NTuple{2}) = opts[string(v[1])] = v[2]
addoption(opts, v) = opts[string(v)] = v
function Options(view::Symbol,
                    options::AbstractArray;
                    kwargs...)
    opts = OptionDict(OrderedDict(), Dict())
    for v in options
        addoption(opts, v)
    end
    Options(view, opts; kwargs...)
end

function Options(view::Symbol,
                    options::Associative;
                    kwargs...)
    opts = OptionDict(OrderedDict(), Dict())
    for (k, v) in options
        opts[string(k)] = v
    end
    Options(view, opts; kwargs...)
end

"""
    dropdown(choices; label="", value, typ, icons, tooltips, signal)

Create a "dropdown" widget. `choices` can be a vector of
options. Optionally specify the starting `value` (defaults to the
first choice), the `typ` of elements in `choices`, supply custom
`icons`, provide `tooltips`, and/or specify the (Reactive.jl) `signal`
coupled to this widget.

# Examples

    a = dropdown(["one", "two", "three"])

To link a callback to the dropdown, use

    f = dropdown(["turn red"=>colorize_red, "turn green"=>colorize_green])
    map(g->g(image), signal(f))
"""
dropdown(opts; kwargs...) =
    Options(:Dropdown, opts; kwargs...)

"""
radiobuttons: see the help for `dropdown`
"""
radiobuttons(opts; kwargs...) =
    Options(:RadioButtons, opts; kwargs...)

"""
selectone: see the help for `dropdown`
"""
selectone(opts; kwargs...) =
    Options(:Select, opts; kwargs...)

"""
selectmulti: see the help for `dropdown`
"""
selectmulti(opts; signal=Signal(collect(opts)[1:1]), kwargs...) = begin
    Options(:SelectMultiple, opts; signal=signal, kwargs...)
end

"""
togglebuttons: see the help for `dropdown`
"""
togglebuttons(opts; kwargs...) =
    Options(:ToggleButtons, opts; kwargs...)

"""
selection_slider: see the help for `dropdown`
"""
selection_slider(opts; kwargs...) =
    Options(:SelectionSlider, opts; kwargs...)


type FileUploadWidget <: InputWidget
    label::String
end
fileuploader(label::String) = FileUploadWidget(label)


### Output Widgets

export Latex, Progress

Base.@deprecate html(value; label="")  HTML(value)

type Latex <: Widget
    label::AbstractString
    value::AbstractString
end
latex(label, value::AbstractString) = Latex(label, value)
latex(value::AbstractString; label="") = Latex(label, value)
latex(value; label="") = Latex(label, mimewritable("application/x-latex", value) ? stringmime("application/x-latex", value) : stringmime("text/latex", value))

## # assume we already have Latex
## writemime(io::IO, m::MIME{symbol("application/x-latex")}, l::Latex) =
##     write(io, l.value)

type Progress <: Widget
    label::AbstractString
    value::Int
    range::Range
    orientation::String
    readout::Bool
    readout_format::String
    continuous_update::Bool
end

progress(args...) = Progress(args...)
progress(;label="", value=0, range=0:100, orientation="horizontal",
            readout=true, readout_format="d", continuous_update=true) =
    Progress(label, value, range, orientation, readout, readout_format, continuous_update)

# Make a widget out of a domain
widget(x::Signal, label="") = x
widget(x::Widget, label="") = x
widget(x::Range, label="") = slider(x, label=label)
widget(x::AbstractVector, label="") = togglebuttons(x, label=label)
widget(x::Associative, label="") = togglebuttons(x, label=label)
widget(x::Bool, label="") = checkbox(x, label=label)
widget(x::AbstractString, label="") = textbox(x, label=label, typ=AbstractString)
widget{T <: Number}(x::T, label="") = textbox(typ=T, value=x, label=label)
