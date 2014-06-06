
const widgets_js = readall(joinpath(dirname(Base.source_path()), "widgets.js"))

try
    display("text/html", """<script charset="utf-8">$(widgets_js)</script>""")
catch
end

uuid4() = string(Base.Random.uuid4())

function writemime(io:: IO, :: MIME{symbol("text/html")}, w :: InputWidget)
    wtype = typeof(w)
    while super(wtype) <: InputWidget
        wtype = super(wtype)
    end

    widgettype = string(typeof(w).name.name)
    inputtype  = string(wtype.parameters[1].name.name)

    id = string(uuid4())
    el_id = "widget-$(id)"

    write(io, "<div class=\"input-widget ", lowercase(widgettype),
          "\"  id=\"", el_id, "\"></div><script>(function(\$,W) {",
          "\$('#", el_id, "').empty().append((new W.",
          widgettype, "(\"", inputtype, "\",\"", id, "\",", json(w), ")",
          ").elem);})(jQuery,InputWidgets)</script>")
end
