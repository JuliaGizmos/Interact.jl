const widgets_js = readstring(joinpath(dirname(Base.source_path()), "widgets.js"))

function init_widgets_js()
    if displayable("text/html")
        display("text/html", """<script charset="utf-8">$(widgets_js)</script>""")
    end
end
