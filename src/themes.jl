Base.@deprecate_binding backend Widgets.backends

const themes = OrderedDict{Symbol, WidgetTheme}(:bulma => Bulma(), :nativehtml => NativeHTML())

registertheme!(key::Union{Symbol, AbstractString}, val::WidgetTheme) = setindex!(themes, val, Symbol(key))

"""
`settheme!(s::Union{Symbol, AbstractString})`

Set theme of Interact globally. See `availablethemes()` to know what themes are currently available.
"""
function settheme!(s::Union{Symbol, AbstractString})
    theme = get(themes, Symbol(s)) do
        error("Theme $s is not available.")
    end
    settheme!(theme)
end

settheme!(b::WidgetTheme) = isa(Widgets.get_backend(), WidgetTheme) && Widgets.set_backend!(b)
gettheme() = isa(Widgets.get_backend(), WidgetTheme) ? Widgets.get_backend() : nothing
availablethemes() = sort(collect(keys(themes)))
resettheme!() = isa(Widgets.get_backend(), WidgetTheme) && Widgets.reset_backend!()
