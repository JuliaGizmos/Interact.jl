import Base: convert, haskey, setindex!, getindex
export Slider, slider, ToggleButton, togglebutton, Button, button,
       Options, Checkbox, checkbox, Textbox, textbox, Textarea, textarea,
       RadioButtons, radiobuttons, Dropdown, dropdown, Select, select,
       ToggleButtons, togglebuttons, HTML, html, Latex, latex,
       Progress, progress, widget

### Input widgets

########################## Slider ############################

type Slider{T<:Number} <: InputWidget{T}
    signal::Input{T}
    label::String
    value::T
    range::Range{T}
end

# differs from median(r) in that it always returns an element of the range
medianelement(r::Range) = r[(1+length(r))>>1]

slider(args...) = Slider(args...)
slider{T}(range::Range{T};
          value=medianelement(range),
          signal::Signal{T}=Input(value),
          label="") =
              Slider(signal, label, value, range)

######################### Checkbox ###########################

type Checkbox <: InputWidget{Bool}
    signal::Input{Bool}
    label::String
    value::Bool
end

checkbox(args...) = Checkbox(args...)
checkbox(value::Bool; signal=Input(value), label="") =
    Checkbox(signal, label, value)
checkbox(; label="", value=false, signal=Input(value)) =
    Checkbox(signal, label, value)

###################### ToggleButton ########################

type ToggleButton <: InputWidget{Bool}
    signal::Input{Bool}
    label::String
    value::Bool
end

togglebutton(args...) = ToggleButton(args...)

togglebutton(; label="", value=false, signal=Input(value)) =
    ToggleButton(signal, label, value)

togglebutton(label; kwargs...) =
    togglebutton(label=label; kwargs...)

######################### Button ###########################

type Button{T} <: InputWidget{T}
    signal::Input{T}
    label::String
    value::T
end

button(; value=nothing, label="", signal=Input(value)) =
    Button(signal, label, value)

button(label; kwargs...) =
    button(label=label; kwargs...)

######################## Textbox ###########################

type Textbox{T} <: InputWidget{T}
    signal::Input{T}
    label::String
    range::Union(Nothing, Range)
    value::T
end

function empty(t::Type)
    if is(t, Number) zero(t)
    elseif is(t, String) ""
    end
end

function Textbox(; label="",
                 value=utf8(""),
                 # Allow unicode characters even if initiated with ASCII
                 typ=typeof(value),
                 range=nothing,
                 signal=Input{typ}(value))
    if isa(value, String) && !isa(range, Nothing)
        throw(ArgumentError(
               "You cannot set a range on a string textbox"
             ))
    end
    Textbox{typ}(signal, label, range, value)
end

textbox(;kwargs...) = Textbox(;kwargs...)
textbox(val; kwargs...) =
    Textbox(value=val; kwargs...)
textbox(val::String; kwargs...) =
    Textbox(value=utf8(val); kwargs...)

function parse{T<:Number}(val, w::Textbox{T})
    v = parse(T, val)
    if isa(w.range, Range)
        # force value to stay in range
        v = max(first(w.range),
                min(last(w.range), v))
    end
    v
end

######################### Textarea ###########################

type Textarea{String} <: InputWidget{String}
    signal::Input{String}
    label::String
    value::String
end

textarea(args...) = Textarea(args...)

textarea(; label="",
         value="",
         signal=Input(value)) =
    Textarea(signal, label, value)

textarea(val; kwargs...) =
    textarea(value=val; kwargs...)

##################### SelectionWidgets ######################

immutable OptionDict
    keys::Vector
    dict::Dict
end

Base.getindex(x::OptionDict, y) = getindex(x.dict, y)
Base.haskey(x::OptionDict, y) = haskey(x.dict, y)
Base.keys(x::OptionDict) = x.keys
function Base.setindex!(x::OptionDict, v, k)
    if !haskey(x.dict, k)
        push!(x.keys, k)
    end
    x.dict[k] = v
    v
end
type Options{view, T} <: InputWidget{T}
    signal::Signal
    label::String
    value::T
    value_label::String
    options::OptionDict
end

Options(view::Symbol, options::OptionDict;
        label = "",
        value_label=first(options.keys),
        value=options[value_label],
        typ=typeof(value),
        signal=Input(value)) =
            Options{view, typ}(signal, label, value, value_label, options)

addoption(opts, v::NTuple{2}) = opts[string(v[1])] = v[2]
addoption(opts, v) = opts[string(v)] = v
function Options(view::Symbol,
                    options::AbstractArray;
                    kwargs...)
    opts = OptionDict(Any[], Dict())
    for v in options
        addoption(opts, v)
    end
    Options(view, opts; kwargs...)
end

function Options(view::Symbol,
                    options::Associative;
                    kwargs...)
    opts = OptionDict(Any[], Dict())
    for (k, v) in options
        opts[string(k)] = v
    end
    Options(view, opts; kwargs...)
end

dropdown(opts; kwargs...) =
    Options(:Dropdown, opts; kwargs...)

radiobuttons(opts; kwargs...) =
    Options(:RadioButtons, opts; kwargs...)

select(opts; kwargs...) =
    Options(:Select, opts; kwargs...)

togglebuttons(opts; kwargs...) =
    Options(:ToggleButtons, opts; kwargs...)

### Output Widgets

export HTML, Latex, Progress


type HTML <: Widget
    label::String
    value::String
end
html(label, value) = HTML(label, value)
html(value; label="") = HTML(label, value)

# assume we already have HTML
## writemime(io::IO, m::MIME{symbol("text/html")}, h::HTML) =
##     write(io, h.value)

type Latex <: Widget
    label::String
    value::String
end
latex(label, value::String) = Latex(label, value)
latex(value::String; label="") = Latex(label, value)
latex(value; label="") = Latex(label, mimewritable("application/x-latex", value) ? stringmime("application/x-latex", value) : stringmime("text/latex", value))

## # assume we already have Latex
## writemime(io::IO, m::MIME{symbol("application/x-latex")}, l::Latex) =
##     write(io, l.value)

type Progress <: Widget
    label::String
    value::Int
    range::Range
end

progress(args...) = Progress(args...)
progress(;label="", value=0, range=0:100) =
    Progress(label, value, range)

# Make a widget out of a domain
widget(x::Signal, label="") = x
widget(x::Widget, label="") = x
widget(x::Range, label="") = slider(x, label=label)
widget(x::AbstractVector, label="") = togglebuttons(x, label=label)
widget(x::Associative, label="") = togglebuttons(x, label=label)
widget(x::Bool, label="") = checkbox(x, label=label)
widget(x::String, label="") = textbox(x, label=label, typ=String)
widget{T <: Number}(x::T, label="") = textbox(typ=T, value=x, label=label)
