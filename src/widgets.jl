
using React
using JSON

import Base.convert

export signal

#const react_js = readall(joinpath(Pkg.dir("Interact"), "data", "react.min.js"))
#const transform_js = readall(joinpath(Pkg.dir("Interact"), "data", "JSXTransformer.min.js"))

# Include the the d3 javascript library
function prepare_display(d::Display)
    display(d, "text/html", """<script charset="utf-8">$(react_js)</script>""")
end

try
    display("text/html", """<script charset="utf-8">$(react_js)</script>""")
catch
end


abstract InputWidget{T}  # A widget that takes input of type T

signal(w :: InputWidget) = w.input
# A type for values with labels (e.g. radio button options)
type Labeled{T}
    label :: String
    value :: T
end

Labeled(x) = Labeled(ucfirst(string(x)), x)
convert{T}(::Type{Labeled{T}}, x::T) = Labeled(x)

type Slider{T <: Number} <: InputWidget{T}
    input :: Input{T}
    label :: String
    value :: T
    min   :: T
    max   :: T
    step  :: T
end


type Checkbox <: InputWidget{Bool}
    input :: Input{Bool}
    label :: String
    value :: Bool
end


type ToggleButton <: InputWidget{Symbol}
    input :: Input{Symbol}
    label :: String
    value   :: Symbol
    options :: (Labeled{Symbol}, Labeled{Symbol})
end


type Button <: InputWidget{Nothing}
    label :: String
    value :: Nothing
    Button(l::String) = new(l, nothing)
end

type Text{T} <: InputWidget{T}
    input :: Input{T}
    label :: String
    value :: T
end


type Textarea{String} <: InputWidget{String}
    input :: Input{String}
    label :: String
    value :: String
end

type RadioButtons <: InputWidget{Symbol}
    input :: Input{Symbol}
    label :: String
    value :: Symbol
    options :: Vector{Labeled{Symbol}}
end


type Dropdown <: InputWidget{Symbol}
    input :: Input{Symbol}
    label :: String
    value :: Symbol
    options :: Vector{Labeled{Symbol}}
end


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
