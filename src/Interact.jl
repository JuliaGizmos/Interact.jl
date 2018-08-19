__precompile__()

module Interact

using Reexport

@reexport using InteractBase
import InteractBase: notifications
import InteractBulma
import Widgets: Widget, @layout, @nodeps
import Observables: @on, @map!, @map

@reexport using DataStructures
@reexport using Observables
@reexport using Knockout
@reexport using CSSUtil
@reexport using WebIO
@reexport using Widgets

const notebookdir = joinpath(@__DIR__, "..", "doc", "notebooks")

const themes = Dict(
    :nativehtml => InteractBase.NativeHTML(),
    :bulma => InteractBulma.Bulma()
)

function InteractBase.settheme!(s::Symbol)
    (s in keys(themes)) || error("Theme $s is not supported")
    settheme!(themes[s])
end

function __init__()
    empty!(InteractBase.backend)
    settheme!(:bulma)
    nothing
end

end
