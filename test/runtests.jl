using Test

using Interact

@test gettheme() == Interact.InteractBulma.Bulma()
settheme!(:nativehtml)
@test gettheme() == Interact.InteractBase.NativeHTML()
settheme!(:bulma)
@test gettheme() == Interact.InteractBulma.Bulma()
