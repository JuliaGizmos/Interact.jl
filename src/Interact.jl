module Interact

using Reexport

@reexport using InteractBase
import InteractBase: notifications
import Widgets: Widget, @layout, @nodeps
import Observables: @on, @map!, @map

@reexport using OrderedCollections
@reexport using Observables
@reexport using Knockout
@reexport using CSSUtil
@reexport using WebIO
@reexport using Widgets

struct Bulma<:InteractBase.WidgetTheme; end

const notebookdir = joinpath(@__DIR__, "..", "doc", "notebooks")

const bulma_css = joinpath(@__DIR__, "..", "assets", "bulma.min.css")
const bulma_confined_css = joinpath(@__DIR__, "..", "assets", "bulma_confined.min.css")

function InteractBase.libraries(::Bulma)
    bulmalib = InteractBase.isijulia() ? bulma_confined_css : bulma_css
    vcat(InteractBase.font_awesome, InteractBase.style_css, bulmalib)
end

function InteractBase.slap_design!(widget::Scope, ::Bulma)
    InteractBase.isijulia() ? import!(widget, bulma_confined_css) : import!(widget, bulma_css)
    import!(widget, InteractBase.style_css)
    jsasset = WebIO.JSAsset(InteractBase.font_awesome)
    onmount(widget, js"""
        function() {
            if (document.querySelector("fa") === null) {
                $jsasset
            }
        }
        """
    )
    return widget
end

function __init__()
    InteractBase.registertheme!(:bulma, Bulma())
    settheme!(Bulma())
    nothing
end

end
