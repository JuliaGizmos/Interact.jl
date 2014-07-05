
using DataStructures
import Base.convert

export Label, Slider, ToggleButton, Button,
       Checkbox, Textbox, Textarea, RadioButtons, Dropdown

# A type for values with labels (e.g. radio button options)
typealias Label{T} OrderedDict{String, T}

convert{T}(::Type{Label{T}}, x::T) = Label(x)

########################## Slider ############################

type Slider{T<:Number} <: InputWidget{T}
    input::Input{T}
    label::String
    value::T
    range::Range{T}
end

Slider{T}(range::Range{T};
          value=first(range),
          input=Input(value),
          label="") =
              Slider(input, label, value, range)

######################### Checkbox ###########################

type Checkbox <: InputWidget{Bool}
    input::Input{Bool}
    label::String
    value::Bool
end

Checkbox(; input=Input(false), label="", value=false) =
    Checkbox(input, label, value)

###################### ToggleButton ########################

type ToggleButton <: InputWidget{Bool}
    input::Input{Bool}
    label::String
    value::Bool
end

ToggleButton(; input=Input(false), label="", value=false) =
    ToggleButton(input, label, value)

ToggleButton(label; kwargs...) =
    ToggleButton(label=label; kwargs...)

######################## Selection ##########################

type Selection <: InputWidget{Symbol}
    input::Input{Symbol}
    label::String
    value::Symbol
    options::(Label{Symbol}...)
end

Selection(options::Label{Symbol}...;
          input=Input(option1), label="", value=option1) =
              Selection(input, label, value, (option1, option2))

######################### Button ###########################

type Button <: InputWidget{Nothing}
    input::Input{Nothing}
    label::String
    value::Nothing
    Button(inp::Input{Nothing}, l::String) =
        new(inp, l, nothing)
end

Button(label; input=Input(nothing)) =
    Button(input, label)

######################## Textbox ###########################

type Textbox{T <: Union(Number, String)} <: InputWidget{T}
    input::Input{T}
    label::String
    range::Union(Nothing, Range)
    value::T
end

function empty(t::Type)
    if is(t, Number) zero(t)
    elseif is(t, String) ""
    end
end

function Textbox(; typ=String, label="",
                 value=empty(typ),
                 range=nothing,
                 input=Input(value))
    if isa(value, String) && !isa(range, Nothing)
        throw(ArgumentError(
               "You cannot set a range on a string textbox"
             ))
    end
    Textbox(input, label, range, value)
end

Textbox(val; kwargs...) =
    Textbox(value=val; kwargs...)

function parse{T<:Number}(val, w::Textbox{T})
    v = convert(T, val)
    if isa(w.range, Range)
        # force value to stay in range
        v = max(first(w.range),
                min(last(w.range), v))
    end
    v
end

######################### Textarea ###########################

type Textarea{String} <: InputWidget{String}
    input::Input{String}
    label::String
    value::String
end

Textarea(; label="",
         value="",
         input=Input(value)) =
    Textarea(input, label, value)

Textarea(val; kwargs...) =
    Textarea(value=val; kwargs...)

##################### RadioButtons ######################

type RadioButtons{T} <: InputWidget{T}
    input::Input{T}
    label::String
    value::T
    value_name::String
    options::Vector{Label{Symbol}}
end

RadioButtons(options::Vector{Label{Symbol}};
             label = "",
             value=options[1].value,
             input=Input(value)) =
                 RadioButtons(input, label, value, options)

RadioButtons(options::Vector{Symbol}; kwargs...) =
    RadioButtons(map(Label, options); kwargs...)

##################### Dropdown ########################

type Dropdown{T} <: InputWidget{T}
    input::Input{T}
    label::String
    value::T
    value_label::String
    options::Label{T}
    # TODO: existential checks
end

Dropdown{T}(options::Label{T};
            label = "",
            value_label=first(options)[1],
            value=options[value_label],
            input=Input(value)) =
                Dropdown(input, label, value, value_label, options)

function Dropdown{T}(options::Vector{T}; kwargs...)
    opts = Label{T}()
    map(v->opts[string(v)] = v, options)
    Dropdown(opts; kwargs...)
end
