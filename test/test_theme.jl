using Interact: registertheme!, Bulma, NativeHTML

struct MyTheme<:Interact.WidgetTheme; end
registertheme!(:mytheme, MyTheme())

@testset "theme" begin
    @test gettheme() == Bulma()
    settheme!(MyTheme())
    @test gettheme() == MyTheme()
    resettheme!()
    @test gettheme() == Bulma()
    settheme!("mytheme")
    @test gettheme() == MyTheme()
    settheme!(:nativehtml)
    @test gettheme() == NativeHTML()
    settheme!(:bulma)
    @test gettheme() == Bulma()
    @test availablethemes() == [:bulma, :mytheme, :nativehtml]
    @test_throws ErrorException settheme!("not a theme")
end
