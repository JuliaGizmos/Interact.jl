export @manipulate

function make_widget(binding)
    if binding.head != :(=)
        error("@manipulate syntax error.")
    end
    sym, expr = binding.args
    Expr(:(=), esc(sym),
         Expr(:call, widget, esc(expr), string(sym)))
end

function display_widgets(widgetvars)
    map(v -> Expr(:call, esc(:display), esc(v)), widgetvars)
end

function map_block(block, symbols)
    lambda = Expr(:(->), Expr(:tuple, symbols...),
                  block)
    :($preserve(map($(lambda), $(map(s->:($signal($s)), symbols)...), typ=Any)))
end

function symbols(bindings)
    map(x->x.args[1], bindings)
end

macro manipulate(expr)
    if expr.head != :for
        error("@manipulate syntax is @manipulate for ",
              " [<variable>=<domain>,]... <expression> end")
    end
    block = expr.args[2]
    if expr.args[1].head == :block
        bindings = expr.args[1].args
    else
        bindings = [expr.args[1]]
    end
    syms = symbols(bindings)
    Expr(:let, Expr(:block,
                    display_widgets(syms)...,
                    esc(map_block(block, syms))),
         map(make_widget, bindings)...)
end
