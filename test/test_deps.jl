font_awesome = joinpath(@__DIR__, "..", "assets", "all.js")
prism_js = joinpath(@__DIR__, "..", "assets", "prism.js")
prism_css = joinpath(@__DIR__, "..", "assets", "prism.css")
highlight_css = joinpath(@__DIR__, "..", "assets", "highlight.css")
nouislider_min_js = joinpath(@__DIR__, "..", "assets", "nouislider.min.js")
nouislider_min_css = joinpath(@__DIR__, "..", "assets", "nouislider.min.css")
style_css = joinpath(@__DIR__, "..", "assets", "style.css")

@testset "deps" begin
    @test isfile(font_awesome)
    @test isfile(prism_js)
    @test isfile(prism_css)
    @test isfile(highlight_css)
    @test isfile(nouislider_min_js)
    @test isfile(nouislider_min_css)
    @test isfile(style_css)
end
