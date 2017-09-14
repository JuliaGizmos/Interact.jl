viewdict(s::Union{Slider, Progress}) =
    Dict{Symbol, Any}(:orientation => s.orientation)

viewdict(d::Options) =
    Dict{Symbol, Any}(:tooltips => d.tooltips,
                    :orientation => d.orientation)

viewdict(b::Box) = begin
   Dict{Symbol, Any}(:layout => "IPY_MODEL_"*widget_comms[b.layout].id)
end

@compat statedict(s::Union{Slider, Progress}) =
    @compat Dict(:value=>s.value,
         :min=>first(s.range),
         :step=>step(s.range),
         :max=>last(s.range),
         :model_name => "FloatSliderModel",
         :_model_name => "FloatSliderModel",
         :readout => s.readout,
         :readout_format => s.readout_format,
         :continuous_update=>s.continuous_update,
     )

#each layout has a child box which has child widgets
statedict(l::Layout) = begin
   state = Dict{Symbol, Any}(:display => "flex", :align_items => "stretch")
   l.box.vert && (state[:flex_flow] = "column")
   state
end

statedict(b::Box) = begin
   child_comm_ids = map(b.children) do childw
      haskey(widget_comms, childw) ?
         widget_comms[childw] :
         create_view(childw)
   end
   state = Dict{Symbol, Any}(:children =>
      map(comm_id -> "IPY_MODEL_"*comm_id.id, child_comm_ids))
   state
end

# when we say value to javascript, it really means value label
statedict(d::Options) =
    @compat Dict(:selected_label=>d.value_label,
         :value => d.value_label,
         :index => d.index-1,
         :icons=>d.icons,
         :tooltips=>d.tooltips,
         :readout => d.readout,
         :_options_labels=>collect(keys(d.options)))

statedict(w::Widget) = begin
    # @compat Dict(f => getfield(w, f) for f in fieldnames(w))
    # Julia issue #16561
    #       commit 879a7f75c7096aec4aa1b0c2a93a3ef432bb4cef
    dict = Dict{Symbol,Any}()
    for f in fieldnames(w)
       dict[f] = getfield(w, f)
    end
    dict
end
