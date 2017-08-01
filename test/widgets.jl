using Base.Test

using Interact
import Interact: parse_msg
import Reactive: value


sliderWidget = slider(1:5)
checkboxWidget = checkbox(false)
@testset "statedict" begin

    @test Dict(:range=>1:5,
               :value=>3,
               :readout_format=>"d",
               :readout=>true,
               :orientation=>"horizontal",
               :continuous_update=>true) == Interact.statedict(sliderWidget)
    @test Dict(:value=>false) == Interact.statedict(checkboxWidget)
end

@testset "parse" begin
    @test 3 == value(signal(sliderWidget))
    @test false == value(signal(checkboxWidget))

    @test 1 == parse_msg(sliderWidget, 1)
    @test 0 == parse_msg(sliderWidget, 0)

    @test 1 == parse_msg(checkboxWidget, 1)
    @test 0 == parse_msg(checkboxWidget, 0)
end
