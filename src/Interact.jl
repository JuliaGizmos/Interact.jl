module Interact

using Reactive, Compat

import Base: mimewritable, writemime
import Reactive.signal
export signal, statedict, Widget, InputWidget, register_widget,
       get_widget, parse_msg, recv_msg, update_view

# A widget
abstract Widget <: SignalSource

# A widget that gives out a signal of type T
abstract InputWidget{T}  <: Widget

signal(w::InputWidget) = w.signal

function statedict(w::Widget)
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

function update_view(w)
    # update the view of a widget.
    # child packages need to override.
end

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

const id_to_widget = Dict{String, InputWidget}()
const widget_to_id = Dict{InputWidget, String}()

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

function get_widget(id::String)
    if haskey(id_to_widget, id)
        return id_to_widget[id]
    else
        warn("Widget with id $(id) does not exist.")
    end
end

include("widgets.jl")
include("compose.jl")
include("manipulate.jl")
include("html_setup.jl")

if isdefined(Main, :IJulia) && Main.IJulia.inited
    ijuliaver = Pkg.installed("IJulia")
    if ijuliaver === nothing || ijuliaver < v"0.1.3-"
        warn("Interact requires IJulia >= v0.1.3 to work properly.")
    end
    include("IJulia/setup.jl")
end

end # module
