if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

using IJulia
using Interact

profile = normpath(dirname(@__FILE__), "profile.json")
IJulia.init([profile])
redirect_stdout(IJulia.orig_STDOUT[])
redirect_stderr(IJulia.orig_STDERR[])

include(Interact.ijulia_setup_path)

sliderWidget = slider(1:5)
@testset "ijulia.jl" begin

    @test """Interact.Slider{Int64}(Signal{Int64}(3, nactions=1),\"\",3,1:5,\"horizontal\",true,\"d\",true)""" == stringmime("text/plain", sliderWidget)
    @test "3" == stringmime("text/plain", signal(sliderWidget))

    @test "" == stringmime("text/html", sliderWidget)


    close(IJulia.ctx[])
end
