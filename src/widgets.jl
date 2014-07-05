
using React
using JSON

export signal, statedict

export register_widget, get_widget, parse, recv

# A widget
abstract Widget

# A widget that takes input of type T
abstract InputWidget{T}  <: Widget

signal(w::InputWidget) = w.input

function statedict(w::InputWidget)
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

function parse{T}(msg, ::InputWidget{T})
    # Should return a value of type T, by default
    # msg itself is assumed to be the value.
    return convert(T, msg)
end

# default cases

parse{T <: Integer}(v, ::InputWidget{T}) = int(v)
parse{T <: FloatingPoint}(v, ::InputWidget{T}) = float(v)
parse(v, ::InputWidget{Bool}) = bool(v)

function recv{T}(widget ::InputWidget{T}, value)
    # Hand-off received value to the signal graph
    push!(widget.input, parse(value, widget))
end

uuid4() = string(Base.Random.uuid4())

const id_to_widget = Dict{String, InputWidget}()
const widget_to_id = Dict{InputWidget, String}()

function register_widget(w::InputWidget)
    if haskey(widget_to_id, w)
        return widget_to_id[w]
    else
        id = string(uuid4())
        widget_to_id[w] = id
        id_to_widget[id] = w
        return id
    end        
end

function get_widget(id::String)
    if haskey(id_to_widget, id)
        return id_to_widget[id]
    else
        warn("Widget with id $(id) does not exist.")
    end
end

include("inputwidgets.jl")
include("outputwidgets.jl")
