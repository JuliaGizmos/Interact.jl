using Test

using Interact

@test gettheme() == InteractBulma.Bulma()
settheme!(:nativehtml)
@test gettheme() == InteractBase.NativeHTML()
settheme!(:bulma)
@test gettheme() == InteractBulma.Bulma()
