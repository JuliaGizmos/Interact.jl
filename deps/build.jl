const _pkg_root = dirname(dirname(@__FILE__))
const _pkg_assets = joinpath(_pkg_root,"assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.4.0/bulma/main.min.css" => "bulma.min.css",
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.4.0/bulma/main_confined.min.css" => "bulma_confined.min.css",
    "https://use.fontawesome.com/releases/v5.0.7/js/all.js" => "all.js",
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.1.0/highlight/prism.css" => "prism.css",
    "https://cdn.jsdelivr.net/gh/piever/InteractResources@0.1.0/highlight/prism.js" => "prism.js",
    "https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.js" => "nouislider.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.css" => "nouislider.min.css",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js" => "katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css" => "katex.min.css"
]

for (dep, name) in deps
    download(dep, joinpath(_pkg_assets, name))
end
