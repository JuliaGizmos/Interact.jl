
using JSON
using Reactive
using Interact
using Compat

import Interact.update_view
export mimewritable, writemime

if !isdefined(Main, :IJulia)
    error("IJuliaWidgets must be imported from inside an IJulia notebook")
end

const ijulia_js  = readall(joinpath(dirname(Base.source_path()), "ijulia.js"))

try
    display("text/html", """<script charset="utf-8">$(ijulia_js)</script>""")
catch
end

import IJulia
import IJulia: metadata, display_dict
using  IJulia.CommManager
import IJulia.CommManager: register_comm
import Base: writemime, mimewritable

const comms = Dict{Signal, Comm}()

function get_data_dict(value, mimetypes)
    dict = Dict{ASCIIString, ByteString}()
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
        subscriptions = Dict{ASCIIString, Int}()
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
        lift(notify, x)
    else
        comm = comms[x]
    end

    return comm
end

function metadata(x :: Signal)
    comm = init_comm(x)
    return @compat Dict("reactive"=>true,
                        "comm_id"=>comm.id)
end

# Render the value of a signal.
mimewritable(m :: MIME, s :: Signal) =
    mimewritable(m, s.value)

function writemime(io:: IO, m :: MIME, s :: Signal)
    writemime(io, m, s.value)
end

function writemime(io::IO, ::MIME{symbol("text/html")},
          w::InputWidget)
    create_view(w)
end

function writemime(io::IO, ::MIME{symbol("text/html")},
                   w::Widget)
    create_view(w)
end

function writemime{T<:Widget}(io::IO, ::MIME{symbol("text/html")},
                              x::Signal{T})
    create_widget_signal(x)
end

## This is for our own widgets.
function register_comm(comm::Comm{:InputWidget}, msg)
    w_id = msg.content["data"]["widget_id"]
    comm.on_msg = (msg) -> recv(w, msg.content["data"]["value"])
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
view_name(::HTML) = "HTMLView"
view_name(::Latex) = "LatexView"
view_name(::Progress) = "ProgressView"
view_name{T<:Integer}(::Slider{T}) = "IntSliderView"
view_name(::Button) = "ButtonView"
view_name(::Textarea) = "TextareaView"
view_name{T<:FloatingPoint}(::Slider{T}) = "FloatSliderView"
view_name{T<:Integer}(::Textbox{T}) = "IntTextView"
view_name(::Checkbox) = "CheckboxView"
view_name(::ToggleButton) = "ToggleButtonView"
view_name{T<:FloatingPoint}(::Textbox{T}) = "FloatTextView"
view_name(::Textbox) = "TextView"
view_name{view}(::Options{view}) = string(view, "View")

function metadata{T <: Widget}(x :: Signal{T})
    Dict()
end

function add_ipy3_state!(state)
    for attr in ["color" "background" "width" "height" "border_color" "border_width" "border_style" "font_style" "font_weight" "font_size" "font_family" "padding" "margin" "border_radius"]
        state[attr] = ""
    end
end

const widget_comms = Dict{Widget, Comm}()
function update_view(w::InputWidget; src::InputWidget=w)
    msg = Dict()
    msg["method"] = "update"
    state = Dict()
    state["msg_throttle"] = 3
    state["_view_name"] = view_name(src)
    state["description"] = w.label
    state["visible"] = true
    state["disabled"] = false
    state["readout"] = true
    add_ipy3_state!(state)
    msg["state"] = merge(state, statedict(src))
    send_comm(widget_comms[w], msg)
end

function update_view(w::Widget; src::Widget=w)
    msg = Dict()
    msg["method"] = "update"
    state = Dict()
    state["msg_throttle"] = 3
    state["_view_name"] = view_name(src)
    state["description"] = w.label
    state["visible"] = true
    state["disabled"] = false
    add_ipy3_state!(state)

    msg["state"] = merge(state, statedict(src))
    send_comm(widget_comms[w], msg)
    nothing
end

function create_view(w::Widget)
    if haskey(widget_comms, w)
        comm = widget_comms[w]
    else
        comm = Comm("ipython.widget", data=Dict([
            ("model_name", "WidgetModel")
        ]))
        widget_comms[w] = comm
        # Send a full state update message.
        update_view(w)

        # dispatch messages to widget's handler
        comm.on_msg = msg -> handle_msg(w, msg)
        nothing # display() nothing
    end

    send_comm(comm, @compat Dict("method"=>"display"))
end

function create_widget_signal(s)
    create_view(s.value)
    local target = s.value
    lift(x->update_view(target, src=x), s, init=nothing)
end

include("statedict.jl")
include("handle_msg.jl")
