@compat Interact.statedict(s::Union{Slider, Progress}) =
    @compat Dict(:value=>s.value,
         :min=>first(s.range),
         :step=>step(s.range),
         :max=>last(s.range),
         :continuous_update=>s.continuous_update,
     )

# when we say value to javascript, it really means value label
Interact.statedict(d::Options) =
    @compat Dict(:selected_label=>d.value_label,
         :icons=>d.icons,
         :tooltips=>d.tooltips,
         :_options_labels=>collect(keys(d.options)))
