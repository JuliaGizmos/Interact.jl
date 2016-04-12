import Base: convert, haskey, setindex!, getindex
export slider, togglebutton, button,
       checkbox, textbox, textarea,
       radiobuttons, dropdown, select,
       togglebuttons, html, latex,
       progress, widget

const Empty = VERSION < v"0.4.0-dev" ? Nothing : Void

### Input widgets

########################## Slider ############################

type Slider{T<:Number} <: InputWidget{T}
    signal::Signal{T}
    label::AbstractString
    value::T
    range::Range{T}
    continuous_update::Bool
end

# differs from median(r) in that it always returns an element of the range
medianelement(r::Range) = r[(1+length(r))>>1]

slider(args...) = Slider(args...)
slider{T}(range::Range{T};
          value=medianelement(range),
          signal::Signal{T}=Signal(value),
          label="",
          continuous_update=true) =
              Slider(signal, label, value, range, continuous_update)

######################### Checkbox ###########################

type Checkbox <: InputWidget{Bool}
    signal::Signal{Bool}
    label::AbstractString
    value::Bool
end

checkbox(args...) = Checkbox(args...)
checkbox(value::Bool; signal=Signal(value), label="") =
    Checkbox(signal, label, value)
checkbox(; label="", value=false, signal=Signal(value)) =
    Checkbox(signal, label, value)

###################### ToggleButton ########################

type ToggleButton <: InputWidget{Bool}
    signal::Signal{Bool}
    label::AbstractString
    value::Bool
end

togglebutton(args...) = ToggleButton(args...)

togglebutton(; label="", value=false, signal=Signal(value)) =
    ToggleButton(signal, label, value)

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

button(label; kwargs...) =
    button(label=label; kwargs...)

######################## Textbox ###########################

type Textbox{T} <: InputWidget{T}
    signal::Signal{T}
    label::AbstractString
    @compat range::Union{Empty, Range}
    value::T
end

function empty(t::Type)
    if is(t, Number) zero(t)
    elseif is(t, AbstractString) ""
    end
end

function Textbox(; label="",
                 value=utf8(""),
                 # Allow unicode characters even if initiated with ASCII
                 typ=typeof(value),
                 range=nothing,
                 signal=Signal(typ, value))
    if isa(value, AbstractString) && range != nothing
        throw(ArgumentError(
               "You cannot set a range on a string textbox"
             ))
    end
    Textbox{typ}(signal, label, range, value)
end

textbox(;kwargs...) = Textbox(;kwargs...)
textbox(val; kwargs...) =
    Textbox(value=val; kwargs...)
textbox(val::AbstractString; kwargs...) =
    Textbox(value=utf8(val); kwargs...)

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
         value="",
         signal=Signal(value)) =
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
Base.values(x::OptionDict) = [x.dict[k] for k in keys(x)]
function Base.setindex!(x::OptionDict, v, k)
    if !haskey(x.dict, k)
        push!(x.keys, k)
    end
    x.dict[k] = v
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
end

Options(view::Symbol, options::OptionDict;
        label = "",
        value_label=first(options.keys),
        value=options[value_label],
        icons=[],
        tooltips=[],
        typ=typeof(value),
        signal=Signal(value)) =
            Options{view, typ}(signal, label, value, value_label, options, icons, tooltips)

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
widget(x::AbstractString, label="") = textbox(x, label=label, typ=AbstractString)
widget{T <: Number}(x::T, label="") = textbox(typ=T, value=x, label=label)
