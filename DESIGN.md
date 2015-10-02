IDE Specifics
-------------
IJulia-specific code is in `ijulia_setup.jl` for now (probably should factor out into a separate module later). This file is included by `Interact.jl` if used from inside IJulia notebooks. This is the only file where IJulia specific stuff must go (e.g. setting up comm)

It will be possible for any environment to tap into the bulk of code here which will help in building interactive features.

**To integrate Interact.jl with your IDE, you will have to implement the following:**

1. When displaying a value of type `Signal{T}` render it as you'd render a value of type `T`.
2. Set things up so that when the diplayed signal updates, you also redraw its display. You can use the `lift` operator to do this:
```julia
# a hypothetical updater sending a redraw message to the frontend
lift(v -> redraw(signal_identifier, v), signal)
# the frontend should receive this message and redraw all displayed instances of the signal
```
3. A value of type `InputWidget{T}` must be rendered as a GUI element corresponding to its concrete type. e.g. a `Slider{Int}` should be shown as a slider with integer values. Every InputWidget type has its own set of attributes that the display must use, see `widgets.jl`. If your IDE supports HTML/JS, `widgets.js` already does this for you! You only need to set up the communication.
4. When a GUI element updates due to a user event, the GUI should, using some kind of messaging scheme, encode the update and send it to the backend.
5. You can attach an InputWidget{T} to an Input{T} using the `attach!` function, (and detach using detach!). `parse{T}(msg, :: InputWidget{T})` function takes a serialized representation (e.g. a JSON parsed Dict) of the message from a specific type of widget, and returns a value of type `T`. And finally `recv(widget, value)` hands-off the value to all the Input values attached to the widget. Ideally there should be a one-to-one mapping between Widgets and Inputs.

For a better understanding see `ijulia.js` and `ijulia_setup.jl`

Optimizations
-------------
### DiffPatch.jl
A `DiffPatch.jl` module can be made which can take the diff of two values of the same type and create a delta, and also patch a delta over a value to get the next value. Frontends and backends can send the deltas when it becomes economical. A diff-patch mecahnism will be easy to plug in at both ends at a later stage without any breaking change to the external API. Right now the focus is on making things work.

### Throttle
Will be adding features to throttle signals to send kernel-client messages at an optimal rate so that interactive IDEs feel responsive. I am planning to put this in a Timing module in Reactive.jl.

Macro based API
---------------
It should be intuitive to create interactive objects.

One idea:
```julia
@manipulate expr x=widget_description1 y=widget_description2 ...
# this will evaluate expr where variables x, y etc are populated from the widget description
# the macro will handle low level signal handling.
```
Will be writing more about this in the later part of the project.

Layout system
-------------
Sometimes we will need to group and lay widgets out in specific ways. I think this should be decoupled from interactive stuff. Having things like a container widget which builds a composite typed value will be unnecessarily complex in the context of Reactive.jl. A Layout module would have the following:

A type `Element` which represents anything displayable (can use type promotion here to make specific types displayable). Element will be a [group](http://en.wikipedia.org/wiki/Group_(mathematics)) that has some useful operators:

```julia
# stack elems in the specified direction (down, right, left, up)
flow(direction :: Symbol, elems :: Element....) # returns an Element
# Create a tab group with a tab for each element
tabs(elems :: (AbstractString, Element)...)      # returns an Element
# accordion, etc in the same vein
```

The idea is to create a declarative representation of the layout and have the IDEs handle the actual rendering. `widgets.js` will help you do this for IDEs that support HTML/JS/CSS.
