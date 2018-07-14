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
    "text": "Interact allows to create small GUIs in Julia based on web technology. These GUIs can be deployed in jupyter notebooks, in the Juno IDE plot pane, in an Electron window or in the browser.To understand how to use it go through the Tutorial. The tutorial is also available here as a Jupyter notebook.InteractBase, Knockout and WebIO provide the logic that allows the communication between Julia and Javascript and the organization of the widgets."
},

{
    "location": "index.html#Overview-1",
    "page": "Introduction",
    "title": "Overview",
    "category": "section",
    "text": "Creating an app in Interact requires three ingredients:Observables: references that can listen to changes in other references\nWidgets: the graphical elements that make up the app\nLayout: tools to assemble together different widgetsTo get a quick overview of how these tools work together, go to Tutorial."
},

{
    "location": "index.html#CSS-frameworks-1",
    "page": "Introduction",
    "title": "CSS frameworks",
    "category": "section",
    "text": "Two CSS frameworks are available, based one on Bulma and the other on UIkit. Choosing one or the other is mainly a matter of taste. Bulma is the default: it is a pure CSS framework (no extra Javascript), which leaves Julia fully in control of manipulating the DOM (which in turn means less surface area for bugs).To change backend in the middle of the session simply do:settheme!(:bulma)orsettheme!(:uikit)"
},

{
    "location": "index.html#Deployment-1",
    "page": "Introduction",
    "title": "Deployment",
    "category": "section",
    "text": "InteractBase works with the following frontends:Juno - The hottest Julia IDE\nIJulia - Jupyter notebooks (and Jupyter Lab) for Julia\nBlink - An Electron wrapper you can use to make Desktop apps\nMux - A web server frameworkSee Deploying the web app for instructions."
},

{
    "location": "observables.html#",
    "page": "Observables",
    "title": "Observables",
    "category": "page",
    "text": ""
},

{
    "location": "observables.html#Observables-1",
    "page": "Observables",
    "title": "Observables",
    "category": "section",
    "text": "Observables are like Refs but you can listen to changes.using Observables\n\nobservable = Observable(0)\n\nh = on(observable) do val\n    println(\"Got an update: \", val)\nend\n\nobservable[] = 42To get the value of an observable index it with no argumentsobservable[]To remove a handler use off with the return value of on:off(observable, h)"
},

{
    "location": "observables.html#How-is-it-different-from-Reactive.jl?-1",
    "page": "Observables",
    "title": "How is it different from Reactive.jl?",
    "category": "section",
    "text": "The main difference is Signals are manipulated mostly by converting one signal to another. For example, with signals, you can construct a changing UI by creating a Signal of UI objects and rendering them as the signal changes. On the other hand, you can use an Observable both as an input and an output. You can arbitrarily attach outputs to inputs allowing structuring code in a signals-and-slots kind of pattern.Another difference is Observables are synchronous, Signals are asynchronous. Observables may be better suited for an imperative style of programming."
},

{
    "location": "observables.html#Observables.Observable",
    "page": "Observables",
    "title": "Observables.Observable",
    "category": "type",
    "text": "Like a Ref but updates can be watched by adding a handler using on.\n\n\n\n"
},

{
    "location": "observables.html#Observables.on-Tuple{Any,Observables.Observable}",
    "page": "Observables",
    "title": "Observables.on",
    "category": "method",
    "text": "on(f, o::Observable)\n\nAdds function f as listener to o. Whenever o\'s value is set via o[] = val f is called with val.\n\n\n\n"
},

{
    "location": "observables.html#Observables.off-Tuple{Observables.Observable,Any}",
    "page": "Observables",
    "title": "Observables.off",
    "category": "method",
    "text": "off(o::Observable, f)\n\nRemoves f from listeners of o.\n\n\n\n"
},

{
    "location": "observables.html#Base.setindex!-Tuple{Observables.Observable,Any}",
    "page": "Observables",
    "title": "Base.setindex!",
    "category": "method",
    "text": "o[] = val\n\nUpdates the value of an Observable to val and call its listeners.\n\n\n\n"
},

{
    "location": "observables.html#Base.getindex-Tuple{Observables.Observable}",
    "page": "Observables",
    "title": "Base.getindex",
    "category": "method",
    "text": "o[]\n\nReturns the current value of o.\n\n\n\n"
},

{
    "location": "observables.html#Observables.onany-Tuple{Any,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Observables.onany",
    "category": "method",
    "text": "onany(f, args...)\n\nCalls f on updates to any oservable refs in args. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n"
},

{
    "location": "observables.html#Base.map!-Tuple{Any,Observables.Observable,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Base.map!",
    "category": "method",
    "text": "map!(f, o::Observable, args...)\n\nUpdates o with the result of calling f with values extracted from args. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n"
},

{
    "location": "observables.html#Observables.connect!-Tuple{Observables.Observable,Observables.Observable}",
    "page": "Observables",
    "title": "Observables.connect!",
    "category": "method",
    "text": "connect!(o1::Observable, o2::Observable)\n\nForward all updates to o1 to o2\n\n\n\n"
},

{
    "location": "observables.html#Base.map-Tuple{Any,Observables.Observable,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Base.map",
    "category": "method",
    "text": "map(f, o::Observable, args...)\n\nCreates a new oservable ref which contains the result of f applied to values extracted from args. The second argument o must be an oservable ref for dispatch reasons. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n"
},

{
    "location": "observables.html#API-1",
    "page": "Observables",
    "title": "API",
    "category": "section",
    "text": "Observable{T}\non(f, o::Observable)\noff(o::Observable, f)\nBase.setindex!(o::Observable, val)\nBase.getindex(o::Observable)\nonany(f, os...)\nBase.map!(f, o::Observable, os...)\nconnect!(o1::Observable, o2::Observable)\nBase.map(f, o::Observable, os...; init)"
},

{
    "location": "widgets.html#",
    "page": "Widgets",
    "title": "Widgets",
    "category": "page",
    "text": ""
},

{
    "location": "widgets.html#Widgets-1",
    "page": "Widgets",
    "title": "Widgets",
    "category": "section",
    "text": ""
},

{
    "location": "widgets.html#InteractBase.spinbox",
    "page": "Widgets",
    "title": "InteractBase.spinbox",
    "category": "function",
    "text": "spinbox([range,] label=\"\"; value=nothing)\n\nCreate a widget to select numbers with placeholder label. An optional range first argument specifies maximum and minimum value accepted as well as the step.\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.textbox",
    "page": "Widgets",
    "title": "InteractBase.textbox",
    "category": "function",
    "text": "textbox(hint=\"\"; value=\"\")\n\nCreate a text input area with an optional placeholder hint e.g. textbox(\"enter number:\"). Use typ=... to specify the type of text. For example typ=\"email\" or typ=password. Use multiline=true to display a textarea spanning several lines.\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.textarea",
    "page": "Widgets",
    "title": "InteractBase.textarea",
    "category": "function",
    "text": "textarea(hint=\"\"; value=\"\")\n\nCreate a textarea with an optional placeholder hint e.g. textarea(\"enter number:\"). Use rows=... to specify how many rows to display\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.autocomplete",
    "page": "Widgets",
    "title": "InteractBase.autocomplete",
    "category": "function",
    "text": "autocomplete(options, label=\"\"; value=\"\")\n\nCreate a textbox input with autocomplete options specified by options, with value as initial value and label as label.\n\n\n\n"
},

{
    "location": "widgets.html#Text-input-1",
    "page": "Widgets",
    "title": "Text input",
    "category": "section",
    "text": "These are widgets to select text input that\'s typed in by the user. For numbers use spinbox and for strings use textbox. String entries (textbox and autocomplete) are initialized as \"\", whereas spinbox defaults to nothing, which corresponds to the empty entry.spinbox\ntextbox\ntextarea\nautocomplete"
},

{
    "location": "widgets.html#InteractBase.datepicker",
    "page": "Widgets",
    "title": "InteractBase.datepicker",
    "category": "function",
    "text": "datepicker(value::Union{Dates.Date, Observable, Void}=nothing)\n\nCreate a widget to select dates.\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.timepicker",
    "page": "Widgets",
    "title": "InteractBase.timepicker",
    "category": "function",
    "text": "timepicker(value::Union{Dates.Time, Observable, Void}=nothing)\n\nCreate a widget to select times.\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.colorpicker",
    "page": "Widgets",
    "title": "InteractBase.colorpicker",
    "category": "function",
    "text": "colorpicker(value::Union{Color, Observable}=colorant\"#000000\")\n\nCreate a widget to select colors.\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.checkbox",
    "page": "Widgets",
    "title": "InteractBase.checkbox",
    "category": "function",
    "text": "checkbox(value::Union{Bool, Observable}=false; label)\n\nA checkbox. e.g. checkbox(label=\"be my friend?\")\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.toggle",
    "page": "Widgets",
    "title": "InteractBase.toggle",
    "category": "function",
    "text": "toggle(value::Union{Bool, Observable}=false; label)\n\nA toggle switch. e.g. toggle(label=\"be my friend?\")\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.togglecontent",
    "page": "Widgets",
    "title": "InteractBase.togglecontent",
    "category": "function",
    "text": "togglecontent(content, value::Union{Bool, Observable}=false; label)\n\nA toggle switch that, when activated, displays content e.g. togglecontent(checkbox(\"Yes, I am sure\"), false, label=\"Are you sure?\")\n\n\n\n"
},

{
    "location": "widgets.html#Type-input-1",
    "page": "Widgets",
    "title": "Type input",
    "category": "section",
    "text": "These are widgets to select a specific, non-text, type of input. So far, Date, Time, Color and Bool are supported. Types that allow a empty field (Date and Time) are initialized as nothing by default, whereas Color and Bool are initialized with the default HTML value (colorant\"black\" and false respectively).datepicker\ntimepicker\ncolorpicker\ncheckbox\ntoggle\ntogglecontent"
},

{
    "location": "widgets.html#InteractBase.filepicker",
    "page": "Widgets",
    "title": "InteractBase.filepicker",
    "category": "function",
    "text": "filepicker(label=\"Choose a file...\"; multiple=false, accept=\"*\")\n\nCreate a widget to select files. If multiple=true the observable will hold an array containing the paths of all selected files. Use accept to only accept some formats, e.g. accept=\".csv\"\n\n\n\n"
},

{
    "location": "widgets.html#File-input-1",
    "page": "Widgets",
    "title": "File input",
    "category": "section",
    "text": "filepicker"
},

{
    "location": "widgets.html#InteractBase.slider",
    "page": "Widgets",
    "title": "InteractBase.slider",
    "category": "function",
    "text": "function slider(vals::Range; # Range\n                value=medianelement(valse),\n                label=\"\", kwargs...)\n\nCreates a slider widget which can take on the values in vals, and updates observable value when the slider is changed:\n\n\n\n"
},

{
    "location": "widgets.html#Range-input-1",
    "page": "Widgets",
    "title": "Range input",
    "category": "section",
    "text": "slider"
},

{
    "location": "widgets.html#InteractBase.button",
    "page": "Widgets",
    "title": "InteractBase.button",
    "category": "function",
    "text": "button(content... = \"Press me!\"; value=0)\n\nA button. content goes inside the button. Note the button content supports a special clicks variable, that gets incremented by 1 with each click e.g.: button(\"clicked {{clicks}} times\"). The clicks variable is initialized at value=0\n\n\n\n"
},

{
    "location": "widgets.html#Callback-input-1",
    "page": "Widgets",
    "title": "Callback input",
    "category": "section",
    "text": "button"
},

{
    "location": "widgets.html#InteractBase.input",
    "page": "Widgets",
    "title": "InteractBase.input",
    "category": "function",
    "text": "input(o; typ=\"text\")\n\nCreate an HTML5 input element of type type (e.g. \"text\", \"color\", \"number\", \"date\") with o as initial value.\n\n\n\n"
},

{
    "location": "widgets.html#HTML5-input-1",
    "page": "Widgets",
    "title": "HTML5 input",
    "category": "section",
    "text": "All of the inputs above are implemented wrapping the input tag of HTML5 which can be accessed more directly as follows:InteractBase.input"
},

{
    "location": "widgets.html#InteractBase.dropdown",
    "page": "Widgets",
    "title": "InteractBase.dropdown",
    "category": "function",
    "text": "dropdown(options::Associative;\n         value = first(values(options)),\n         label = nothing,\n         multiple = false)\n\nA dropdown menu whose item labels are the keys of options. If multiple=true the observable will hold an array containing the values of all selected items e.g. dropdown(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ndropdown(values::AbstractArray; kwargs...)\n\ndropdown with labels string.(values) see dropdown(options::Associative; ...) for more details\n\n\n\ndropdown(options::Observable;\n         value = first(values(options[])),\n         label = nothing,\n         multiple = false)\n\nA dropdown menu whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = dropdown(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.radiobuttons",
    "page": "Widgets",
    "title": "InteractBase.radiobuttons",
    "category": "function",
    "text": "radiobuttons(options::Associative;\n             value::Union{T, Observable} = first(values(options)))\n\ne.g. radiobuttons(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\nradiobuttons(values::AbstractArray; kwargs...)\n\nradiobuttons with labels string.(values) see radiobuttons(options::Associative; ...) for more details\n\nradiobuttons(options::Observable; kwargs...)\n\nRadio buttons whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = radiobuttons(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.checkboxes",
    "page": "Widgets",
    "title": "InteractBase.checkboxes",
    "category": "function",
    "text": "checkboxes(options::Associative;\n         value = first(values(options)))\n\nA list of checkboxes whose item labels are the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. checkboxes(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ncheckboxes(values::AbstractArray; kwargs...)\n\ncheckboxes with labels string.(values) see checkboxes(options::Associative; ...) for more details\n\ncheckboxes(options::Observable; kwargs...)\n\nCheckboxes whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = checkboxes(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.toggles",
    "page": "Widgets",
    "title": "InteractBase.toggles",
    "category": "function",
    "text": "toggles(options::Associative;\n         value = first(values(options)))\n\nA list of toggle switches whose item labels are the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. toggles(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ntoggles(values::AbstractArray; kwargs...)\n\ntoggles with labels string.(values) see toggles(options::Associative; ...) for more details\n\ntoggles(options::Observable; kwargs...)\n\nToggles whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = toggles(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.togglebuttons",
    "page": "Widgets",
    "title": "InteractBase.togglebuttons",
    "category": "function",
    "text": "togglebuttons(options::Associative; value::Union{T, Observable})\n\nCreates a set of toggle buttons whose labels are the keys of options.\n\ntogglebuttons(values::AbstractArray; kwargs...)\n\ntogglebuttons with labels string.(values) see togglebuttons(options::Associative; ...) for more details\n\ntogglebuttons(options::Observable; kwargs...)\n\nTogglebuttons whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = togglebuttons(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.tabs",
    "page": "Widgets",
    "title": "InteractBase.tabs",
    "category": "function",
    "text": "tabs(options::Associative; value::Union{T, Observable})\n\nCreates a set of tabs whose labels are the keys of options. The label can be a link.\n\ntabs(values::AbstractArray; kwargs...)\n\ntabs with labels values see tabs(options::Associative; ...) for more details\n\ntabs(options::Observable; kwargs...)\n\nTabs whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = tabs(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#InteractBase.tabulator",
    "page": "Widgets",
    "title": "InteractBase.tabulator",
    "category": "function",
    "text": "tabulator(options::Associative; index = 1, key = nothing)\n\nCreates a set of toggle buttons whose labels are the keys of options. Displays the value of the selected option underneath. Use index::Int to select which should be the index of the initial option, or key::String. The output is the selected index. Use index=0 to not have any selected option.\n\nExamples\n\ntabulator(OrderedDict(\"plot\" => plot(rand10), \"scatter\" => scatter(rand(10))), index = 1)\ntabulator(OrderedDict(\"plot\" => plot(rand10), \"scatter\" => scatter(rand(10))), key = \"plot\")\n\ntabulator(values::AbstractArray; kwargs...)\n\ntabulator with labels values see tabulator(options::Associative; ...) for more details\n\ntabulator(options::Observable; kwargs...)\n\nTabulator whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = tabulator(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n"
},

{
    "location": "widgets.html#Option-input-1",
    "page": "Widgets",
    "title": "Option input",
    "category": "section",
    "text": "dropdown\nradiobuttons\ncheckboxes\ntoggles\ntogglebuttonstabs\ntabulator"
},

{
    "location": "widgets.html#InteractBase.latex",
    "page": "Widgets",
    "title": "InteractBase.latex",
    "category": "function",
    "text": "latex(txt)\n\nRender txt in LaTeX using KaTeX. Backslashes need to be escaped: latex(\"\\\\sum_{i=1}^{\\\\infty} e^i\")\n\n\n\n"
},

{
    "location": "widgets.html#Output-1",
    "page": "Widgets",
    "title": "Output",
    "category": "section",
    "text": "latex"
},

{
    "location": "widgets.html#Widgets.widget",
    "page": "Widgets",
    "title": "Widgets.widget",
    "category": "function",
    "text": "widget(args...; kwargs...)\n\nAutomatically convert Julia types into appropriate widgets. kwargs are passed to the more specific widget function.\n\nExamples\n\nmap(display, [\n    widget(1:10),                 # Slider\n    widget(false),                # Checkbox\n    widget(\"text\"),               # Textbox\n    widget(1.1),                  # Spinbox\n    widget([:on, :off]),          # Toggle Buttons\n    widget(Dict(\"π\" => float(π), \"τ\" => 2π)),\n    widget(colorant\"red\"),        # Color picker\n    widget(Dates.today()),        # Date picker\n    widget(Dates.Time()),         # Time picker\n    ]);\n\n\n\n"
},

{
    "location": "widgets.html#Create-widgets-automatically-from-a-Julia-variable-1",
    "page": "Widgets",
    "title": "Create widgets automatically from a Julia variable",
    "category": "section",
    "text": "widget"
},

{
    "location": "custom_widgets.html#",
    "page": "Custom widgets",
    "title": "Custom widgets",
    "category": "page",
    "text": ""
},

{
    "location": "custom_widgets.html#Custom-widgets-1",
    "page": "Custom widgets",
    "title": "Custom widgets",
    "category": "section",
    "text": "Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches, the full featured @widget macro and the simple to use but more basic @manipulate macro."
},

{
    "location": "custom_widgets.html#The-Widget-type-1",
    "page": "Custom widgets",
    "title": "The Widget type",
    "category": "section",
    "text": "The Widget type can be used to create custom widgets. The types is parametric, with the parameter being the name of the widget and it takes as argument a OrderedDict of children.For example:d = OrderedDict(:label => \"My label\", :button => button(\"My button\"))\nw = Interact.Widget{:mywidget}(d)Children can be accessed and modified using getindex and setindex! on the Widget object:println(w[:label])\nw[:label] = \"A new label\"The @output! and @display! macros can be used to set the output of the widget and define how to display it.@output! w $(:button) > 5 ? \"You pressed me many times\" : \"You didn\'t press me enough\"\n@display! w dom\"div\"($(_.output), style = Dict(\"color\" => \"red\"))Finally the @layout! macro allows us to set the layout of the widget:@layout! w hbox(vbox(:label, :button), _.display)"
},

{
    "location": "custom_widgets.html#Widgets.@widget",
    "page": "Custom widgets",
    "title": "Widgets.@widget",
    "category": "macro",
    "text": "@widget(wdgname, func_call)\n\nSpecial macro to create \"recipes\" for custom widgets. The @widget macro takes to argument, a variable name wdgname and a function call func_call. The function call is changed by the macro in several ways:\n\nan extra line is added at the beginning to initiliaze a variable called wdgname::Widget that can be used to refer to the widget in the function body\nall lines of the type sym::Symbol = expr are replaced with wdgname[sym] = @map(wdgname, expr), see Widgets.@map for more details\nan extra line is added at the end to return wdgname\n\nThe macro then registers the function func_call and exports it. It also overloads the widget function with the following signature:\n\nWidgets.widget(::Val{Symbol(func_name)}, args...; kwargs..) = func_name(args...; kwargs...)\n\n\n\n"
},

{
    "location": "custom_widgets.html#The-recipe-macro-1",
    "page": "Custom widgets",
    "title": "The recipe macro",
    "category": "section",
    "text": "To simplify adding children to a custom widget (as well as to register it as a \"widget recipe\"), a @widget macro is provided.See Creating custom widgets for examples.@widget"
},

{
    "location": "custom_widgets.html#Widgets.@map",
    "page": "Custom widgets",
    "title": "Widgets.@map",
    "category": "macro",
    "text": "@map(d, x)\n\nApply the expression x to the widget d, replacing e.g. symbol :s with the corresponding Observable observe(d[:s]). To use the value of some of d\'s children, use :s[]. Use $(:s) if you want the output to update automatically as soon as the value of observe(d[:s]) changes. In this context, _ refers to the whole widget. To use actual symbols, escape them with ^, as in ^(:a).\n\nExamples\n\njulia> using DataStructures, InteractBase, Observables\n\njulia> t = Widgets.Widget{:test}(OrderedDict(:a => Observable(2), :b => slider(1:100), :c => button()));\n\nThis updates as soon as observe(t[:a]) or observe(t[:b]) change:\n\njulia> Widgets.@map t $(:a) + $(:b)\nObservables.Observable{Int64}(\"ob_31\", 52, Any[])\n\nwhereas this only updates when button :c is pressed:\n\njulia> Widgets.@map t ($(:c); :a[] + :b[])\nObservables.Observable{Int64}(\"ob_33\", 52, Any[])\n\n@map(x)\n\nCurried version of @map(d, x): anonymous function mapping d to @map(d, x).\n\n\n\n"
},

{
    "location": "custom_widgets.html#Widgets.@output!",
    "page": "Custom widgets",
    "title": "Widgets.@output!",
    "category": "macro",
    "text": "@output!(d, x)\n\nComputes Widgets.@map(d, x) and sets d.output to be the result (see Widgets.@map for more details). d.display is also set by default to match d.output. To have a custom display use @display!(d, expr) _after_ @output!(d, x)\n\n\n\n"
},

{
    "location": "custom_widgets.html#Widgets.@display!",
    "page": "Custom widgets",
    "title": "Widgets.@display!",
    "category": "macro",
    "text": "@display!(d, x)\n\nComputes Widgets.@map(d, x) and sets d.display to be the result (see Widgets.@map for more details).\n\n\n\n"
},

{
    "location": "custom_widgets.html#Widgets.@layout",
    "page": "Custom widgets",
    "title": "Widgets.@layout",
    "category": "macro",
    "text": "@layout(d, x)\n\nApply the expression x to the widget d, replacing e.g. symbol :s with the corresponding subwidget d[:s] To create a layout that updates automatically as some Widget or Observable updates, use $(:s). In this context, _ refers to the whole widget. To use actual symbols, escape them with ^, as in ^(:a).\n\nExamples\n\njulia> using DataStructures, InteractBase, CSSUtil\n\njulia> t = Widgets.Widget{:test}(OrderedDict(:vertical => Observable(true), :b => slider(1:100), :c => button()));\n\njulia> Widgets.@layout t vertical ? vbox(:b, CSSUtil.vskip(1em), :c) : hbox(:b, CSSUtil.hskip(1em), :c);\n\n@layout(x)\n\nCurried version of @layout(d, x): anonymous function mapping d to @layout(d, x).\n\n\n\n"
},

{
    "location": "custom_widgets.html#Widgets.@layout!",
    "page": "Custom widgets",
    "title": "Widgets.@layout!",
    "category": "macro",
    "text": "@layout!(d, x)\n\nSet d.layout to match the result of Widgets.@layout(x). See Widgets.@layout for more information.\n\nExamples\n\njulia> using DataStructures, InteractBase, CSSUtil\n\njulia> t = Widgets.Widget{:test}(OrderedDict(:b => slider(1:100), :c => button()));\n\njulia> @layout! t hbox(:b, CSSUtil.hskip(1em), :c);\n\n\n\n"
},

{
    "location": "custom_widgets.html#Widgets.@nodeps",
    "page": "Custom widgets",
    "title": "Widgets.@nodeps",
    "category": "macro",
    "text": "@nodeps(expr)\n\nMacro to remove need to depend on package X that defines a recipe to use it in one\'s own recipe. For example, InteractBase defines dropwdown recipe. To use dropdown in a recipe in a package, without depending on InteractBase, wrap the dropdown call in the @nodeps macro:\n\n@widget wdg function myrecipe(i)\n    :label = \"My recipe\"\n    :dropdown = Widgets.@nodeps dropdown(i)\nend\n\n\n\n"
},

{
    "location": "custom_widgets.html#Auxiliary-functions-1",
    "page": "Custom widgets",
    "title": "Auxiliary functions",
    "category": "section",
    "text": "Widgets.@map\n@output!\n@display!\nWidgets.@layout\n@layout!\nWidgets.@nodeps"
},

{
    "location": "custom_widgets.html#InteractBase.@manipulate",
    "page": "Custom widgets",
    "title": "InteractBase.@manipulate",
    "category": "macro",
    "text": "@manipulate expr\n\nThe @manipulate macro lets you play with any expression using widgets. expr needs to be a for loop. The for loop variable are converted to widgets using the widget function (ranges become slider, lists of options become togglebuttons, etc...). The for loop body is displayed beneath the widgets and automatically updated as soon as the widgets change value.\n\nUse throttle = df to only update the output after a small time interval dt (useful if the update is costly as it prevents multiple updates when moving for example a slider).\n\nExamples\n\nusing Colors\n\n@manipulate for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n\n@manipulate throttle = 0.1 for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n\n@layout! can be used to adjust the layout of a manipulate block:\n\nusing Widgets, CSSUtil, WebIO\n\nui = @manipulate throttle = 0.1 for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n@layout! ui dom\"div\"(_.display, vskip(2em), :r, :g, :b)\nui\n\n\n\n"
},

{
    "location": "custom_widgets.html#A-simpler-approach:-the-manipulate-macro-1",
    "page": "Custom widgets",
    "title": "A simpler approach: the manipulate macro",
    "category": "section",
    "text": "@manipulate"
},

{
    "location": "layout.html#",
    "page": "Layout",
    "title": "Layout",
    "category": "page",
    "text": ""
},

{
    "location": "layout.html#Layout-1",
    "page": "Layout",
    "title": "Layout",
    "category": "section",
    "text": "Several utilities are provided to create and align various web elements on the DOM."
},

{
    "location": "layout.html#Example-Usage-1",
    "page": "Layout",
    "title": "Example Usage",
    "category": "section",
    "text": "using Interact\n\nel1 =button(\"Hello world!\")\nel2 = button(\"Goodbye world!\")\n\nel3 = hbox(el1, el2) # aligns horizontally\nel4 = hline() # draws horizontal line\nel5 = vbox(el1, el2) # aligns vertically"
},

{
    "location": "deploying.html#",
    "page": "Deploying the web app",
    "title": "Deploying the web app",
    "category": "page",
    "text": ""
},

{
    "location": "deploying.html#Deploying-the-web-app-1",
    "page": "Deploying the web app",
    "title": "Deploying the web app",
    "category": "section",
    "text": "Interact works with the following frontends:Juno - The hottest Julia IDE\nIJulia - Jupyter notebooks (and Jupyter Lab) for Julia\nBlink - An Electron wrapper you can use to make Desktop apps\nMux - A web server framework"
},

{
    "location": "deploying.html#Jupyter-notebook/lab-and-Juno-1",
    "page": "Deploying the web app",
    "title": "Jupyter notebook/lab and Juno",
    "category": "section",
    "text": "Simply use display:using Interact\nui = button()\ndisplay(ui)Note that using Interact in Jupyter Lab requires installing an extension first:cd(Pkg.dir(\"WebIO\", \"assets\"))\n;jupyter labextension install webio\n;jupyter labextension enable webio/jupyterlab_entry"
},

{
    "location": "deploying.html#Electron-window-1",
    "page": "Deploying the web app",
    "title": "Electron window",
    "category": "section",
    "text": "To deploy the app as a standalone Electron window, one would use Blink.jl:using Interact, Blink\nw = Window()\nbody!(w, ui);"
},

{
    "location": "deploying.html#Browser-1",
    "page": "Deploying the web app",
    "title": "Browser",
    "category": "section",
    "text": "The app can also be served in a webpage:using Interact, Mux\nWebIO.webio_serve(page(\"/\", req -> ui), rand(8000:9000)) # serve on a random port"
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
    "text": "This tutorial is available in the Jupyter notebook format, togeter with other example notebooks, in the doc folder. To open Jupyter notebook in the correct folder simply type:using IJulia, Interact\nnotebook(dir = Interact.notebookdir)in your Julia REPL. You can also view it online here."
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
    "text": "using Interact\nui = button()\ndisplay(ui)Note that display works in a Jupyter notebook or in Atom/Juno IDE. Interact can also be deployed in Jupyter Lab, but that requires installing an extension first:cd(Pkg.dir(\"WebIO\", \"assets\"))\n;jupyter labextension install webio\n;jupyter labextension enable webio/jupyterlab_entryTo deploy the app as a standalone Electron window, one would use Blink.jl:using Blink\nw = Window()\nbody!(w, ui);The app can also be served in a webpage via Mux.jl:using Mux\nWebIO.webio_serve(page(\"/\", req -> ui), rand(8000:9000)) # serve on a random port"
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
    "text": "Once you have grasped this paradigm, you can play with any of the many widgets available:filepicker() |> display # observable is the path of selected file\ntextbox(\"Write here\") |> display # observable is the text typed in by the user\nautocomplete([\"Mary\", \"Jane\", \"Jack\"]) |> display # as above, but you can autocomplete words\ncheckbox(label = \"Check me!\") |> display # observable is a boolean describing whether it\'s ticked\ntoggle(label = \"I have read and agreed\") |> display # same as a checkbox but styled differently\nslider(1:100, label = \"To what extent?\", value = 33) |> display # Observable is the number selectedAs well as the option widgets, that allow to choose among options:dropdown([\"a\", \"b\", \"c\"]) |> display # Observable is option selected\ntogglebuttons([\"a\", \"b\", \"c\"]) |> display # Observable is option selected\nradiobuttons([\"a\", \"b\", \"c\"]) |> display # Observable is option selectedThe option widgets can also take as input a dictionary (ordered dictionary is preferrable, to avoid items getting scrambled), in which case the label displays the key while the observable stores the value:s = dropdown(OrderedDict(\"a\" => \"Value 1\", \"b\" => \"Value 2\"))\ndisplay(s)observe(s)[]"
},

{
    "location": "tutorial.html#Creating-custom-widgets-1",
    "page": "Tutorial",
    "title": "Creating custom widgets",
    "category": "section",
    "text": "Interact allows the creation of custom composite widgets starting from simpler ones. Let\'s say for example that we want to create a widget that has three sliders and a color that is updated to match the RGB value we gave with the sliders.import Colors\nusing Plots\n\n@widget wdg function mycolorpicker()\n    :r = slider(0:255, label = \"red\")\n    :g = slider(0:255, label = \"green\")\n    :b = slider(0:255, label = \"blue\")\n    @output! wdg Colors.RGB($(:r)/255, $(:g)/255, $(:b)/255)\n    @display! wdg plot(sin, color = $(_.output)) ## choose how to display the output, optional\n    @layout! wdg hbox(_.display, vbox(:r, :g, :b)) ## custom layout: by default things are stacked vertically\nendAnd now you can simply instantiate the widget withmycolorpicker()Note the $(:r) syntax: it means automatically update the widget as soon as the slider changes value. See Widgets.@map for more details. If instead we wanted to only update the plot when a button is pressed we would do:@widget wdg function mycolorpicker()\n    :r = slider(0:255, label = \"red\")\n    :g = slider(0:255, label = \"green\")\n    :b = slider(0:255, label = \"blue\")\n    :update = button(\"Update plot\")\n    @output! wdg ($(:update); Colors.RGB(:r[]/255, :g[]/255, :b[]/255))\n    @display! wdg plot(sin, color = $(_.output)) ## choose how to display the output, optional\n    @layout! wdg hbox(_.display, vbox(:r, :g, :b, :update)) ## custom layout: by default things are stacked vertically\nend"
},

{
    "location": "tutorial.html#A-simpler-approach-for-simpler-cases-1",
    "page": "Tutorial",
    "title": "A simpler approach for simpler cases",
    "category": "section",
    "text": "While the approach sketched above works for all sorts of situations, there is a specific marcro to simplify it in some specific case. If you just want to update some result (maybe a plot) as a function of some parameters (discrete or continuous) simply write @manipulate before the for loop. Discrete parameters will be replaced by togglebuttons and continuous parameters by slider: the result will be updated as soon as you click on a button or move the slider:width, height = 700, 300\ncolors = [\"black\", \"gray\", \"silver\", \"maroon\", \"red\", \"olive\", \"yellow\", \"green\", \"lime\", \"teal\", \"aqua\", \"navy\", \"blue\", \"purple\", \"fuchsia\"]\ncolor(i) = colors[i%length(colors)+1]\nui = @manipulate for nsamples in 1:200,\n        sample_step in slider(0.01:0.01:1.0, value=0.1, label=\"sample step\"),\n        phase in slider(0:0.1:2pi, value=0.0, label=\"phase\"),\n        radii in 0.1:0.1:60\n    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]\n    cys = sin.(cxs_unscaled) .* height/3 .+ height/2\n    cxs = cxs_unscaled .* width/4pi\n    dom\"svg:svg[width=$width, height=$height]\"(\n        (dom\"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(color(i))]\"()\n            for i in 1:nsamples)...\n    )\nendor, if you want a plot with some variables taking discrete values:using Plots\n\nx = y = 0:0.1:30\n\nfreqs = OrderedDict(zip([\"pi/4\", \"π/2\", \"3π/4\", \"π\"], [π/4, π/2, 3π/4, π]))\n\nmp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label=\"freq2\")\n    y = @. sin(freq1*x) * sin(freq2*x)\n    plot(x, y)\nend"
},

{
    "location": "tutorial.html#Widget-layout-1",
    "page": "Tutorial",
    "title": "Widget layout",
    "category": "section",
    "text": "To create a full blown web-app, you should learn the layout tools that the CSS framework you are using provides. Both Bulma and UIkit have modern layout tools for responsive design (of course, use Bulma if you\'re working with the Bulma backend and UIkit if you\'re working with the UIkit backend). You can use WebIO to create from Julia the HTML required to create these layouts.However, this can be overwhelming at first (especially for users with no prior experience in web design). A simpler solution is CSSUtil, a package that provides some tools to create simple layouts.loadbutton = filepicker()\nhellobutton = button(\"Hello!\")\ngoodbyebutton = button(\"Good bye!\")\nui = vbox( # put things one on top of the other\n    loadbutton,\n    hbox( # put things one next to the other\n        pad(1em, hellobutton), # to allow some white space around the widget\n        pad(1em, goodbyebutton),\n    )\n)\ndisplay(ui)"
},

{
    "location": "tutorial.html#Update-widgets-as-function-of-other-widgets-1",
    "page": "Tutorial",
    "title": "Update widgets as function of other widgets",
    "category": "section",
    "text": "Sometimes the full structure of the GUI is not known in advance. For example, let\'s imagine we want to load a DataFrame and create a button per column. Not to make it completely trivial, as soon as a button is pressed, we want to plot a histogram of the corresponding column.Important note: this app needs to run in Blink, as the browser doesn\'t allow us to get access to the local path of a file.We start by adding a filepicker to choose the file, and only once we have a file we want to update the GUI. this can be done as follows:loadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())columnbuttons is the div object that will contain all the relevant buttons. it is an Observable as we want its value to change over time. To add behavior, we can use map!:using CSV, DataFrames\ndata = Observable{Any}(DataFrame)\nmap!(CSV.read, data, observe(loadbutton))Now as soon as a file is uploaded, the Observable data gets updated with the correct value. Now, as soon as data is updated, we want to update our buttons.function makebuttons(df)\n    buttons = button.(names(df))\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)Note that data is already an Observable, so there\'s no need to do observe(data), observe can only be applied on a widget. We are almost done, we only need to add a callback to the buttons. The cleanest way is to do it during button initialization, meaning during our makebuttons step:using Plots\nplt = Observable{Any}(plot()) # the container for our plot\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, observe(btn))\n    end\n    dom\"div\"(hbox(buttons))\nendTo put it all together:using CSV, DataFrames, Interact, Plots\nloadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())\ndata = Observable{Any}(DataFrame)\nplt = Observable{Any}(plot())\nmap!(CSV.read, data, observe(loadbutton))\n\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, observe(btn))\n    end\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)\n\nui = dom\"div\"(loadbutton, columnbuttons, plt)And now to serve it in Blink:using Blink\nw = Window()\nbody!(w, ui)This page was generated using Literate.jl."
},

]}
