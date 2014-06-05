
using React
using JSON

abstract InputWidget{T}  # A widget that takes input of type T


type Slider{T <: Number} <: InputWidget{T}
    value :: T
    label :: String
    range :: (T, T)
    step  :: T
end


type Checkbox <: InputWidget{Bool}
    value :: Bool
    label :: String
end


type ToggleButton <: InputWidget{Symbol}
    value   :: Input{Symbol}
    options :: (Symbol, Symbol)
end


type Button <: InputWidget{()}
    value :: ()
end


type Text{T} <: InputWidget{T}
    value :: T
end


type Textarea{String} <: InputWidget{String}
    value :: String
end


type NumberText{T <: Number} <: InputWidget{T}
    value :: T
    range :: (T, T)
end


type RadioButtons <: InputWidget{Symbol}
    value :: Symbol
    options :: Vector{Symbol}
end


type Dropdown <: InputWidget{Symbol}
    value :: Symbol
    options :: Vector{Symbol}
end


type HTML <: InputWidget{String}
    value :: String
end


type Latex <: InputWidget{String}
    value :: String
end


function parse{T}(msg, ::InputWidget{T})
    # Should return a value of type T, by default
    # msg itself is assumed to be the value.
    return msg :: T
end

# Should we enforce a one-to-one mapping?
# Having multiple inputs might allow for unnecessarily complex stateful code?
const inputs = Dict{InputWidget, Set{Input}}


function attach!{T}(widget :: InputWidget{T}, input :: Input{T})
    if ~haskey(inputs, widget)
        inputs[widget] = Set{Input{T}}()
    end
    add(inputs[widget], input)
end


function detach!{T}(widget :: InputWidget{T}, input :: Input{T})
    if haskey(inputs, widget)
        try
            pop!(inputs[widget], input)
        catch
        end
    end
end


function detach!{T}(widget :: InputWidget{T})
    if haskey(inputs, widget)
        empty!(inputs[widget])
    end
end


function detach!{T}(input :: Input{T})
    map((w, set) -> detach(w, input), inputs)
end


function recv{T}(widget :: InputWidget{T}, value :: T)
    # Hand-off received value to the signal graph
    if haskey(inputs, widget)
        map(input -> push!(input, value), inputs[widget])
    else
        warn("Received an update for a widget with no attached Input")
    end
end


end # module
