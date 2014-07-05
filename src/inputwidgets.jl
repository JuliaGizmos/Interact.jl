export InputWidget, Label, Slider, ToggleButton, Button,
       Checkbox, Textbox, Textarea, RadioButtons, Dropdown

# A type for values with labels (e.g. radio button options)
type Label{T}
    label :: String
    value :: T
end

Label(x) = Label(ucfirst(string(x)), x)
convert{T}(::Type{Label{T}}, x::T) = Label(x)


type Slider{T <: Number} <: InputWidget{T}
    input :: Input{T}
    label :: String
    value :: T
    range :: Range{T}
end

Slider{T}(range :: Range{T};
          value=first(range),
          input=Input(value),
          label="") =
              Slider(input, label, value, range)

statedict(s :: Slider) =
    {:value=>s.value,
     :min=>first(s.range),
     :step=>step(s.range),
     :max=>last(s.range) }

type Checkbox <: InputWidget{Bool}
    input :: Input{Bool}
    label :: String
    value :: Bool
end

Checkbox(; input=Input(false), label="", value=false) =
    Checkbox(input, label, value)

type ToggleButton <: InputWidget{Bool}
    input :: Input{Bool}
    label :: String
    value :: Bool
end
ToggleButton(; input=Input(false), label="", value=false) =
    ToggleButton(input, label, value)

ToggleButton(label; kwargs...) =
    ToggleButton(label=label; kwargs...)

type Selection <: InputWidget{Symbol}
    input   :: Input{Symbol}
    label   :: String
    value   :: Symbol
    options :: (Label{Symbol}...)
end

Selection(options :: Label{Symbol}...;
          input=Input(option1), label="", value=option1) =
              Selection(input, label, value, (option1, option2))

type Button <: InputWidget{Nothing}
    input :: Input{Nothing}
    label :: String
    value :: Nothing
    Button(inp :: Input{Nothing}, l::String) =
        new(inp, l, nothing)
end

Button(label; input=Input(nothing)) =
    Button(input, label)

type Textbox{T <: Union(Number, String)} <: InputWidget{T}
    input :: Input{T}
    label :: String
    range :: Union(Nothing, Range)
    value :: T
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

function parse{T <: Number}(val, w::Textbox{T})
    v = convert(T, val)
    if isa(w.range, Range)
        v = max(first(w.range),
                min(last(w.range), v))
    end
    v
end

type Textarea{String} <: InputWidget{String}
    input :: Input{String}
    label :: String
    value :: String
end

Textarea(; label="",
         value="",
         input=Input(value)) =
    Textarea(input, label, value)

Textarea(val; kwargs...) =
    Textarea(value=val; kwargs...)

type RadioButtons <: InputWidget{Symbol}
    input :: Input{Symbol}
    label :: String
    value :: Symbol
    options :: Vector{Label{Symbol}}
end

RadioButtons(options :: Vector{Label{Symbol}};
             label = "",
             value=options[1].value,
             input=Input(value)) =
                 RadioButtons(input, label, value, options)

RadioButtons(options :: Vector{Symbol}; kwargs...) =
    RadioButtons(map(Label, options); kwargs...)

type Dropdown <: InputWidget{Symbol}
    input :: Input{Symbol}
    label :: String
    value :: Symbol
    options :: Vector{Label{Symbol}}
end

Dropdown(options :: Vector{Label{Symbol}};
         label = "",
         value=options[1].value,
         input=Input(value)) =
             Dropdown(input, label, value, options)

Dropdown(options :: Vector{Symbol}; kwargs...) =
    Dropdown(map(Label, options); kwargs...)

