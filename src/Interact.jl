module Interact

using Reactive, Compat

import Base: mimewritable, writemime
export signal, Widget, InputWidget

# A widget
abstract Widget

# A widget that gives out a signal of type T
abstract InputWidget{T}  <: Widget

signal(w::InputWidget) = w.signal
signal(x::Signal) = x

function statedict(w)
    msg = Dict()
    attrs = @compat fieldnames(w)
    for n in attrs
        if n in [:signal, :label]
            continue
        end
        msg[n] = getfield(w, n)
    end
    msg
end

# Convert e.g. JSON values into Julia values
parse_msg{T <: Number}(::InputWidget{T}, v::AbstractString) = parse(T, v)
parse_msg(::InputWidget{Bool}, v::Number) = v != 0
parse_msg{T}(::InputWidget{T}, v) = convert(T, v)

"""
update the view of a widget.
child packages need to override this function
"""
function update_view end

function recv_msg{T}(widget ::InputWidget{T}, value)
    # Hand-off received value to the signal graph
    parsed = parse_msg(widget, value)
    println(STDERR, signal(widget))
    push!(signal(widget), parsed)
    widget.value = parsed
    if value != parsed
        update_view(widget)
    end
end

uuid4() = string(Base.Random.uuid4())

const id_to_widget = Dict{AbstractString, InputWidget}()
const widget_to_id = Dict{InputWidget, AbstractString}()

function register_widget(w::InputWidget)
    if haskey(widget_to_id, w)
        return widget_to_id[w]
    else
        id = uuid4()
        widget_to_id[w] = id
        id_to_widget[id] = w
        return id
    end
end

function get_widget(id::AbstractString)
    if haskey(id_to_widget, id)
        return id_to_widget[id]
    else
        warn("Widget with id $(id) does not exist.")
    end
end

include("widgets.jl")
include("compose.jl")
include("manipulate.jl")

function __init__()
    if isdefined(Main, :IJulia)
        include(joinpath(dirname(@__FILE__), "IJulia", "setup.jl"))
    end
end

end # module
