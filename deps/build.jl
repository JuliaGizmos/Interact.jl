const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.4.0/bulma/main.min.css" => "bulma.min.css",
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.4.0/bulma/main_confined.min.css" => "bulma_confined.min.css",
]

for (dep, name) in deps
    download(dep, joinpath(_pkg_assets, name))
end
