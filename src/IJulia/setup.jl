module InteractIJulia

using JSON
using Reactive
using Interact
using Compat
import Compat.String

import Interact: update_view, Slider, Widget, InputWidget, Latex, HTML, recv_msg,
                 statedict, viewdict, Layout, Box,
                 Progress, Checkbox, Button, ToggleButton, Textarea, Textbox, Options

export mimewritable

const ijulia_js = readstring(joinpath(dirname(@__FILE__), "ijulia.js"))

if displayable("text/html")
    display("text/html", Base.Docs.HTML("""
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
     </div>"""))
end

import IJulia
import IJulia: metadata, display_dict
using  IJulia.CommManager
import IJulia.CommManager: register_comm
import Base: show, mimewritable

const comms = Dict{Signal, Comm}()

function get_data_dict(value, mimetypes)
    dict = Dict{String, String}()
    for m in mimetypes
        if mimewritable(m, value)
            dict[m] = stringmime(m, value)
        elseif m == "text/latex" && mimewritable("application/x-latex", value)
            dict[string("text/latex")] =
                stringmime("application/x-latex", value)
        else
            warn("IPython seems to be requesting an unavailable mime type: $m, value: ", string(value))
        end
    end
    return dict
end

function init_comm(x::Signal)
    if !haskey(comms, x)
        subscriptions = Dict{String, Int}()
        handle_subscriptions = (msg) -> begin
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
        notify = (value) -> begin
            mimes = keys(filter((k,v) -> v > 0, subscriptions))
            if length(mimes) > 0
                send_comm(comm, @compat Dict(:value =>
                                 get_data_dict(value, mimes)))
            end
        end
        preserve(map(notify, x; name="$(x.name) printer (Interact)"))
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
    IJulia.display_dict(Reactive.value(x))
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

@compat function Base.show(io::IO, ::MIME"text/html", w::Widget)
    #widget display is handled in metadata
    nothing
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
widget_class(::Layout) = "Layout"
widget_class(b::Box) = b.vert ? "VBox" : "Box"
widget_class(::Latex) = "Label"
widget_class(::Progress) = "FloatProgress"
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

# Special cases
view_name(w::Progress) = "ProgressView"

function metadata(x::Widget)
    display_widget(x)
    Dict()
end

function metadata{T <: Widget}(x::Signal{T})
    create_widget_signal(x)
    Dict()
end

function add_ipy4_state!(state)
    state[:_view_module] = "@jupyter-widgets/controls"
    state[:_model_module] = "@jupyter-widgets/controls"
end

const widget_comms = Dict{Widget, Comm}()
function update_view(w::Widget; prevw=w)
    if typeof(w) != typeof(prevw) || (isa(w, Box) && (w.vert != prevw.vert))
        #If the widget type has changed, a new widget must be set up and the old
        #one removed.
        remove_view(prevw)
        display_widget(w)
    else
        #w is same type as prevw
        if w !== prevw
            #new widget instance takes over the comm of the old instnace
            wire_comms(w, widget_comms[prevw])
            isa(w, Box) && (w.layout = prevw.layout)
            delete!(widget_comms, prevw)
        end
        #update all existing views of the widget
        haskey(widget_comms, w) && send_comm(widget_comms[w], view_state(w))
    end
end

function remove_view(prevw::Widget)
    #closing the comm removes ALL widget(s) associated with that comm
    close_comm(widget_comms[prevw])
    delete!(widget_comms, prevw)
    nothing
end

function view_state(w::Widget; src::Widget=w)
    msg = viewdict(src)
    msg[:method] = "update"
    state = Dict()
    state[:msg_throttle] = 5
    state[:_view_name] = view_name(src)
    state[:_model_name] = model_name(src)
    state[:model_name] =  model_name(src)
    :label in fieldnames(w) && (state[:description] = w.label)
    state[:visible] = true
    state[:disabled] = false
    state[:readout] = true
    add_ipy4_state!(state)
    msg[:state] = merge!(state, statedict(src))
    msg
end

function init_widget_dict(w::Widget)
    merge!(viewdict(w),
        Dict{Symbol, Any}(:state => Dict{Symbol, Any}(
            :_model_module => "@jupyter-widgets/controls",
            :_model_module_version => "1.0.0",
            :_model_name => model_name(w),
            :_view_module => "@jupyter-widgets/controls",
            :_view_module_version => "1.0.0",
            :_view_name => view_name(w)
        )))
end

"""
`display_widget(w::Widget)`
Creates the widget on the front-end and displays it
Sets `widget_comms[w]` to the widget's comm
returns the widget's Comm object
"""
function display_widget(w::Widget)
    comm = create_view(w::Widget)
    IJulia.send_ipython(IJulia.publish[],
                 IJulia.msg_pub(IJulia.execute_msg, "display_data",
                         Dict("source" => "julia", # optional
                          "metadata" => Dict(),
                          "data" => Dict("application/vnd.jupyter.widget-view+json"=>Dict(
                              :model_id=>comm.id,
                              :version_major => 2,
                              :version_minor => 0,
                          )))))
end

function create_view(w::Widget)
    if haskey(widget_comms, w)
        comm = widget_comms[w]
    else
        #create the widget on the front-end by opening its comm
        comm = Comm("jupyter.widget", data=init_widget_dict(w), metadata=Dict(:version=>"2.0"))
        wire_comms(w, comm)
    end
    send_comm(comm, view_state(w)) #set/update the widget's state
    comm
end

function create_view(b::Box)
    layout_comm = create_view(b.layout)
    foreach(b.children) do childw
        create_view(childw)
    end
    invoke(create_view, Tuple{Widget}, b)
end

function wire_comms(w, comm)
    # dispatch messages to widget's handler
    widget_comms[w] = comm
    comm.on_msg = msg -> handle_msg(w, msg)
end

#used to avoid double/triple creation of updaters, without this multiple widgets
#can appear on update if a Signal{Widget} is `display`ed more than once
const sigwidg_has_updater = WeakKeyDict{Signal, Bool}()
"""
Display the current value of a Signal{Widget} and ensure it stays up-to-date
"""
function create_widget_signal{T<:Widget}(s::Signal{T})
    local prev_widg = Reactive.value(s)
    display_widget(Reactive.value(s))
    if !haskey(sigwidg_has_updater, s)
        map(s, init=nothing) do x
            update_view(x; prevw=prev_widg)
            prev_widg = x
            nothing
        end |> preserve
        sigwidg_has_updater[s] = true
    end
end

include("statedict.jl")
include("handle_msg.jl")

end
