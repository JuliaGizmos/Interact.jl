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

module HygieneTest2
    # Verify that `@manipulate` is really using Reactive.signal
    # and Reactive.preserve, not whatever the user has defined

    using Interact: @manipulate

    # Dummy implementations that should never be called:
    signal(x...) = error("I should not be called")
    preserve(x...) = error("I should not be called")

    @manipulate for i in 1:10, j in ["x", "y", "z"]
        2 * i, j * " hello"
    end
end

# Notebooks
# notebookdirs = [joinpath(@__DIR__, "notebooks"), joinpath(@__DIR__, "..", "doc", "notebooks")]
notebookdirs = [joinpath(@__DIR__, "..", "doc", "notebooks")] # Interact Manual Tests.ipynb is broken (flatten call)
for notebookdir in notebookdirs
    for file in readdir(notebookdir)
        name, ext = splitext(file)
        if lowercase(ext) == ".ipynb"
            @eval module $(gensym()) # Each notebook is run in its own module
                using Base.Test
                using NBInclude
                @testset "$($name)" begin
                    nbinclude(joinpath($notebookdir, $file), regex = r"^((?!\#NBSKIP).)*$"s) # Use #NBSKIP in a cell to skip it during tests
                end
            end
        end
    end
end

