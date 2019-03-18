using Test

using Interact

@test gettheme() == Interact.Bulma()
settheme!(:nativehtml)
@test gettheme() == InteractBase.NativeHTML()
settheme!(:bulma)
@test gettheme() == Interact.Bulma()
