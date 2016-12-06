using JSON
using Reactive
using Compat
import Compat.String

import Base: writemime
import Interact: update_view, Slider, Widget, InputWidget, Latex, HTML,
                 recv_msg, statedict, viewdict, Progress, Checkbox, Button,
                 ToggleButton, Textarea, Textbox, Options

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
import IJulia: metadata, mimewritable, limitstringmime
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
                #XXX @compat needed?
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
    #XXX @compat needed?
    return @compat Dict("reactive"=>true,
                        "comm_id"=>comm.id)
end

for mime in IJulia.ipy_mime
    @eval begin
        function IJulia.mimewritable(m::MIME{Symbol($mime)}, s::Signal)
            IJulia.mimewritable(m, value(s))
        end

        function IJulia.limitstringmime(m::MIME{Symbol($mime)}, s::Signal)
            IJulia.limitstringmime(m, value(s))
        end

        function Base.show(io::IO, m::MIME{Symbol($mime)}, s::Signal)
            Base.show(io, m, value(s))
        end
    end
end

#XXX @compat needed?
@compat function Base.show(io::IO, m::MIME"text/csv", s::Signal)
    Base.show(io, m, s.value)
end

@compat function Base.show(io::IO, m::MIME"text/tab-separated-values", s::Signal)
    Base.show(io, m, s.value)
end

widget_comms = Dict{Widget, Comm}()
@compat function Base.show(io::IO, ::MIME"text/html", w::Widget)
    create_view(w)
end

#Signals of widgets need to be handled specially
function IJulia.limitstringmime{T<:Widget}(m::MIME"text/html", x::Signal{T})
    create_widget_signal(x)
    ""
end

function metadata{T<:Widget}(x::Signal{T})
    #avoid normal Signal updating, Signal{Widget} updates handled in create_widget_signal
    return Dict()
end

## This is for our own widgets.
function register_comm(comm::Comm{:InputWidget}, msg)
    w_id = msg.content["data"]["widget_id"]
    comm.on_msg = (msg) -> recv_msg(w, msg.content["data"]["value"])
end

JSON.lower(s::Signal) = s.value

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

function add_ipy4_state!(state)
    state[:_view_module] = "jupyter-js-widgets"
    state[:_model_module] = "jupyter-js-widgets"
end

function view_state(w::Widget)
    msg = viewdict(w)
    msg[:method] = "update"
    msg[:_view_name] = view_name(w)
    state = Dict()
    state[:msg_throttle] = 3
    state[:_model_name] = model_name(w)
    state[:model_name] = model_name(w)
    state[:description] = :label in fieldnames(w) ? w.label : ""
    add_ipy4_state!(state)
    msg[:state] = merge(state, statedict(w))
    # @show string(w) model_name(w) view_name(w) typeof(w)
    msg
end

function new_widget_dict(w::Widget)
    # wdata = view_state(w) #XXX check if can delete
    wdata = Dict(:_view_name => view_name(w))
    add_ipy4_state!(wdata)
    wdata[:_model_name] = model_name(w)
    wdata[:model_name] = model_name(w)
    wdata
end

function create_view(w::Widget)
    #create the widget on the front-end by opening the comm
    if haskey(widget_comms, w)
        #existing (non Signal{Widget}.value) widgets
        comm = widget_comms[w]
    else
        #new Widgets
        comm = Comm("jupyter.widget", data=new_widget_dict(w))
        widget_comms[w] = comm
    end
    # dispatch messages to widget's handler
    comm.on_msg = msg -> handle_msg(w, msg)
    send_comm(comm, view_state(w)) #set the state of newly created widget
    send_comm(comm, Dict(:method=>"display"))
    comm
end

function update_view(w::Widget; prevw=w)
    if w != prevw
        #If the widget has changed a new widget must be set up and the old
        #one removed.
        remove_view(prevw)
        create_view(w)
    else
        #update the view
        send_comm(widget_comms[w], view_state(w))
    end
end

function remove_view(prevw::Widget)
    #closing the comm removes ALL widget(s) associated with that comm
    if haskey(widget_comms, prevw)
        close_comm(widget_comms[prevw])
        delete!(widget_comms, prevw)
    else
        println("hmmm ", typeof(prevw))
    end
end

function create_widget_signal(s::Signal{Widget})
    local prev_widg = s.value
    create_view(s.value)
    map(s, init=nothing) do x
        update_view(x; prevw=prev_widg)
        prev_widg = x
        nothing
    end |> preserve
end

include("statedict.jl")
include("handle_msg.jl")
