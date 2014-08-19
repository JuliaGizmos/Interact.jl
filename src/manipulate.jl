export @manipulate

function make_widget(spec::Expr, m::Module)
    if spec.head != :in ||
        !isa(spec.args[1], Symbol)
        error("Widget spec must be of the form <symbol> in <domain>")
    end
    sym    = spec.args[1]
    label  = string(sym)
    domain = eval(m, spec.args[2])
    if isa(domain, Widget)
        return sym, domain
    elseif isa(domain, Range)
        return sym, Slider(domain, label=label)
    elseif isa(domain, Tuple) || isa(domain, Vector)
        return sym, ToggleButtons(domain, label=label)
    elseif isa(domain, Bool)
        return sym, Checkbox(value=domain, label=label)
    elseif isa(domain, String)
        return sym, Textbox(domain, label=label)
    else
        # XXX: What can be done?
        error("There is no widget for the value ", domain)
    end
end

macro manipulate(ex, specs...)
    m = current_module()
    mapping = map(s->make_widget(s, m), specs)
    fst(t) = t[1]
    snd(t) = t[2]
    widgets = map(snd, mapping)
    result = Expr(:call, :lift,
                  Expr(:->,
                       Expr(:tuple, map(fst, mapping)...), ex),
                  map(signal, widgets)...)
    # TODO: `hstack` widgets instead of just display()-ing them
    return Expr(:block,
                map(w -> Expr(:call, :display, w), widgets)...,
                esc(result))
end
