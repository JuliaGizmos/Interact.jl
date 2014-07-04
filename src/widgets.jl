

using React
using JSON

import Base.convert

export signal, statedict

#const react_js = readall(joinpath(Pkg.dir("Interact"), "data", "react.min.js"))
#const transform_js = readall(joinpath(Pkg.dir("Interact"), "data", "JSXTransformer.min.js"))

function prepare_display(d::Display)
    display(d, "text/html", """<script charset="utf-8">$(react_js)</script>""")
end

try
    #display("text/html", """<script charset="utf-8">$(react_js)</script>""")
catch
end

abstract Widget{T}
abstract InputWidget{T}  <: Widget{T} # A widget that takes input of type T

signal(w :: InputWidget) = w.input

# A type for values with labels (e.g. radio button options)
type Label{T}
    label :: String
    value :: T
end

Label(x) = Label(ucfirst(string(x)), x)
convert{T}(::Type{Label{T}}, x::T) = Label(x)

function statedict(w :: InputWidget)
    msg = Dict()
    attrs = names(w)
    for n in attrs
        if n in [:input, :label]
            continue
        end
        msg[n] = getfield(w, n)
    end
    msg
end

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

type ToggleButton <: InputWidget{Symbol}
    input   :: Input{Symbol}
    label   :: String
    value   :: Symbol
    options :: (Label{Symbol}...)
end

ToggleButton(options :: Label{Symbol}...;
             input=Input(option1), label="", value=option1) =
                 ToggleButton(input, label, value, (option1, option2))

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


function parse{T}(msg, ::InputWidget{T})
    # Should return a value of type T, by default
    # msg itself is assumed to be the value.
    return convert(T, msg)
end


# default cases

parse{T <: Integer}(v, ::InputWidget{T}) = int(v)
parse{T <: FloatingPoint}(v, ::InputWidget{T}) = float(v)
parse(v, ::InputWidget{Bool}) = bool(v)

function recv{T}(widget :: InputWidget{T}, value)
    # Hand-off received value to the signal graph
    push!(widget.input, parse(value, widget))
end

uuid4() = string(Base.Random.uuid4())

const id_to_widget = Dict{String, InputWidget}()
const widget_to_id = Dict{InputWidget, String}()

function register_widget(w :: InputWidget)
    if haskey(widget_to_id, w)
        return widget_to_id[w]
    else
        id = string(uuid4())
        widget_to_id[w] = id
        id_to_widget[id] = w
        return id
    end        
end

function get_widget(id :: String)
    if haskey(id_to_widget, id)
        return id_to_widget[id]
    else
        warn("Widget with id $(id) does not exist.")
    end
end
