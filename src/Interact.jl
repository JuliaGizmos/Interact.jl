__precompile__()

module Interact

using Reactive, Compat, DataStructures

import Base: mimewritable
export signal, Widget, InputWidget

# A widget
@compat abstract type Widget end

# A widget that gives out a signal of type T
@compat abstract type InputWidget{T}  <: Widget end

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

function viewdict(w::Widget)
    Dict()
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


function error_handler(sig, value, err)
    Reactive.print_error(sig, value, err, open("/tmp/Interact.log", "a"))
end

function recv_msg{T}(widget::InputWidget{T}, val)
    # Hand-off received value to the signal graph
    parsed = parse_msg(widget, val)
    widget.value = parsed
    if signal(widget).value != parsed || isa(widget, Button)
        #push only changed values, but for Buttons we always push
        push!(signal(widget), parsed)
    end
    if val != parsed
        println(STDERR, "val != parsed: <val>$val</val> <parsed>$parsed</parsed>")
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

const ijulia_setup_path = joinpath(dirname(@__FILE__), "IJulia", "setup.jl")
const ijulia_setup_path_old = joinpath(dirname(@__FILE__), "IJulia", "setup_old.jl")
const ipywidgets_version = joinpath(dirname(@__FILE__), "..", "deps", "ipywidgets_version")

function __init__()
    if isdefined(Main, :IJulia)
        if isfile(ipywidgets_version)
            v = VersionNumber(strip(readline(ipywidgets_version)))
            if v >= v"7.0.0"
                include(ijulia_setup_path)
            else
                include(ijulia_setup_path_old)
            end
        else
            include(ijulia_setup_path)
        end
    end
end

"""
Interact.jl allows you to use interactive widgets such as sliders, dropdowns and checkboxes to play with your Julia code.

Basic widgets:

- `slider(1:10)` creates a slider widget with the specified range of values
- `checkbox(false)` creates a check box
- `togglebutton(false)` creates a toggle button
- `button()` creates a button

Option (selection) widgets:

- `dropdown(["one", "two", "three"])` creates a drop-down widget
- `togglebuttons(["one", "two", "three"])` creates a toggle button group
- `radiobuttons(["one", "two", "three"])` creates a radio button group

Text boxes:

- `textbox(value)` creates a box accepting string or numeric text input
- `textarea` creates a box for extended text input

Output widgets:

- `latex`
- `progress`
"""
Interact

end # module
