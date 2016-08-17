if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

@testset "widgets.jl" begin
    include("widgets.jl")
end

@testset "ijulia.jl" begin
    include("ijulia.jl")
end
