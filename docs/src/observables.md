# Observables

Observables are like `Ref`s, but listen to changes.

```@repl manual
using Interact

observable = Observable(0)

h = on(observable) do val
    println("Got an update: ", val)
end

observable[] = 42
```

To get the value of an observable, index it with no arguments:
```@repl manual
observable[]
```

To remove a handler, use `off` with the return value of `on`:
```@repl manual
off(observable, h)
```

### How is this different from Reactive.jl?

The main difference is `Signal`s are manipulated mostly by converting one signal to another. For example, with signals, you can construct a changing UI by creating a `Signal` of UI objects and rendering them as the signal changes. On the other hand, you can use an Observable both as an input and an output. You can arbitrarily attach outputs to inputs, so code can be structured in a [signals-and-slots](http://doc.qt.io/qt-4.8/signalsandslots.html) pattern.

Observables are also synchronous, whereas Signals are asynchronous. Observables may be better suited for an imperative style of programming.

## API

### Type

```@docs
Observable{T}
```

### Functions

```@docs
on(f, o::Observable)
off(o::Observable, f)
Base.setindex!(o::Observable, val)
Base.getindex(o::Observable)
onany(f, os...)
Base.map!(f, o::Observable, os...)
connect!(o1::Observable, o2::Observable)
Base.map(f, o::Observable, os...; init)
throttle(dt, o::Observable)
```
### Macros

```@docs
Interact.@map
Interact.@map!
Interact.@on
```
