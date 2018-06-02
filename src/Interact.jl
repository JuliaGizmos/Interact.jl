__precompile__()

module Interact

using Reexport

@reexport using InteractBase

import InteractUIkit, InteractBulma

const themes = Dict(
    :uikit => InteractUIkit.UIkit(),
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
