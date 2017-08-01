# Composable Widget API

@compat abstract type WidgetMod <: Widget end

signal(w::WidgetMod) = signal(w.widget)

immutable Styled{W <: Widget} <: WidgetMod
    widget::W
    style::Dict
end

style(widget, style) = StyledWidget(widget, style)

immutable Labeled{W <: Widget} <: WidgetMod
    widget::W
    label::AbstractString
end

label(widget, label) = LabeledWidget(widget, label)

immutable WithClass{class, W <: Widget} <: WidgetMod
    widget::W
end

addclass(widget, class) = WithClass{symbol(class)}(widget)

@compat abstract type Container <: Widget end

immutable WidgetStack{direction} <: Container
    widgets::Vector{Widget}
end

hstack(widgets::Widget...) = WidgetStack{:x}([widget...])
vstack(widgets::Widget...) = WidgetStack{:y}([widget...])
zstack(widgets::Widget...) = WidgetStack{:z}([widget...])
