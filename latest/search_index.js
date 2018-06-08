var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Interact-1",
    "page": "Introduction",
    "title": "Interact",
    "category": "section",
    "text": "Interact allows to create small GUIs in Julia based on web technology. These GUIs can be deployed in jupyter notebooks, in the Juno IDE plot pane, in an Electron window or in the browser.To understand how to use it go through the Tutorial. The tutorial is also available here as a Jupyter notebook.A list of available widget can be found at API referenceInteractBase (together with Vue and WebIO) provides the logic that allows the communication between Julia and Javascript and the organization of the widgets."
},

{
    "location": "index.html#CSS-frameworks-1",
    "page": "Introduction",
    "title": "CSS frameworks",
    "category": "section",
    "text": "Two CSS frameworks are available, based one on Bulma and the other on UIkit. Choosing one or the other is mainly a matter of taste. Bulma is the default: it is a pure CSS framework (no extra Javascript), which leaves Julia fully in control of manipulating the DOM (which in turn means less surface area for bugs).To change backend in the middle of the session simply do:settheme!(:bulma)orsettheme!(:uikit)"
},

{
    "location": "index.html#Deploying-the-web-app-1",
    "page": "Introduction",
    "title": "Deploying the web app",
    "category": "section",
    "text": "InteractBase works with the following frontends:Juno - The hottest Julia IDE\nIJulia - Jupyter notebooks (and Jupyter Lab) for Julia\nBlink - An Electron wrapper you can use to make Desktop apps\nMux - A web server frameworkSee Displaying a widget for instructions."
},

{
    "location": "tutorial.html#",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "page",
    "text": "EditURL = \"https://github.com/JuliaGizmos/Interact.jl/blob/master/docs/src/tutorial.jl\""
},

{
    "location": "tutorial.html#Tutorial-1",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "section",
    "text": ""
},

{
    "location": "tutorial.html#Installing-everything-1",
    "page": "Tutorial",
    "title": "Installing everything",
    "category": "section",
    "text": "To install Interact, simply typePkg.add(\"Interact\")in the REPL.The basic behavior is as follows: Interact provides a series of widgets, each widgets has a primary observable that can be obtained with observe(widget) and adding listeners to that observable one can provide behavior. Let\'s see this in practice."
},

{
    "location": "tutorial.html#Displaying-a-widget-1",
    "page": "Tutorial",
    "title": "Displaying a widget",
    "category": "section",
    "text": "using Interact, WebIO\nui = button()\ndisplay(ui)Note that display works in a Jupyter notebook or in Atom/Juno IDE. Interact can also be deployed in Jupyter Lab, but that requires installing an extension first:cd(Pkg.dir(\"WebIO\", \"assets\"))\n;jupyter labextension install webio\n;jupyter labextension enable webio/jupyterlab_entryTo deploy the app as a standalone Electron window, one would use Blink.jl:using Blink\nw = Window()\nbody!(w, ui);The app can also be served in a webpage via Mux.jl:using Mux\nwebio_serve(page(\"/\", req -> ui), rand(8000:9000)) # serve on a random port"
},

{
    "location": "tutorial.html#Adding-behavior-1",
    "page": "Tutorial",
    "title": "Adding behavior",
    "category": "section",
    "text": "For now this button doesn\'t do anything. This can be changed by adding callbacks to its primary observable:o = observe(ui)Each observable holds a value and its value can be inspected with the [] syntax:o[]In the case of the button, the observable represents the number of times it has been clicked: click on it and check the value again.To add some behavior to the widget we can use the on construct. on takes two arguments, a function and an observable. As soon as the observable is changed, the function is called with the latest value.on(println, o)If you click again on the button you will see it printing the number of times it has been clicked so far.Tip: anonymous function are very useful in this programming paradigm. For example, if you want the button to say \"Hello!\" when pressed, you should use:on(n -> println(\"Hello!\"), o)Tip n. 2: using the [] syntax you can also set the value of the observable:o[] = 33;To learn more about Observables, check out their documentation here."
},

{
    "location": "tutorial.html#What-widgets-are-there?-1",
    "page": "Tutorial",
    "title": "What widgets are there?",
    "category": "section",
    "text": "Once you have grasped this paradigm, you can play with any of the many widgets available:filepicker() |> display # observable is the path of selected file\ntextbox(\"Write here\") |> display # observable is the text typed in by the user\nautocomplete([\"Mary\", \"Jane\", \"Jack\"]) |> display # as above, but you can autocomplete words\ncheckbox(label = \"Check me!\") |> display # observable is a boolean describing whether it\'s ticked\ntoggle(label = \"I have read and agreed\") |> display # same as a checkbox but styled differently\nslider(1:100, label = \"To what extent?\", value = 33) |> display # Observable is the number selectedAs well as the option widgets, that allow to choose among options:dropdown([\"a\", \"b\", \"c\"]) |> display # Observable is option selected\ntogglebuttons([\"a\", \"b\", \"c\"]) |> display # Observable is option selected\nradiobuttons([\"a\", \"b\", \"c\"]) |> display # Observable is option selectedThe option widgets can also take as input a dictionary (ordered dictionary is preferrable, to avoid items getting scrambled), in which case the label displays the key while the observable stores the value:using DataStructures\ns = dropdown(OrderedDict(\"a\" => \"Value 1\", \"b\" => \"Value 2\"))\ndisplay(s)observe(s)[]"
},

{
    "location": "tutorial.html#A-simpler-approach-for-simpler-cases-1",
    "page": "Tutorial",
    "title": "A simpler approach for simpler cases",
    "category": "section",
    "text": "While the approach sketched above works for all sorts of situations, there is a specific marcro to simplify it in some specific case. If you want to update some result (maybe a plot) as a function of some parameters (discrete or continuous) simply write @manipulate before the for loop. Discrete parameters will be replaced by togglebuttons and continuous parameters by slider: the result will be updated as soon as you click on a button or move the slider:width, height = 700, 300\ncolors = [\"black\", \"gray\", \"silver\", \"maroon\", \"red\", \"olive\", \"yellow\", \"green\", \"lime\", \"teal\", \"aqua\", \"navy\", \"blue\", \"purple\", \"fuchsia\"]\ncolor(i) = colors[i%length(colors)+1]\nui = @manipulate for nsamples in 1:200,\n        sample_step in slider(0.01:0.01:1.0, value=0.1, label=\"sample step\"),\n        phase in slider(0:0.1:2pi, value=0.0, label=\"phase\"),\n        radii in 0.1:0.1:60\n    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]\n    cys = sin.(cxs_unscaled) .* height/3 .+ height/2\n    cxs = cxs_unscaled .* width/4pi\n    dom\"svg:svg[width=$width, height=$height]\"(\n        (dom\"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(color(i))]\"()\n            for i in 1:nsamples)...\n    )\nendor, if you want a plot with some variables taking discrete values:using Plots, DataStructures\n\nx = y = 0:0.1:30\n\nfreqs = OrderedDict(zip([\"pi/4\", \"π/2\", \"3π/4\", \"π\"], [π/4, π/2, 3π/4, π]))\n\nmp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label=\"freq2\")\n    y = @. sin(freq1*x) * sin(freq2*x)\n    plot(x, y)\nend"
},

{
    "location": "tutorial.html#Layout-1",
    "page": "Tutorial",
    "title": "Layout",
    "category": "section",
    "text": "To create a full blown web-app, you should learn the layout tools that the CSS framework you are using provides. Both Bulma and UIkit have modern layout tools for responsive design (of course, use Bulma if you\'re working with the Bulma backend and UIkit if you\'re working with the UIkit backend). You can use WebIO to create from Julia the HTML required to create these layouts.However, this can be overwhelming at first (especially for users with no prior experience in web design). A simpler solution is CSSUtil, a package that provides some tools to create simple layouts.using CSSUtil\nloadbutton = filepicker()\nhellobutton = button(\"Hello!\")\ngoodbyebutton = button(\"Good bye!\")\nui = vbox( # put things one on top of the other\n    loadbutton,\n    hbox( # put things one next to the other\n        pad(1em, hellobutton), # to allow some white space around the widget\n        pad(1em, goodbyebutton),\n    )\n)\ndisplay(ui)"
},

{
    "location": "tutorial.html#Update-widgets-as-function-of-other-widgets-1",
    "page": "Tutorial",
    "title": "Update widgets as function of other widgets",
    "category": "section",
    "text": "Sometimes the full structure of the GUI is not known in advance. For example, let\'s imagine we want to load a DataFrame and create a button per column. Not to make it completely trivial, as soon as a button is pressed, we want to plot a histogram of the corresponding column.Important note: this app needs to run in Blink, as the browser doesn\'t allow us to get access to the local path of a file.We start by adding a filepicker to choose the file, and only once we have a file we want to update the GUI. this can be done as follows:loadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())columnbuttons is the div object that will contain all the relevant buttons. it is an Observable as we want its value to change over time. To add behavior, we can use map!:using CSV, DataFrames\ndata = Observable{Any}(DataFrame)\nmap!(CSV.read, data, observe(loadbutton))Now as soon as a file is uploaded, the Observable data gets updated with the correct value. Now, as soon as data is updated, we want to update our buttons.using CSSUtil\nfunction makebuttons(df)\n    buttons = button.(names(df))\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)Note that data is already an Observable, so there\'s no need to do observe(data), observe can only be applied on a widget. We are almost done, we only need to add a callback to the buttons. The cleanest way is to do it during button initialization, meaning during our makebuttons step:using Plots\nplt = Observable{Any}(plot()) # the container for our plot\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, observe(btn))\n    end\n    dom\"div\"(hbox(buttons))\nendTo put it all together:using CSV, DataFrames, InteractUIkit, WebIO, Observables, Plots, CSSUtil\nloadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())\ndata = Observable{Any}(DataFrame)\nplt = Observable{Any}(plot())\nmap!(CSV.read, data, observe(loadbutton))\n\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, observe(btn))\n    end\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)\n\nui = dom\"div\"(loadbutton, columnbuttons, plt)And now to serve it in Blink:using Blink\nw = Window()\nbody!(w, ui)This page was generated using Literate.jl."
},

{
    "location": "api_reference.html#",
    "page": "API reference",
    "title": "API reference",
    "category": "page",
    "text": ""
},

{
    "location": "api_reference.html#API-reference-1",
    "page": "API reference",
    "title": "API reference",
    "category": "section",
    "text": ""
},

{
    "location": "api_reference.html#InteractBase.spinbox",
    "page": "API reference",
    "title": "InteractBase.spinbox",
    "category": "function",
    "text": "spinbox(label=\"\"; value=nothing)\n\nCreate a widget to select numbers with placeholder label\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.textbox",
    "page": "API reference",
    "title": "InteractBase.textbox",
    "category": "function",
    "text": "textbox(hint=\"\"; value=\"\")\n\nCreate a text input area with an optional placeholder hint e.g. textbox(\"enter number:\"). Use typ=... to specify the type of text. For example typ=\"email\" or typ=password. Use multiline=true to display a textarea spanning several lines.\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.textarea",
    "page": "API reference",
    "title": "InteractBase.textarea",
    "category": "function",
    "text": "textarea(hint=\"\"; value=\"\")\n\nCreate a textarea with an optional placeholder hint e.g. textarea(\"enter number:\"). Use rows=... to specify how many rows to display\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.autocomplete",
    "page": "API reference",
    "title": "InteractBase.autocomplete",
    "category": "function",
    "text": "autocomplete(options, label=\"\"; value=\"\")\n\nCreate a textbox input with autocomplete options specified by options, with value as initial value and label as label.\n\n\n\n"
},

{
    "location": "api_reference.html#Text-input-1",
    "page": "API reference",
    "title": "Text input",
    "category": "section",
    "text": "These are widgets to select text input that\'s typed in by the user. For numbers use spinbox and for strings use textbox. String entries (textbox and autocomplete) are initialized as \"\", whereas spinbox defaults to nothing, which corresponds to the empty entry.spinbox\ntextbox\ntextarea\nautocomplete"
},

{
    "location": "api_reference.html#InteractBase.datepicker",
    "page": "API reference",
    "title": "InteractBase.datepicker",
    "category": "function",
    "text": "datepicker(value::Union{Dates.Date, Observable, Void}=nothing)\n\nCreate a widget to select dates.\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.timepicker",
    "page": "API reference",
    "title": "InteractBase.timepicker",
    "category": "function",
    "text": "timepicker(value::Union{Dates.Time, Observable, Void}=nothing)\n\nCreate a widget to select times.\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.colorpicker",
    "page": "API reference",
    "title": "InteractBase.colorpicker",
    "category": "function",
    "text": "colorpicker(value::Union{Color, Observable}=colorant\"#000000\")\n\nCreate a widget to select colors.\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.checkbox",
    "page": "API reference",
    "title": "InteractBase.checkbox",
    "category": "function",
    "text": "checkbox(value::Union{Bool, Observable}=false; label)\n\nA checkbox. e.g. checkbox(label=\"be my friend?\")\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.toggle",
    "page": "API reference",
    "title": "InteractBase.toggle",
    "category": "function",
    "text": "toggle(value::Union{Bool, Observable}=false; label)\n\nA toggle switch. e.g. toggle(label=\"be my friend?\")\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.togglecontent",
    "page": "API reference",
    "title": "InteractBase.togglecontent",
    "category": "function",
    "text": "togglecontent(content, value::Union{Bool, Observable}=false; label)\n\nA toggle switch that, when activated, displays content e.g. togglecontent(checkbox(\"Yes, I am sure\"), false, label=\"Are you sure?\")\n\n\n\n"
},

{
    "location": "api_reference.html#Type-input-1",
    "page": "API reference",
    "title": "Type input",
    "category": "section",
    "text": "These are widgets to select a specific, non-text, type of input. So far, Date, Time, Color and Bool are supported. Types that allow a empty field (Date and Time) are initialized as nothing by default, whereas Color and Bool are initialized with the default HTML value (colorant\"black\" and false respectively).datepicker\ntimepicker\ncolorpicker\ncheckbox\ntoggle\ntogglecontent"
},

{
    "location": "api_reference.html#InteractBase.filepicker",
    "page": "API reference",
    "title": "InteractBase.filepicker",
    "category": "function",
    "text": "filepicker(label=\"Choose a file...\"; multiple=false, accept=\"*\")\n\nCreate a widget to select files. If multiple=true the observable will hold an array containing the paths of all selected files. Use accept to only accept some formats, e.g. accept=\".csv\"\n\n\n\n"
},

{
    "location": "api_reference.html#File-input-1",
    "page": "API reference",
    "title": "File input",
    "category": "section",
    "text": "filepicker"
},

{
    "location": "api_reference.html#InteractBase.slider",
    "page": "API reference",
    "title": "InteractBase.slider",
    "category": "function",
    "text": "function slider(vals::Range; # Range\n                value=medianelement(valse),\n                label=\"\", kwargs...)\n\nCreates a slider widget which can take on the values in vals, and updates observable value when the slider is changed:\n\n\n\n"
},

{
    "location": "api_reference.html#Range-input-1",
    "page": "API reference",
    "title": "Range input",
    "category": "section",
    "text": "slider"
},

{
    "location": "api_reference.html#InteractBase.button",
    "page": "API reference",
    "title": "InteractBase.button",
    "category": "function",
    "text": "button(content... = \"Press me!\"; value=0)\n\nA button. content goes inside the button. Note the button content supports a special clicks variable, that gets incremented by 1 with each click e.g.: button(\"clicked {{clicks}} times\"). The clicks variable is initialized at value=0\n\n\n\n"
},

{
    "location": "api_reference.html#Callback-input-1",
    "page": "API reference",
    "title": "Callback input",
    "category": "section",
    "text": "button"
},

{
    "location": "api_reference.html#InteractBase.input",
    "page": "API reference",
    "title": "InteractBase.input",
    "category": "function",
    "text": "input(o; typ=\"text\")\n\nCreate an HTML5 input element of type type (e.g. \"text\", \"color\", \"number\", \"date\") with o as initial value.\n\n\n\n"
},

{
    "location": "api_reference.html#HTML5-input-1",
    "page": "API reference",
    "title": "HTML5 input",
    "category": "section",
    "text": "All of the inputs above are implemented wrapping the input tag of HTML5 which can be accessed more directly as follows:InteractBase.input"
},

{
    "location": "api_reference.html#InteractBase.dropdown",
    "page": "API reference",
    "title": "InteractBase.dropdown",
    "category": "function",
    "text": "dropdown(options::Associative;\n         value = first(values(options)),\n         label = nothing,\n         multiple = false)\n\nA dropdown menu whose item labels will be the keys of options. If multiple=true the observable will hold an array containing the values of all selected items e.g. dropdown(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\n\n\ndropdown(values::AbstractArray; kwargs...)\n\ndropdown with labels string.(values) see dropdown(options::Associative; ...) for more details\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.togglebuttons",
    "page": "API reference",
    "title": "InteractBase.togglebuttons",
    "category": "function",
    "text": "togglebuttons(options::Associative; value::Union{T, Observable})\n\nCreates a set of toggle buttons whose labels will be the keys of options.\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.radiobuttons",
    "page": "API reference",
    "title": "InteractBase.radiobuttons",
    "category": "function",
    "text": "radiobuttons(options::Associative;\n             value::Union{T, Observable} = first(values(options)))\n\ne.g. radiobuttons(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\n\n\nradiobuttons(values::AbstractArray; kwargs...)\n\nradiobuttons with labels string.(values) see radiobuttons(options::Associative; ...) for more details\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.checkboxes",
    "page": "API reference",
    "title": "InteractBase.checkboxes",
    "category": "function",
    "text": "checkboxes(options::Associative;\n         value = first(values(options)))\n\nA list of checkboxes whose item labels will be the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. checkboxes(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\n\n\ncheckboxes(values::AbstractArray; kwargs...)\n\ncheckboxes with labels string.(values) see checkboxes(options::Associative; ...) for more details\n\n\n\n"
},

{
    "location": "api_reference.html#InteractBase.toggles",
    "page": "API reference",
    "title": "InteractBase.toggles",
    "category": "function",
    "text": "toggles(options::Associative;\n         value = first(values(options)))\n\nA list of toggle switches whose item labels will be the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. toggles(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\n\n\ntoggles(values::AbstractArray; kwargs...)\n\ntoggles with labels string.(values) see toggles(options::Associative; ...) for more details\n\n\n\n"
},

{
    "location": "api_reference.html#Option-input-1",
    "page": "API reference",
    "title": "Option input",
    "category": "section",
    "text": "dropdown\ntogglebuttons\nradiobuttons\ncheckboxes\ntoggles"
},

{
    "location": "api_reference.html#InteractBase.latex",
    "page": "API reference",
    "title": "InteractBase.latex",
    "category": "function",
    "text": "latex(txt)\n\nRender txt in LaTeX using KaTeX. Backslashes need to be escaped: latex(\"\\\\sum_{i=1}^{\\\\infty} e^i\")\n\n\n\n"
},

{
    "location": "api_reference.html#Output-1",
    "page": "API reference",
    "title": "Output",
    "category": "section",
    "text": "latex"
},

]}
