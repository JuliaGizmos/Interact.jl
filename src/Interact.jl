module Interact

using Reexport

import Widgets: Widget, @layout, @nodeps
import Observables: @on, @map!, @map

@reexport using OrderedCollections
@reexport using Observables
@reexport using Knockout
@reexport using CSSUtil
@reexport using WebIO
@reexport using Widgets

using Colors, JSExpr
import Observables: ObservablePair, AbstractObservable
import JSExpr: JSString
using Random
using Dates
using Base64: stringmime
using JSON
using Knockout: js_lambda
import Widgets:
    observe,
    AbstractWidget,
    div,
    Widget,
    widget,
    widgettype,
    @layout!,
    components,
    input,
    spinbox,
    textbox,
    textarea,
    autocomplete,
    datepicker,
    timepicker,
    colorpicker,
    checkbox,
    toggle,
    filepicker,
    opendialog,
    savedialog,
    slider,
    rangeslider,
    rangepicker,
    button,
    dropdown,
    radiobuttons,
    checkboxes,
    toggles,
    togglebuttons,
    tabs,
    entry,
    latex,
    alert,
    highlight,
    notifications,
    confirm,
    togglecontent,
    tabulator,
    accordion,
    mask,
    tooltip!,
    wdglabel,
    slap_design!,
    @manipulate,
    manipulatelayout,
    triggeredby,
    onchange

import Observables: throttle

export observe, Widget, widget
export @manipulate
export filepicker, opendialog, savedialog, datepicker, timepicker, colorpicker, spinbox
export autocomplete, input, dropdown, checkbox, textbox, textarea, button, toggle, togglecontent
export slider, rangeslider, rangepicker
export radiobuttons, togglebuttons, tabs, checkboxes, toggles
export latex, alert, confirm, highlight, notifications, accordion, tabulator, mask
export onchange
export settheme!, resettheme!, gettheme, availablethemes, NativeHTML
export slap_design!

abstract type WidgetTheme<:Widgets.AbstractBackend; end
struct NativeHTML<:WidgetTheme; end
struct Bulma<:WidgetTheme; end

libraries(::WidgetTheme) = [style_css]

function libraries(::Bulma)
    bulmalib = isijulia() ? bulma_confined_css : bulma_css
    vcat(font_awesome, style_css, bulmalib)
end

const font_awesome = joinpath(@__DIR__, "..", "assets", "all.js")
const prism_js = joinpath(@__DIR__, "..", "assets", "prism.js")
const prism_css = joinpath(@__DIR__, "..", "assets", "prism.css")
const highlight_css = joinpath(@__DIR__, "..", "assets", "highlight.css")
const nouislider_min_js = joinpath(@__DIR__, "..", "assets", "nouislider.min.js")
const nouislider_min_css = joinpath(@__DIR__, "..", "assets", "nouislider.min.css")
const style_css = joinpath(@__DIR__, "..", "assets", "style.css")

const notebookdir = joinpath(@__DIR__, "..", "doc", "notebooks")
const bulma_css = joinpath(@__DIR__, "..", "assets", "bulma.min.css")
const bulma_confined_css = joinpath(@__DIR__, "..", "assets", "bulma_confined.min.css")

include("classes.jl")
include("themes.jl")
include("utils.jl")
include("input.jl")
include("slider.jl")
include("optioninput.jl")
include("layout.jl")
include("output.jl")
include("modifiers.jl")

function __init__()
    Widgets.set_backend!(Bulma())
end

end
