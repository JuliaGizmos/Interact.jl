using Test

using Interact

@test gettheme() == Interact.Bulma()
settheme!(:nativehtml)
@test gettheme() == InteractBase.NativeHTML()
settheme!(:bulma)
@test gettheme() == Interact.Bulma()

@test isfile(Interact.bulma_css)
@test isfile(Interact.bulma_confined_css)

@test first(eachline(Interact.bulma_css))[1:20] == "/*! bulma.io v0.7.4 "
@test first(eachline(Interact.bulma_confined_css))[1:20] == ".interact-widget{/*!"

@test length(InteractBase.libraries(Interact.Bulma())) == 3
@test all(isfile, InteractBase.libraries(Interact.Bulma()))
