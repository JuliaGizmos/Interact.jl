import Base: writemime

using JSON

const widgets_js = readall(joinpath(dirname(Base.source_path()), "widgets.js"))

try
    display("text/html", """<script charset="utf-8">$(widgets_js)</script>""")
catch
end

function writemime(io, ::MIME{symbol("text/html")}, w::InputWidget)
    wtype = typeof(w)
    while super(wtype) <: InputWidget
        wtype = super(wtype)
    end

    widgettype = string(typeof(w).name.name)
    inputtype  = string(wtype.parameters[1].name.name)

    id = register_widget(w)
    el_id = "widget-$(id)"

    write(io, "<div class=\"input-widget ", lowercase(widgettype),
          "\"  id=\"", el_id, "\"></div><script>(function(\$,W) {",
          "\$('#", el_id, "').empty().append((new W.",
          widgettype, "(\"", inputtype, "\",\"", id, "\",", JSON.json(statedict(w)), ")",
          ").elem);})(jQuery,InputWidgets)</script>")
end

