const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "https://www.gitcdn.xyz/repo/piever/InteractResources/v0.2.0/bulma/main.min.css",
    "https://www.gitcdn.xyz/repo/piever/InteractResources/v0.2.0/bulma/main_interactbulma.min.css",
]

for dep in deps
    download(dep, joinpath(_pkg_assets, splitdir(dep)[2]))
end
