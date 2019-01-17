using Documenter, Interact, Literate
src = joinpath(@__DIR__, "src")
Literate.markdown(joinpath(src, "tutorial.jl"), src, codefence = "```julia" => "```")

makedocs(
    sitename = "Interact",
    authors = "JuliaGizmos",
    pages = [
        "Introduction" => "index.md",
        "Observables" => "observables.md",
        "Widgets" => "widgets.md",
        "Custom widgets" => "custom_widgets.md",
        "Modifiers" => "modifiers.md",
        "Layout" => "layout.md",
        "Deploying the web app" => "deploying.md",
        "Tutorial" => "tutorial.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaGizmos/Interact.jl.git",
)
