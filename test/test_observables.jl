@testset "input" begin
    a = Interact.input()
    @test widgettype(a) == :input
    @test observe(a)[] == ""
    a = Interact.input(typ = "number");
    @test observe(a)[] == 0
    s = Observable{Any}(12)
    a = Interact.input(s, typ = "number");
    @test observe(a)[] == s[]

    @test widgettype(input(Bool)) == :toggle
    @test widgettype(input(Dates.Date)) == :datepicker
    @test widgettype(input(Dates.Time)) == :timepicker
    @test widgettype(input(Color)) == :colorpicker
    @test widgettype(input(String)) == :textbox
    @test widgettype(input(Int)) == :spinbox

    @test widgettype(widget(true)) == :toggle
    @test widgettype(widget(Dates.Date(Dates.now()))) == :datepicker
    @test widgettype(widget(Dates.Time(Dates.now()))) == :timepicker
    @test widgettype(widget(colorant"red")) == :colorpicker
    @test widgettype(widget("")) == :textbox
    @test widgettype(widget(1)) == :spinbox
    @test widgettype(widget(1:100)) == :slider
    @test widgettype(widget(["a", "b", "c"])) == :togglebuttons
end

@testset "input widgets" begin
    a = filepicker()
    @test widgettype(a) == :filepicker
    @test a["filename"][] == ""
    @test a["path"][] == ""
    a["path"][] = "/home/Jack/documents/test.csv"
    @test a["path"][] == observe(a)[] == "/home/Jack/documents/test.csv"

    a = datepicker(value = Dates.Date(01,01,01))
    b = datepicker(Dates.Date(01,01,01))
    @test observe(a)[] == observe(b)[] == Dates.Date(01,01,01)
    @test widgettype(a) == :datepicker

    a = colorpicker(value = colorant"red")
    b = colorpicker(colorant"red")
    @test observe(a)[] == observe(b)[] == colorant"red"
    @test widgettype(a) == :colorpicker


    a = spinbox(label = "")
    @test widgettype(a) == :spinbox
    @test observe(a)[] == nothing

    a = textbox();
    @test widgettype(a) == :textbox

    @test observe(a)[] == ""
    s = "asd"
    a = textbox(value = s);
    @test observe(a)[] == "asd"

    a = textarea(label = "test");
    @test widgettype(a) == :textarea

    @test observe(a)[] == ""
    s = "asd"
    a = textarea(value = s);
    @test observe(a)[] == "asd"

    a = autocomplete(["aa", "bb", "cc"], value = "a");
    @test widgettype(a) == :autocomplete

    @test observe(a)[] == "a"

    a = button("Press me!", value = 12)
    @test widgettype(a) == :button
    @test observe(a)[] == 12

    a = toggle(label = "Agreed")
    @test widgettype(a) == :toggle

    @test observe(a)[] == false
    s = Observable(true)
    a = toggle(s, label = "Agreed")
    @test observe(a)[] == true

    a = togglecontent(checkbox("Yes, I am sure"), "Are you sure?")
    @test widgettype(a) == :togglecontent

    @test observe(a)[] == false
    s = Observable(true)
    a = togglecontent(checkbox("Yes, I am sure"), "Are you sure?", value = s)
    @test observe(a)[] == true

    v = slider([0, 12, 22], value = 12)
    @test widgettype(v) == :slider

    @test observe(v)[] == 12
    @test v["index"][] == 2
    # v["internalvalue"][] = 3
    # @test observe(v)[] == 22
end

@testset "slider" begin
    @test isfile(Interact.nouislider_min_js)
    @test isfile(Interact.nouislider_min_css)
    w = Dates.Date("2000-11-11") : Day(1) : Dates.Date("2000-12-12")
    s = Interact.rangeslider(w, value = [w[10], w[20]])
    @test observe(s)[] == [w[10], w[20]]
    @test observe(s["index"])[] == [10, 20]
    observe(s["index"])[] = [13, 14]
    sleep(0.1)
    @test observe(s)[] == [w[13], w[14]]

    w = 1:5:500
    s = Interact.rangepicker(w, value = [w[10], w[20]])
    @test collect(keys(components(s))) == [:input1, :input2, :slider, :changes]
    @test observe(s)[] == [w[10], w[20]] == observe(s["slider"])[]
    @test observe(s["slider"])[] == [w[10], w[20]]
    observe(s["slider"])[] = [w[13], w[14]]
    sleep(0.1)
    @test observe(s)[] == [w[13], w[14]]
    @test observe(s["input1"])[] == w[13]
    @test observe(s["input2"])[] == w[14]
end

@testset "options" begin
    a = dropdown(["a", "b", "c"])
    @test widgettype(a) == :dropdown

    @test observe(a)[] == "a"
    a = dropdown(OrderedDict("a" => 1, "b" => 2, "c" => 3))
    @test observe(a)[] == 1
    a = dropdown(OrderedDict("a" => 1, "b" => 3, "c" => 4), value = 3)
    @test observe(a)[] == 3
    @test observe(a, "index")[] == 2

    v = [0.1, 0.2, 1.2]
    a = dropdown(OrderedDict("a" => 1, "b" => 3, "c" => v), value = v)
    @test observe(a)[] == v
    @test observe(a, "index")[] == 3

    v = [0.1, 0.2, 1.2]
    a = dropdown(OrderedDict("a" => 1, "b" => 3, "c" => v), value = [3, v], multiple = true)
    @test observe(a)[] == [3, v]
    @test observe(a, "index")[] == [2, 3]

    a = togglebuttons(["a", "b", "c"])
    @test widgettype(a) == :togglebuttons

    @test observe(a)[] == "a"
    a = togglebuttons(OrderedDict("a" => 1, "b" => 2, "c"=>3))
    @test observe(a)[] == 1
    a = togglebuttons(OrderedDict("a" => 1, "b" => 2, "c" => 4), value = 4)
    @test observe(a)[] == 4

    a = radiobuttons(["a", "b", "c"])
    @test widgettype(a) == :radiobuttons

    @test observe(a)[] == "a"
    a = radiobuttons(OrderedDict("a" => 1, "b" => 2, "c" => 3))
    @test observe(a)[] == 1
    a = radiobuttons(OrderedDict("a" => 1, "b" => 2, "c" => 3), value = 3, label = "Test")
    @test observe(a)[] == 3

end

@testset "ijulia" begin
    @test !Interact.isijulia()
end

@testset "widget" begin
    s = slider(1:100, value = 12)
    w = Interact.Widget{:test}(components(s), scope = Widgets.scope(s), output = Observable(1))
    @test observe(w)[] == 1
    @test widgettype(s) == :slider
    @test widgettype(w) == :test
    @test w["index"][] == 12
    w = Widget(w, output = scope(s)["index"])
    @test observe(w)[] == 12

    w = Interact.widget(Observable(1))
    @test w isa Observable
end

@testset "manipulate" begin
    ui = @manipulate for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1
        RGB(r,g,b)
    end
    @test observe(ui)[] == RGB(0.5, 0.5, 0.5)
    observe(ui, :r)[] = 0.1
    sleep(0.1)
    @test observe(ui)[] == RGB(0.1, 0.5, 0.5)

    ui = @manipulate throttle = 1 for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1
        RGB(r,g,b)
    end
    observe(ui, :r)[] = 0.1
    sleep(0.1)
    observe(ui, :r)[] = 0.3
    sleep(0.1)
    observe(ui, :g)[] = 0.1
    sleep(0.1)
    observe(ui, :g)[] = 0.3
    sleep(0.1)
    observe(ui, :b)[] = 0.1
    sleep(0.1)
    observe(ui, :b)[] = 0.3
    sleep(0.1)
    @test observe(ui)[] != RGB(0.3, 0.3, 0.3)
    sleep(1.5)
    @test observe(ui)[] == RGB(0.3, 0.3, 0.3)
end

@testset "output" begin
    @test isfile(Interact.katex_min_js)
    @test isfile(Interact.katex_min_css)
    l = Observable("\\sum_{i=1}^{\\infty} e^i")
    a = latex(l)
    @test widgettype(a) == :latex
    @test observe(a)[] == l[]
    l[] == "\\sum_{i=1}^{12} e^i"
    @test observe(a)[] == l[]

    @test isfile(joinpath(dirname(@__FILE__), "..", "assets", "prism.js"))
    @test isfile(joinpath(dirname(@__FILE__), "..", "assets", "prism.css"))

    l = Observable("1+1+exp(2)")
    a = highlight(l)
    @test widgettype(a) == :highlight
    @test observe(a)[] == l[]
    l[] == "1-1"
    @test observe(a)[] == l[]

    l = Observable("1+1+exp(2)")
    a = widget(Val(:highlight), l)
    @test widgettype(a) == :highlight
    @test observe(a)[] == l[]
    l[] == "1-1"
    @test observe(a)[] == l[]

    a = alert()
    a("Error!")
    @test a["text"] isa Observable
    @test a["text"][] == "Error!"

    a = widget(Val(:alert), "Error 2!")
    a()
    @test a["text"] isa Observable
    @test a["text"][] == "Error 2!"

    a = confirm()
    a("Error!")
    @test a["text"] isa Observable
    @test a["text"][] == "Error!"
    @test observe(a)[] == false
    @test a["function"](1) === nothing

    a = widget(Val(:confirm), "Error 2!")
    a()
    @test a["text"] isa Observable
    @test a["text"][] == "Error 2!"
    @test observe(a)[] == false

    v = Any["A"]
    f = notifications(v)
    sleep(0.1)
    @test observe(f)[] == v
    list = children(f.scope.dom[])[1]

    @test begin
        Widgets.scope(f)[:to_delete][] = 1
        sleep(0.1)
        observe(f)[] == []
    end

    v = OrderedDict("a" => checkbox(), "b" => 12)
    wdg = Interact.accordion(v, multiple = true)
    sleep(0.1)
    @test observe(wdg)[] == Int[]
    @test observe(wdg["options"])[] == v
    observe(wdg)[] = [1]
    sleep(0.1)
    @test observe(wdg)[] == [1]
    observe(wdg["options"])[] = OrderedDict("a" => 12)
    sleep(0.1)
    @test observe(wdg)[] == [1]

    v = OrderedDict("a" => checkbox(), "b" => 12)
    wdg = Interact.accordion(v, multiple = false)
    sleep(0.1)
    @test observe(wdg)[] == 1
    @test observe(wdg["options"])[] == v
    observe(wdg)[] = 2
    sleep(0.1)
    @test observe(wdg)[] == 2
    observe(wdg["options"])[] = OrderedDict("a" => 12)
    sleep(0.1)
    @test observe(wdg)[] == 2

    a = tabulator(OrderedDict("a" => 1.1, "b" => 1.2, "c" => 1.3))
    @test a[:navbar] isa Interact.Widget{:tabs}
    @test a[:navbar][:index][] == 1
    @test observe(a, :navbar)[] == 1
    observe(a)[] = 2
    sleep(0.1)
    @test a[:navbar][:index][] == 2
    @test observe(a, :navbar)[] == 2
    @test observe(a, "key")[] == "b"

    a = tabulator(OrderedDict("a" => 1.1, "b" => 1.2, "c" => 1.3), value = 0)
    @test a[:navbar][:index][] == 0
    @test observe(a, :key)[] == nothing

    v = OrderedDict("a" => checkbox(), "b" => 12)
    wdg = Interact.mask(v, multiple = true)
    sleep(0.1)
    @test observe(wdg)[] == Int[]
    @test observe(wdg["options"])[] == v
    observe(wdg)[] = [1]
    sleep(0.1)
    @test observe(wdg)[] == [1]
    observe(wdg["options"])[] = OrderedDict("a" => 12)
    sleep(0.1)
    @test observe(wdg)[] == [1]

    v = OrderedDict("a" => checkbox(), "b" => 12)
    wdg = Interact.mask(v; multiple = false)
    sleep(0.1)
    @test observe(wdg)[] == 1
    @test observe(wdg["options"])[] == v
    observe(wdg)[] = 2
    sleep(0.1)
    @test observe(wdg)[] == 2
    observe(wdg["options"])[] = OrderedDict("a" => 12)
    sleep(0.1)
    @test observe(wdg)[] == 2
end

@testset "node" begin
    @test Interact.node("a", "b") isa Node
    @test Interact.div("a", "b") isa Node
end

@testset "onchange" begin
    value = Observable(50)
    changes = Observable(0)
    s0 = slider(1:100, value = value, changes = changes)
    s1 = onchange(s0)
    onrelease = Interact.triggeredby(s0, s0[:changes])
    @test onrelease[] == 50 == s1[]
    s0[] = 12
    sleep(0.1)
    @test onrelease[] == 50 == s1[]
    s0[:changes][] += 1
    sleep(0.1)
    @test onrelease[] == 12 == s1[][]
    @test changes[] == 1
end
