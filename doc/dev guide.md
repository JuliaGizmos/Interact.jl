### Standard IJulia Display mechanism
1. In IJulia results of cells are `display`ed using julia's display system, IJulia pushes a `IJulia.InlineDisplay()` to the display stack in  [`pushdisplay(IJulia.InlineDisplay())`](https://github.com/JuliaLang/IJulia.jl/src/kernel.jl#L13), which means:
    1. Calls to `display(x)` in a notebook cell are essentially calling:
        1. [`display(d::InlineDisplay, x)`](https://github.com/JuliaLang/IJulia.jl/src/inline.jl#L29-L36) which calls [`display_dict(x)`](https://github.com/JuliaLang/IJulia.jl/src/execute_request#L45) to get a dictionary of mimetypes => data representations (for each mimetype). These then get sent to the Jupyter front-end and Jupyter then decides what to display. Examples of mimetypes are "text/html" (html), "text/plain" (plain text), "image/png" (image data). Jupyter will generally display the "richest" version of what you've sent, i.e. html or an image over the plain text representation.
    1. Simlarly, results of cells also get passed to `display_dict`, and the result is sent to Jupyter in an "execute result" message, see [`execute_request(socket, msg)`](https://github.com/JuliaLang/IJulia.jl/src/execute_request.jl#L210-L214)
    1. `metadata(x)` also gets called on all calls to `display(::IJulia.InlineDisplay, ..., x)` and all "execute result" messages, i.e. basically every time something gets displayed.
    1. [`display_dict(x)`](https://github.com/JuliaLang/IJulia.jl/src/execute_request#L45) checks if a type is writeable for each mimetype using `mimewritable(mimetype, x)` and if it is, calls [`limitstringmime(mime::MIME, x)`](https://github.com/JuliaLang/IJulia.jl/src/execute_request#L28-L40) to get the string value of `x` for that mimetype, which then gets added to a msg.
    1. Finally [`limitstringmime(mime::MIME, x)`](https://github.com/JuliaLang/IJulia.jl/src/execute_request#L28-L40) calls `buf = IOBuffer(); show(IOContext(buf, limit=true), mime, x)` to get the string representation of it that gets sent to the Jupyter front-end

### Interact Modifications

Interact Does the following to ensure `Signal` values are displayed and updated when the value emitted by the signal changes:

1. creates a new method for:
    1. [`IJulia.display_dict(x::Signal)`](../src/IJulia/setup.jl#L95) which simply calls `IJulia.display_dict(value(x))` so the check for which mimetypes the value can be displayed using is based on the value of the signal, not the `s::Signal` object itself - obvious.
1. creates new methods for:
    1. [`metadata(x::Signal)`](../src/IJulia/setup.jl#L89)
        1. calls [`init_comm(x::Signal)`](../src/IJulia/setup.jl#L53) to initialise the comm's for a regular reactive signal, which organises sending the frontend new values as the signal changes. More details below.
    1. [`metadata(x::Widget)`](../src/IJulia/setup.jl#L189-L192)
        1. calls `create_view(x)` to open the Comm (communications channel) to the Jupyter front-end and tell it to display the widget.
    1. [`metadata{T <: Widget}(x::Signal{T})`](../src/IJulia/setup.jl#L189-LL192) (Signal of widgets)
        1. calls `create_widget_signal(x)` to ensure that when the widget emitted by signal `x` updates, a new and/or updated widget is displayed.
1. creates new methods for [`show(io::IO, m::MIME, s::Signal)`](../src/IJulia/setup.jl#L123-L125) which just return `Base.show(io, m, s.value)` and [`Base.show(io::IO, ::MIME"text/html", w::Widget)`](../src/IJulia/setup.jl#L127-L135) which just returns nothing since widget display is handled in `metadata(x::Widget)`, as described above.
1. [`create_view(w::Widget)`](../src/IJulia/setup.jl#L246):
    1. Sets up an `IJulia.Comm` link between the julia kernel and the jupyter frontend. This is Jupyter's method for custom communications between kernels (IJulia, IPython, etc.) and the javascript/html on the Jupyter front-end
    1. adds various properties of the widget to the list of properties to send to the Jupyter front-end:
        1. widget (view and model) type, essentially tell jupyter which widget to create:
            1. `:_view_name` (defaults to) `model_name(w)*"VIEW"`
            1. `:_model_name`(defaults to) `model_name(w)*"MODEL"`
        1. widget initial state and attributes (see [`view_state(w)`](../src/IJulia/setup.jl#L123-L125)):
            1. visible, disabled, etc
            1. `state` - via `statedict(w)`
        1. [`statedict(w)` and `viewdict(w)`](../src/IJulia/statedict.jl)
            1. have methods to set state to be sent to the front-end that's specific to particular widget types `s::Union{Slider, Progress})`, `d::Options` (Dropdown, Radio, ToggleButtons) and one for generic `s::Widget`
    1. Sends a message to the frontend using `IJulia.send_comm` to tell it to display the widget

Assorted Asides:
1. IJulia/src/inline.jl#L9-L19 evals [`display(d::InlineDisplay, ::MIME{Symbol($mime)}, x)`](https://github.com/JuliaLang/IJulia.jl/src/inline.jl#L9-L19) for a number of mimetypes to create display methods for each of those mimetypes (html, image, ..., text) `display(d::InlineDisplay, ::MIME{Symbol($mime)}, x)`, but these only get called when a mimetype is explicitly provided, i.e. when `display(mimetype, x)` is called
1. mimetype (`::MIME`) objects can be created with `MIME(mimestring)`, e.g. `MIME("text/html")`, `MIME("image/png")`, `MIME("text/plain")` etc.
1. Jupyter messages have various msg types, use `IJulia.set_verbose(true)` in a notebook to display all the messages in the shell where jupyter runs. Alternately you can inspect messages in your browser's dev console, network tab, look for `channel?` messages and click the frames tab. The "comm_msg" message type is the main one used for Interact widgets and signals.
1. Interact's [`get_data_dict`](../src/IJulia/setup.jl#L39) calls `Base.stringmime` which calls `Base.reprmime` which calls `Base.sprint` which calls `Base.verbose_show` which calls the [`show(io::IO, m::MIME, s::Signal)`](../src/IJulia/setup.jl#L123-L125) methods descibed above. Not sure when exactly these are called tho... ?

### Signal Display Details
When a signal x is `display`ed, [`metadata(x::Signal)`](../src/IJulia/setup.jl#L90) calls [`init_comm`](../src/IJulia/setup.jl#L54) which:

1. creates a Dict of mimetype => subscription counts for the signal. When the frontend sends a "subscribe_mime" message, the count for that mimetype is increased by one. Similarly, "unsubscribe_mime" decreases the count.
1. creates a map - `notify` - so that when the signal's value updates, a message will be sent to the front-end with the new value (in each of the mimetypes for which the subscribe count is > 0)


### Widget display
1. `create_view` described above.
1. Mechanism for `Signal{Widget}`s to update their display, after a new widget is  pushed to it, is set up at: [`create_widget_signal(s)`](../src/IJulia/setup.jl#L258).
    1. Essentially calls `update_view` which:
        1. If a new widget type is required, the old widget's comm is closed, and a new comm is created for the new widget in `create_view`
        1. If a new widget type is not required, the new/updated widget takes over the comm of the previous widget.

### Comm Objects and Widgets
1. IJulia communicates with the Jupyter front-end through JSON messages sent over ZMQ to a webserver which communicates with the html/js in the browser using websockets, diagram here: http://ipywidgets.readthedocs.io/en/latest/examples/Widget%20Low%20Level.html
1. Each message has a different type, and the main type used by interact is "comm_msg".
1. Widgets use this msg type to send state synchronisation updates
1. Each widget has an associated `Comm` object associated with it that is stored in widget_comms[w]
    1. The comm has an associated id that allows the messages to be routed to the correct widget in the front-end:
1. As a consequence if a Signal{Widget} emits a new value with a new widget type, a new Comm object must be set up, this is handled in [`update_view`](../src/IJulia/setup.jl#L197)
1. In order for a new Widget to be displayed, a new Comm (channel) must be opened, this happens in [`create_view(w)`](../src/IJulia/setup.jl#L254) and a message with content {"method":"display"} must be sent on the comm.

### IJulia Eventloop
1. [Eventloop](https://github.com/JuliaLang/IJulia.jl/src/eventloop.jl) Listens for messages and routes messages to handlers for each message type
1. Comm messages (msg_type="comm_msg"), from widget changes due to user interaction, are sent to comm.on_msg callbacks which call handle_msg(w) specific for each widget type, see [here](../src/IJulia/handle_msg.jl)
1. They call [`recv_msg`](../src/Interact.jl#L49) which pushes a new value to the widget's signal.
1. Since Reactive reads new values that are `push!`ed to signals [asynchronously](https://github.com/JuliaLang/Reactive.jl/src/core.jl#L276-L278) any processing that happens as a result of the push happens in a separate Task. This is an issue Since the IJulia eventloop essentially immediately returns "status": "idle", which may truncate some IO stream messages. XXX should add yield()'s and flush_all()s in handle_msg.jl

Further Reading:
1. http://ipywidgets.readthedocs.io/en/latest/examples/Widget%20Low%20Level.html
1. https://github.com/ipython/ipython/wiki/IPEP-21:-Widget-Messages
