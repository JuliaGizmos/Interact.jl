using Base.Test

include("widgets.jl")
include("ijulia.jl")

module HygieneTest
    # Test that the `@manipulate` macro does not rely on
    # any symbols from other packages (like Reactive or Interact)
    # being defined in the user's current namespace
    using Interact: @manipulate

    @manipulate for i in 1:10, j in ["x", "y", "z"]
        i, j
    end
end
