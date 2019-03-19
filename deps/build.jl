const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "https://www.gitcdn.xyz/repo/piever/InteractResources/master/bulma/main.min.css",
    "https://www.gitcdn.xyz/repo/piever/InteractResources/master/bulma/main_confined.min.css",
]

for dep in deps
    download(dep, joinpath(_pkg_assets, splitdir(dep)[2]))
end
