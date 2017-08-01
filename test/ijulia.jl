using Base.Test

using IJulia
using Interact

profile = normpath(dirname(@__FILE__), "profile.json")
IJulia.init([profile])
redirect_stdout(IJulia.orig_STDOUT[])
redirect_stderr(IJulia.orig_STDERR[])

include(Interact.ijulia_setup_path)

sliderWidget = slider(1:5)
@testset "ijulia.jl" begin

    removespaces(s) = replace(s, " ", "")
    # Julia v0.6 uses spaces after commas when printing types, but
    # previous versions did not. To ensure that this test works on all
    # versions, we just remove spaces from both sides of the comparison.
    @test removespaces("""Interact.Slider{Int64}($(string(signal(sliderWidget))),\"\",3,1:5,\"horizontal\",true,\"d\",true)""") == removespaces(stringmime("text/plain", sliderWidget))
    @test "3" == stringmime("text/plain", signal(sliderWidget))

    @test "" == stringmime("text/html", sliderWidget)


    close(IJulia.ctx[])
end
