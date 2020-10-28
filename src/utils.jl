import WebIO: camel2kebab

# Get median elements of ranges, used for initialising sliders.
# Differs from median(r) in that it always returns an element of the range
medianidx(r) = (1+length(r)) ÷ 2
medianelement(r::AbstractArray) = r[medianidx(r)]
medianval(r::AbstractDict) = medianelement(collect(values(r)))
medianelement(r::AbstractDict) = medianval(r)

_values(r::AbstractArray) = r
_values(r::AbstractDict) = values(r)

_keys(r::AbstractArray) = 1:length(r)
_keys(r::AbstractDict) = keys(r)

inverse_dict(d::AbstractDict) = Dict(zip(values(d), keys(d)))

const Propkey = Union{Symbol, String}
const PropDict = Dict{Propkey, Any}

function slap_design!(w::Scope, args)
    for arg in args
        import!(w, arg)
    end
    w
end

slap_design!(w::Scope, args::AbstractString...) = slap_design!(w::Scope, args)

slap_design!(w::Scope, args::WidgetTheme = gettheme()) =
    slap_design!(w::Scope, libraries(args))

slap_design!(n::Node, args...) = slap_design!(Scope()(n), args...)

slap_design!(w::Widget, args...) = (slap_design!(scope(w), args...); w)

isijulia() = isdefined(Main, :IJulia) && Main.IJulia.inited
