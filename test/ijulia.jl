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
redirect_stdout(IJulia.orig_STDOUT)
redirect_stderr(IJulia.orig_STDERR)

include(Interact.ijulia_setup_path)

sliderWidget = slider(1:5)

@test """Interact.Slider{Int64}(Signal{Int64}(3, nactions=0),"",3,1:5,"d",true)""" == stringmime("text/plain", sliderWidget)
@test "3" == stringmime("text/plain", signal(sliderWidget))

@test "" == stringmime("text/html", sliderWidget)


close(IJulia.ctx)
