# Observables

Observables are like `Ref`s but you can listen to changes.

```@repl manual
using Observables

observable = Observable(0)

h = on(observable) do val
    println("Got an update: ", val)
end

observable[] = 42
```

To get the value of an observable index it with no arguments
```@repl manual
observable[]
```

To remove a handler use `off` with the return value of `on`:

```@repl manual
off(observable, h)
```

### How is it different from Reactive.jl?

The main difference is `Signal`s are manipulated mostly by converting one signal to another. For example, with signals, you can construct a changing UI by creating a `Signal` of UI objects and rendering them as the signal changes. On the other hand, you can use an Observable both as an input and an output. You can arbitrarily attach outputs to inputs allowing structuring code in a [signals-and-slots](http://doc.qt.io/qt-4.8/signalsandslots.html) kind of pattern.

Another difference is Observables are synchronous, Signals are asynchronous. Observables may be better suited for an imperative style of programming.

## API

```@docs
Observable{T}
on(f, o::Observable)
off(o::Observable, f)
Base.setindex!(o::Observable, val)
Base.getindex(o::Observable)
onany(f, os...)
Base.map!(f, o::Observable, os...)
connect!(o1::Observable, o2::Observable)
Base.map(f, o::Observable, os...; init)
```
