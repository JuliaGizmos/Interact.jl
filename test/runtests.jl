using Test

using Interact
using Random
using Colors
using Dates
import Interact: widgettype
import Widgets: components

@test gettheme() == Interact.Bulma()
settheme!(:nativehtml)
@test gettheme() == Interact.NativeHTML()
settheme!(:bulma)
@test gettheme() == Interact.Bulma()

@test isfile(Interact.bulma_css)
@test isfile(Interact.bulma_confined_css)

@test first(eachline(Interact.bulma_css))[1:20] == "/*! bulma.io v0.7.4 "
@test first(eachline(Interact.bulma_confined_css))[1:20] == ".interact-widget{/*!"

@test length(Interact.libraries(Interact.Bulma())) == 3
@test all(isfile, Interact.libraries(Interact.Bulma()))

include("test_observables.jl")
include("test_theme.jl")
include("test_deps.jl")