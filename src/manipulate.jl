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
    :(preserve(map($(esc(lambda)), $(map(s->:(signal($s)), esc.(symbols))...), typ=Any)))
end

function symbols(bindings)
    map(x->x.args[1], bindings)
end

@static if VERSION >= v"0.7.0-DEV.1671"
    function make_let_block(declarations, statements)
        Expr(:let, Expr(:block, declarations...), Expr(:block, statements...))
    end
else
    function make_let_block(declarations, statements)
        Expr(:let, Expr(:block, statements...), declarations...)
    end
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
    declarations = map(make_widget, bindings)
    statements = vcat(display_widgets(syms)...,
                      map_block(block, syms))
    make_let_block(declarations, statements)
end
