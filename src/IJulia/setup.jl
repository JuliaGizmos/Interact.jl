using JSON
using Reactive
using Compat
import Compat.String

import Base: writemime
import Interact: update_view, Slider, Widget, InputWidget, Latex, HTML, recv_msg, statedict,
                 Progress, Checkbox, Button, ToggleButton, Textarea, Textbox, Options

export mimewritable, writemime

const ijulia_js = readstring(joinpath(dirname(@__FILE__), "ijulia.js"))

if displayable("text/html")
    display("text/html", """
     <div id="interact-js-shim">
         <script charset="utf-8">$(ijulia_js)</script>
         <script>
             window.interactLoadedFlag = true
            \$("#interact-js-shim").bind("destroyed", function () {
                if (window.interactLoadedFlag) {
                    console.warn("JavaScript required by Interact will be removed if you remove this cell or run using Interact more than once.")
                }
            })
            \$([IPython.events]).on("kernel_starting.Kernel kernel_restarting.Kernel", function () { window.interactLoadedFlag = false })
        </script>
     </div>""")
end

import IJulia
import IJulia: metadata, display_dict
using  IJulia.CommManager
import IJulia.CommManager: register_comm
import Base: show, mimewritable

const comms = Dict{Signal, Comm}()

function get_data_dict(value, mimetypes)
    dict = Dict{Compat.ASCIIString, Compat.String}()
    for m in mimetypes
        if mimewritable(m, value)
            dict[m] = stringmime(m, value)
        elseif m == "text/latex" && mimewritable("application/x-latex", value)
            dict[string("text/latex")] =
                stringmime("application/x-latex", value)
        else
            warn("IPython seems to be requesting an unavailable mime type")
        end
    end
    return dict
end

function init_comm(x::Signal)
    if !haskey(comms, x)
        subscriptions = Dict{Compat.ASCIIString, Int}()
        function handle_subscriptions(msg)
            if haskey(msg.content, "data")
                action = get(msg.content["data"], "action", "")
                if action == "subscribe_mime"
                    mime = msg.content["data"]["mime"]
                    subscriptions[mime] = get(subscriptions, mime, 0) + 1
                elseif action == "unsubscribe_mime"
                    mime = msg.content["data"]["mime"]
                    subscriptions[mime] = get(subscriptions, mime, 1) - 1
                end
            end
        end
        # One Comm channel per signal object
        comm = Comm(:Signal)
        comms[x] = comm   # Backend -> Comm
        # Listen for mime type registrations
        comm.on_msg = handle_subscriptions
        # prevent resending the first time?
        function notify(value)
            mimes = keys(filter((k,v) -> v > 0, subscriptions))
            if length(mimes) > 0
                send_comm(comm, @compat Dict(:value =>
                                 get_data_dict(value, mimes)))
            end
        end
        preserve(map(notify, x))
    else
        comm = comms[x]
    end

    return comm
end

function metadata(x::Signal)
    comm = init_comm(x)
    return @compat Dict("reactive"=>true,
                        "comm_id"=>comm.id)
end

function IJulia.display_dict(x::Signal)
    IJulia.display_dict(value(x))
end

# Render the value of a signal.
mimewritable(m::MIME, s::Signal) =
    mimewritable(m, s.value)

# fixes ambiguity warnings
@compat function Base.show(io::IO, m::MIME"text/plain", s::Signal)
    Base.show(io, m, s.value)
end

@compat function Base.show(io::IO, m::MIME"text/csv", s::Signal)
    Base.show(io, m, s.value)
end

@compat function Base.show(io::IO, m::MIME"text/tab-separated-values", s::Signal)
    Base.show(io, m, s.value)
end

@compat function Base.show(io::IO, m::MIME, s::Signal)
    Base.show(io, m, s.value)
end

@compat function Base.show(io::IO, ::MIME"text/html", w::InputWidget)
    create_view(w)
end

@compat function Base.show(io::IO, ::MIME"text/html", w::Widget)
    create_view(w)
end

@compat function Base.show{T<:Widget}(io::IO, ::MIME"text/html", x::Signal{T})
    create_widget_signal(x)
end


## This is for our own widgets.
function register_comm(comm::Comm{:InputWidget}, msg)
    w_id = msg.content["data"]["widget_id"]
    comm.on_msg = (msg) -> recv_msg(w, msg.content["data"]["value"])
end

JSON.print(io::IO, s::Signal) = JSON.print(io, s.value)

##################### IPython IPEP 23: Backbone.js Widgets #################

## ButtonView ✓
## CheckboxView ✓
## DropdownView ✓
## FloatSliderView ✓
## FloatTextView ✓
## IntSliderView ✓
## IntTextView ✓
## ProgressView
## RadioButtonsView ✓
## SelectView ✓
## TextareaView ✓
## TextView ✓
## ToggleButtonsView ✓
## ToggleButtonView ✓
## AccordionView W
## ContainerView W
## PopupView W
## TabView W

# Interact -> IJulia view names
widget_class(::HTML) = "HTML"
widget_class(::Latex) = "LaTeX"
widget_class(::Progress) = "Progress"
widget_class{T<:Integer}(::Slider{T}) = "IntSlider"
widget_class(::Button) = "Button"
widget_class(::Textarea) = "Textarea"
widget_class{T<:AbstractFloat}(::Slider{T}) = "FloatSlider"
widget_class{T<:Integer}(::Textbox{T}) = "IntText"
widget_class(::Checkbox) = "Checkbox"
widget_class(::ToggleButton) = "ToggleButton"
widget_class{T<:AbstractFloat}(::Textbox{T}) = "FloatText"
widget_class(::Textbox) = "Text"
widget_class{view}(::Options{view}) = string(view)
widget_class(w, suffix) = widget_class(w) * suffix
view_name(w) = widget_class(w, "View")
model_name(w) = widget_class(w, "Model")

function metadata{T <: Widget}(x::Signal{T})
    Dict()
end

function add_ipy3_state!(state)
    for attr in ["color" "background" "width" "height" "border_color" "border_width" "border_style" "font_style" "font_weight" "font_size" "font_family" "padding" "margin" "border_radius"]
        state[attr] = ""
    end
end

function add_ipy4_state!(state)
    state["_view_module"] = "jupyter-js-widgets"
    state["_model_module"] = "jupyter-js-widgets"
end

const widget_comms = Dict{Widget, Comm}()
function update_view(w; src=w)
    send_comm(widget_comms[w], view_state(w, src=src))
end

function view_state(w::InputWidget; src::InputWidget=w)
    msg = Dict()
    msg["method"] = "update"
    state = Dict()
    state["msg_throttle"] = 3
    state["_view_name"] = view_name(src)
    state["_model_name"] = model_name(src)
    state["model_name"] =  model_name(src)
    state["description"] = w.label
    state["visible"] = true
    state["disabled"] = false
    state["readout"] = true
    add_ipy3_state!(state)
    add_ipy4_state!(state)
    msg["state"] = merge(state, statedict(src))
    msg
end

function view_state(w::Widget; src::Widget=w)
    msg = Dict()
    msg["method"] = "update"
    state = Dict()
    state["msg_throttle"] = 3
    state["_view_name"] = view_name(src)
    state["_model_name"] = model_name(src)
    state["model_name"] = model_name(src)
    state["description"] = w.label
    state["visible"] = true
    state["disabled"] = false
    add_ipy3_state!(state)
    add_ipy4_state!(state)

    msg["state"] = merge(state, statedict(src))
    msg
end

function create_view(w::Widget)
    if haskey(widget_comms, w)
        comm = widget_comms[w]
    else
        comm = Comm("jupyter.widget", data=merge(Dict{AbstractString, Any}([
            ("model_name", model_name(w)),
            ("_model_name", model_name(w)), # Jupyter 4.0 missing (https://github.com/ipython/ipywidgets/pull/84)
            ("_view_module", "jupyter-js-widgets"),
            ("_model_module", "jupyter-js-widgets"),
        ]), view_state(w)))
        widget_comms[w] = comm
        # Send a full state update message.
        update_view(w) # This is redundant on 4.0 but keeps it working on Jupyter 3.0

        # dispatch messages to widget's handler
        comm.on_msg = msg -> handle_msg(w, msg)
        nothing # display() nothing
    end

    send_comm(comm, @compat Dict("method"=>"display"))
end

function create_widget_signal(s)
    create_view(s.value)
    local target = s.value
    preserve(map(x->update_view(target, src=x), s, init=nothing))
end

include("statedict.jl")
include("handle_msg.jl")
