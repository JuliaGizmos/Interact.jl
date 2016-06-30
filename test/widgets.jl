if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

using Interact
import Interact: statedict, parse_msg
import Reactive: value


sliderWidget = slider(1:5)

@test Dict(:range=>1:5,
           :value=>3,
           :readout_format=>"d",
           :continuous_update=>true) == statedict(sliderWidget)
@test 3 == value(signal(sliderWidget))
@test 1 == parse_msg(sliderWidget, 1)
@test 0 == parse_msg(sliderWidget, 0)


checkboxWidget = checkbox(false)
@test Dict(:value=>false) == statedict(checkboxWidget)
@test false == value(signal(checkboxWidget))

@test 1 == parse_msg(checkboxWidget, 1)
@test 0 == parse_msg(checkboxWidget, 0)
