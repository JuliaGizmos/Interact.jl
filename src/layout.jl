center(w) = flex_row(w)
center(w::Widget) = w
center(w::Widget{:toggle}) = flex_row(w)

manipulatelayout(::WidgetTheme) = t -> node(:div, map(center, values(components(t)))..., map(center, t.output))

function widget(::WidgetTheme, x::Observable; label = nothing)
    if label === nothing
        x
    else
        Widget{:observable}(["label" => label], output = x, layout = t -> flex_row(t["label"], t.output))
    end
end
