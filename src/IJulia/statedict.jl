statedict(s::Union(Slider, Progress)) =
    {:value=>s.value,
     :min=>first(s.range),
     :step=>step(s.range),
     :max=>last(s.range)}

# when we say value to javascript, it really means value label
statedict(d::Options) =
    {:value_name=>d.value_label,
     :value_names=>collect(keys(d.options))}
