module Interact

using Reexport

@reexport using InteractBase
import InteractBase: notifications
import Widgets: Widget, @layout, @nodeps
import Observables: @on, @map!, @map

@reexport using DataStructures
@reexport using Observables
@reexport using Knockout
@reexport using CSSUtil
@reexport using WebIO
@reexport using Widgets

struct Bulma<:InteractBase.WidgetTheme; end

const notebookdir = joinpath(@__DIR__, "..", "doc", "notebooks")

const main_css = joinpath(@__DIR__, "..", "assets", "main.min.css")
const main_confined_css = joinpath(@__DIR__, "..", "assets", "main_confined.min.css")

function InteractBase.libraries(::Bulma)
    bulmalib = InteractBase.isijulia() ? main_confined_css : main_css
    vcat(InteractBase.font_awesome, InteractBase.style_css, bulmalib)
end

const themes = Dict(
    :nativehtml => InteractBase.NativeHTML(),
    :bulma => Bulma()
)

function InteractBase.settheme!(s::Symbol)
    (s in keys(themes)) || error("Theme $s is not supported")
    settheme!(themes[s])
end

function __init__()
    settheme!(:bulma)
    nothing
end

end
