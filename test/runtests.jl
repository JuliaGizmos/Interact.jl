using Test

using Interact

@test gettheme() == Interact.Bulma()
settheme!(:nativehtml)
@test gettheme() == InteractBase.NativeHTML()
settheme!(:bulma)
@test gettheme() == Interact.Bulma()

@test isfile(Interact.main_css)
@test isfile(Interact.main_interactbulma_css)

@test first(eachline(Interact.main_css))[1:20] == "/*! bulma.io v0.7.4 "
@test first(eachline(Interact.main_interactbulma_css))[1:20] == ".interact-widget{/*!"

@test length(InteractBase.libraries(Interact.Bulma())) == 3
@test all(isfile, InteractBase.libraries(Interact.Bulma()))
