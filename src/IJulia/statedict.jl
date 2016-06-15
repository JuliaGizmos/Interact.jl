@compat statedict(s::Union{Slider, Progress}) =
    @compat Dict(:value=>s.value,
         :min=>first(s.range),
         :step=>step(s.range),
         :max=>last(s.range),
         :model_name => "FloatSliderModel",
         :_model_name => "FloatSliderModel",
         :readout_format => s.readout_format,
         :continuous_update=>s.continuous_update,
     )

# when we say value to javascript, it really means value label
statedict(d::Options) =
    @compat Dict(:selected_label=>d.value_label,
         :value => d.value_label,
         :icons=>d.icons,
         :tooltips=>d.tooltips,
         :_options_labels=>collect(keys(d.options)))

statedict(w::Widget) =
    @compat Dict([f => getfield(w, f) for f in fieldnames(w)])
