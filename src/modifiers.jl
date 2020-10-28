"""
`tooltip!(wdg::AbstractWidget, tooltip; className = "")`

Experimental. Add a tooltip to widget wdg. `tooltip` is the text that will be shown and `className`
can be used to customize the tooltip, for example `is-tooltip-bottom` or `is-tooltip-danger`.
"""
function tooltip!(wdg::AbstractWidget, args...; kwargs...)
    tooltip!(node(wdg)::Node, args...; kwargs...)
    return wdg
end

function tooltip!(n::Node, tooltip; className = "")
    d = props(n)
    get!(d, :attributes, Dict{String, Any})
    get!(d, :className, "")
    d[:attributes]["data-tooltip"] = tooltip
    d[:className] = mergeclasses(d[:className], className, "tooltip")
    n
end
