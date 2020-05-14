using WebIO, JSExpr

const katex_min_js = joinpath(@__DIR__, "..", "assets", "katex.min.js")

const katex_min_css = joinpath(@__DIR__, "..", "assets", "katex.min.css")

"""
`latex(txt)`

Render `txt` in LaTeX using KaTeX. Backslashes need to be escaped:
`latex("\\\\sum_{i=1}^{\\\\infty} e^i")`
"""
function latex(::WidgetTheme, txt)
    (txt isa AbstractObservable) || (txt = Observable(txt))
    w = Scope(imports=[
        katex_min_js,
        katex_min_css
    ])

    w["value"] = txt

    onimport(w, @js function (k)
        this.k = k
        this.container = this.dom.querySelector("#container")
        k.render($(txt[]), this.container)
    end)

    onjs(w["value"], @js (txt) -> this.k.render(txt, this.container))

    w.dom = dom"div#container"()

    Widget{:latex}(scope = w, output = w["value"], layout = node(:div, className = "interact-widget")∘Widgets.scope)
end

"""
`alert(text="")`

Creates a `Widget{:alert}`. To cause it to trigger an alert, do:

```julia
wdg = alert("Error!")
wdg()
```

Calling `wdg` with a string will set the alert message to that string before triggering the alert:

```julia
wdg = alert("Error!")
wdg("New error message!")
```

For the javascript to work, the widget needs to be part of the UI, even though it is not visible.
"""
function alert(::WidgetTheme, text = ""; value = text)
    value isa AbstractObservable || (value = Observable(value))

    scp = WebIO.Scope()
    setobservable!(scp, "text", value)
    onjs(
        scp["text"],
        js"""function (value) {
            alert(value);
        }"""
    )
    Widget{:alert}(["text" => value]; scope = scp,
    layout = t -> node(:div, Widgets.scope(t), style = Dict("display" => "none")))
end

(wdg::Widget{:alert})(text = wdg["text"][]) = (wdg["text"][] = text; return)

"""
`confirm([f,] text="")`

Creates a `Widget{:confirm}`. To cause it to trigger a confirmation dialogue, do:

```julia
wdg = confirm([f,] "Are you sure you want to unsubscribe?")
wdg()
```

`observe(wdg)` is a `Observable{Bool}` and is set to `true` if the user clicks on "OK" in the dialogue,
or to false if the user closes the dialogue or clicks on "Cancel". When `observe(wdg)` is set, the function `f`
will be called with that value.

Calling `wdg` with a string and/or a function will set the confirmation message and/or the callback function:

```julia
wdg = confirm("Are you sure you want to unsubscribe?")
wdg("File exists, overwrite?") do x
   x ? print("Overwriting") : print("Aborting")
end
```

For the javascript to work, the widget needs to be part of the UI, even though it is not visible.
"""
function confirm(::WidgetTheme, fct::Function = x -> nothing, text::AbstractString = "")
    text isa AbstractObservable || (text = Observable(text))

    scp = WebIO.Scope()
    setobservable!(scp, "text", text)
    value = Observable(scp, "value", false)
    onjs(
        scp["text"],
        @js function (txt)
            $value[] = confirm(txt)
        end
    )
    wdg = Widget{:confirm}(["text" => text, "function" => fct]; scope = scp, output = value,
    layout = t -> node(:div, Widgets.scope(t), style = Dict("visible" => false)))
    on(x -> wdg["function"](x), value)
    wdg
end

confirm(T::WidgetTheme, text::AbstractString, fct::Function = x -> nothing) = confirm(T, fct, text)

function (wdg::Widget{:confirm})(fct::Function = wdg["function"], text::AbstractString = wdg["text"][])
   wdg["function"] = fct
   wdg["text"][] = text
   return
end

(wdg::Widget{:confirm})(text::AbstractString, fct::Function = wdg["function"]) = wdg(fct, text)

"""
`highlight(txt; language = "julia")`

`language` syntax highlighting for `txt`.
"""
function highlight(::WidgetTheme, txt; language = "julia")
    (txt isa AbstractObservable) || (txt = Observable(txt))

    s = "code"*randstring(16)

    w = Scope(imports = [
       highlight_css,
       prism_js,
       prism_css,
    ])

    w["value"] = txt

    w.dom = node(
        :div,
        node(
            :pre,
            node(:code, className = "language-$language", attributes = Dict("id"=>s))
        ),
        className = "content"
    )

    onimport(w, js"""
        function (p) {
            var code = document.getElementById($s);
            code.innerHTML = $(txt[]);
            Prism.highlightElement(code);
        }
    """
    )

    onjs(w["value"], js"""
      function (val){
          var code = document.getElementById($s);
          code.innerHTML = val
          Prism.highlightElement(code)
      }
   """)

    Widget{:highlight}(scope = w, output = w["value"], layout = node(:div, className = "interact-widget")∘Widgets.scope)
end

"""
`notifications(v=[]; layout = node(:div))`

Display elements of `v` inside notification boxes that can be closed with a close button.
The elements are laid out according to `layout`.
`observe` on this widget returns the observable of the list of elements that have not been deleted.
"""
function notifications(::WidgetTheme, v=[]; container = node(:div),
    wrap = identity,
    layout = (v...)->container((wrap(el) for el in v)...),
    className = "")
    scope = Scope()
    output = Observable{Any}(v)
    to_delete = Observable(scope, "to_delete", 0)
    on(to_delete) do ind
        v = output[]
        deleteat!(v, ind)
        output[] = v
    end
    className = mergeclasses(className, "notification")
    list = map(output) do t
        function create_item(ind, el)
            btn = node(:button, className = "delete", events = Dict("click" =>
                @js event -> $to_delete[] = $ind))
            node(:div, btn, el, className = className)
        end
        [create_item(ind, el) for (ind, el) in enumerate(t)]
    end

    scope.dom = map(v -> layout(v...), list)
    slap_design!(scope)
    
    Widget{:notifications}([:list => list]; output = output, scope = scope,
        layout = _ -> node(:div, scope, className="interact-widget"))
end

"""
`accordion(options; multiple = true)`

Display `options` in an `accordion` menu. `options` is an `AbstractDict` whose
keys represent the labels and whose values represent what is shown in each entry.

`options` can be an `Observable`, in which case the `accordion` updates as soon as
`options` changes.
"""
function accordion(::WidgetTheme, options::Observable;
    multiple = true, value = nothing, index = value, key = automatic)

    vals2idxs = map(Vals2Idxs∘collect∘_keys, options)
    p = initvalueindex(key, index, vals2idxs, rev = true, multiple = multiple)
    key, index = p.first, p.second

    option_array = map(x -> [OrderedDict("label" => key, "i" => i, "content" => stringmime(MIME"text/html"(), WebIO.render(val))) for (i, (key, val)) in enumerate(x)], options)

    onClick = multiple ? js"function (i) {this.index.indexOf(i) > -1 ? this.index.remove(i) : this.index.push(i)}" :
        js"function (i) {this.index(i)}"

    isactive = multiple ? "\$root.index.indexOf(i) > -1" : "\$root.index() == i"
    updateSelected = js_lambda("\$root.onClick(i)")
    template = dom"section.accordions"(attributes = Dict("data-bind" => "foreach: options_js"),
        node(:article, className="accordion", attributes = Dict("data-bind" => "css: {'is-active' : $isactive}", ))(
            dom"div.accordion-header.toggle"(dom"p"(attributes = Dict("data-bind" => "html: label")), attributes = Dict("data-bind" => "click: $updateSelected")),
            dom"div.accordion-body"(dom"div.accordion-content"(attributes = Dict("data-bind" => "html: content")))
        )
    )
    scp = knockout(template, ["index" => index, "options_js" => option_array], methods = Dict("onClick" => onClick))
    slap_design!(scp)
    Widget{:accordion}(["index" => index, "key" => key, "options" => options]; scope = scp, output = index, layout = node(:div, className = "interact-widget")∘Widgets.scope)
end

accordion(T::WidgetTheme, options; kwargs...) = accordion(T, Observable{Any}(options); kwargs...)

"""
`togglecontent(content, value::Union{Bool, Observable}=false; label)`

A toggle switch that, when activated, displays `content`
e.g. `togglecontent(checkbox("Yes, I am sure"), false, label="Are you sure?")`
"""
function togglecontent(::WidgetTheme, content, args...; skip = 0em, vskip = skip, kwargs...)
    btn = toggle(gettheme(), args...; kwargs...)
    Widgets.scope(btn).dom =  node(:div,
        Widgets.scope(btn).dom,
        node(:div,
            content,
            attributes = Dict("data-bind" => "visible: value")
        ),
        className = "interact-widget",
        style = Dict("display" => "flex", "flex-direction"=>"column")
    )
    Widget{:togglecontent}(btn)
end

"""
`mask(options; index, key)`

Only display the `index`-th element of `options`. If `options` is a `AbstractDict`, it is possible to specify
which option to show using `key`. `options` can be a `Observable`, in which case `mask` updates automatically.
Use `index=0` or `key = nothing` to not have any selected option.

## Examples

```julia
wdg = mask(OrderedDict("plot" => plot(rand(10)), "scatter" => scatter(rand(10))), index = 1)
wdg = mask(OrderedDict("plot" => plot(rand(10)), "scatter" => scatter(rand(10))), key = "plot")
```

Note that the `options` can be modified from the widget directly:

```julia
wdg[:options][] = ["c", "d", "e"]
```
"""
function mask(::WidgetTheme, options; value = nothing, index = value, key = automatic, multiple = false)

    options isa AbstractObservable || (options = Observable{Any}(options))
    vals2idxs = map(Vals2Idxs∘collect∘_keys, options)
    p = initvalueindex(key, index, vals2idxs, rev = true, multiple = multiple)
    key, index = p.first, p.second

    ui = map(options) do val
        v = _values(val)
        nodes = (node(:div, el,  attributes = Dict("data-bind" => "visible: index() == $i")) for (i, el) in enumerate(v))
        knockout(node(:div, nodes...), ["index" => index])
    end
    Widget{:mask}(["index" => index, "key" => key, "options" => options];
        output = index, layout = t -> ui)
end


"""
`tabulator(options::AbstractDict; index, key)`

Creates a set of toggle buttons whose labels are the keys of options. Displays the value of the selected option underneath.
Use `index::Int` to select which should be the index of the initial option, or `key::String`.
The output is the selected `index`. Use `index=0` to not have any selected option.

## Examples

```julia
tabulator(OrderedDict("plot" => plot(rand(10)), "scatter" => scatter(rand(10))), index = 1)
tabulator(OrderedDict("plot" => plot(rand(10)), "scatter" => scatter(rand(10))), key = "plot")
```

`tabulator(values::AbstractArray; kwargs...)`

`tabulator` with labels `values`
see `tabulator(options::AbstractDict; ...)` for more details

```
tabulator(options::Observable; navbar=tabs, kwargs...)
```

Tabulator whose `options` are a given `Observable`. Set the `Observable` to some other
value to update the options in real time. Defaults to `navbar=tabs`: use `navbar=togglebuttons`
to have buttons instead of tabs.

## Examples

```julia
options = Observable(["a", "b", "c"])
wdg = tabulator(options)
options[] = ["c", "d", "e"]
```

Note that the `options` can be modified from the widget directly:

```julia
wdg[:options][] = ["c", "d", "e"]
```
"""
function tabulator(T::WidgetTheme, options; navbar = tabs, skip = 1em, vskip = skip, value = nothing, index = value, key = automatic,  kwargs...)
    options isa AbstractObservable || (options = Observable{Any}(options))
    vals2idxs = map(Vals2Idxs∘collect∘_keys, options)
    p = initvalueindex(key, index, vals2idxs, rev = true)
    key, index = p.first, p.second

    d = map(t -> OrderedDict(zip(parent(t), 1:length(parent(t)))), vals2idxs)
    buttons = navbar(T, d; index = index, readout = false, kwargs...)
    content = mask(options; index = index)

    layout = t -> div(t[:navbar], CSSUtil.vskip(vskip), t[:content], className = "interact-widget")
    Widget{:tabulator}(["index" => index, "key" => key, "navbar" => buttons, "content" => content, "options" => options];
        output = index, layout = layout)
end
