@compat Interact.statedict(s::Union{Slider, Progress}) =
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
Interact.statedict(d::Options) =
    @compat Dict(:selected_label=>d.value_label,
         :value => d.value_label,
         :icons=>d.icons,
         :tooltips=>d.tooltips,
         :_options_labels=>collect(keys(d.options)))

function statedict(w::Widget)
    # @compat Dict(f => getfield(w, f) for f in fieldnames(w))
    # Julia issue #16561
    #       commit 879a7f75c7096aec4aa1b0c2a93a3ef432bb4cef
    dict = Dict{Symbol,Any}()
    for f in fieldnames(w)
       dict[f] = getfield(w, f)
    end
    dict
end
