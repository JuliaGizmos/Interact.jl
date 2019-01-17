var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "#Interact-1",
    "page": "Introduction",
    "title": "Interact",
    "category": "section",
    "text": "Interact allows to create small GUIs in Julia based on web technology. These GUIs can be deployed in jupyter notebooks, in the Juno IDE plot pane, in an Electron window or in the browser.To understand how to use it go through the Tutorial. The tutorial is also available here as a Jupyter notebook.InteractBase, Knockout and WebIO provide the logic that allows the communication between Julia and Javascript and the organization of the widgets."
},

{
    "location": "#Overview-1",
    "page": "Introduction",
    "title": "Overview",
    "category": "section",
    "text": "Creating an app in Interact requires three ingredients:Observables: references that can listen to changes in other references\nWidgets: the graphical elements that make up the app\nLayout: tools to assemble together different widgetsTo get a quick overview of how these tools work together, go to Tutorial."
},

{
    "location": "#CSS-framework-1",
    "page": "Introduction",
    "title": "CSS framework",
    "category": "section",
    "text": "Interact widgets are by default styled with the Bulma CSS framework (the previously supported UIkit backend is now deprecated). Bulma is a pure CSS framework (no extra Javascript), which leaves Julia fully in control of manipulating the DOM (which in turn means less surface area for bugs).To use unstyled widgets in the middle of the session (or to style them again) simply do:settheme!(:nativehtml)\nsettheme!(:bulma)respectively."
},

{
    "location": "#Deployment-1",
    "page": "Introduction",
    "title": "Deployment",
    "category": "section",
    "text": "InteractBase works with the following frontends:Juno - The hottest Julia IDE\nIJulia - Jupyter notebooks (and Jupyter Lab) for Julia\nBlink - An Electron wrapper you can use to make Desktop apps\nMux - A web server frameworkSee Deploying the web app for instructions."
},

{
    "location": "observables/#",
    "page": "Observables",
    "title": "Observables",
    "category": "page",
    "text": ""
},

{
    "location": "observables/#Observables-1",
    "page": "Observables",
    "title": "Observables",
    "category": "section",
    "text": "Observables are like Refs but you can listen to changes.using Interact\n\nobservable = Observable(0)\n\nh = on(observable) do val\n    println(\"Got an update: \", val)\nend\n\nobservable[] = 42To get the value of an observable index it with no argumentsobservable[]To remove a handler use off with the return value of on:off(observable, h)"
},

{
    "location": "observables/#How-is-it-different-from-Reactive.jl?-1",
    "page": "Observables",
    "title": "How is it different from Reactive.jl?",
    "category": "section",
    "text": "The main difference is Signals are manipulated mostly by converting one signal to another. For example, with signals, you can construct a changing UI by creating a Signal of UI objects and rendering them as the signal changes. On the other hand, you can use an Observable both as an input and an output. You can arbitrarily attach outputs to inputs allowing structuring code in a signals-and-slots kind of pattern.Another difference is Observables are synchronous, Signals are asynchronous. Observables may be better suited for an imperative style of programming."
},

{
    "location": "observables/#API-1",
    "page": "Observables",
    "title": "API",
    "category": "section",
    "text": ""
},

{
    "location": "observables/#Observables.Observable",
    "page": "Observables",
    "title": "Observables.Observable",
    "category": "type",
    "text": "Like a Ref but updates can be watched by adding a handler using on.\n\n\n\n\n\n"
},

{
    "location": "observables/#Type-1",
    "page": "Observables",
    "title": "Type",
    "category": "section",
    "text": "Observable{T}"
},

{
    "location": "observables/#Observables.on-Tuple{Any,Observable}",
    "page": "Observables",
    "title": "Observables.on",
    "category": "method",
    "text": "on(f, o::AbstractObservable)\n\nAdds function f as listener to o. Whenever o\'s value is set via o[] = val f is called with val.\n\n\n\n\n\n"
},

{
    "location": "observables/#Observables.off-Tuple{Observable,Any}",
    "page": "Observables",
    "title": "Observables.off",
    "category": "method",
    "text": "off(o::AbstractObservable, f)\n\nRemoves f from listeners of o.\n\n\n\n\n\n"
},

{
    "location": "observables/#Base.setindex!-Tuple{Observable,Any}",
    "page": "Observables",
    "title": "Base.setindex!",
    "category": "method",
    "text": "o[] = val\n\nUpdates the value of an Observable to val and call its listeners.\n\n\n\n\n\n"
},

{
    "location": "observables/#Base.getindex-Tuple{Observable}",
    "page": "Observables",
    "title": "Base.getindex",
    "category": "method",
    "text": "o[]\n\nReturns the current value of o.\n\n\n\n\n\n"
},

{
    "location": "observables/#Observables.onany-Tuple{Any,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Observables.onany",
    "category": "method",
    "text": "onany(f, args...)\n\nCalls f on updates to any oservable refs in args. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n\n\n"
},

{
    "location": "observables/#Base.map!-Tuple{Any,Observable,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Base.map!",
    "category": "method",
    "text": "map!(f, o::Observable, args...)\n\nUpdates o with the result of calling f with values extracted from args. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n\n\n"
},

{
    "location": "observables/#Observables.connect!-Tuple{Observable,Observable}",
    "page": "Observables",
    "title": "Observables.connect!",
    "category": "method",
    "text": "connect!(o1::Observable, o2::Observable)\n\nForward all updates to o1 to o2\n\n\n\n\n\n"
},

{
    "location": "observables/#Base.map-Tuple{Any,Observable,Vararg{Any,N} where N}",
    "page": "Observables",
    "title": "Base.map",
    "category": "method",
    "text": "map(f, o::Observable, args...)\n\nCreates a new oservable ref which contains the result of f applied to values extracted from args. The second argument o must be an oservable ref for dispatch reasons. args may contain any number of Observable ojects. f will be passed the values contained in the refs as the respective argument. All other ojects in args are passed as-is.\n\n\n\n\n\n"
},

{
    "location": "observables/#Functions-1",
    "page": "Observables",
    "title": "Functions",
    "category": "section",
    "text": "on(f, o::Observable)\noff(o::Observable, f)\nBase.setindex!(o::Observable, val)\nBase.getindex(o::Observable)\nonany(f, os...)\nBase.map!(f, o::Observable, os...)\nconnect!(o1::Observable, o2::Observable)\nBase.map(f, o::Observable, os...; init)"
},

{
    "location": "observables/#Observables.@map",
    "page": "Observables",
    "title": "Observables.@map",
    "category": "macro",
    "text": "@map(expr)\n\nWrap AbstractObservables in & to compute expression expr using their value. The expression will be computed when @map is called and  every time the AbstractObservables are updated.\n\nExamples\n\njulia> a = Observable(2);\n\njulia> b = Observable(3);\n\njulia> c = Observables.@map &a + &b;\n\njulia> c[]\n5\n\njulia> a[] = 100\n100\n\njulia> c[]\n103\n\n\n\n\n\n"
},

{
    "location": "observables/#Observables.@map!",
    "page": "Observables",
    "title": "Observables.@map!",
    "category": "macro",
    "text": "@map!(d, expr)\n\nWrap AbstractObservables in & to compute expression expr using their value: the expression will be computed every time the AbstractObservables are updated and d will be set to match that value.\n\nExamples\n\njulia> a = Observable(2);\n\njulia> b = Observable(3);\n\njulia> c = Observable(10);\n\njulia> Observables.@map! c &a + &b;\n\njulia> c[]\n10\n\njulia> a[] = 100\n100\n\njulia> c[]\n103\n\n\n\n\n\n"
},

{
    "location": "observables/#Observables.@on",
    "page": "Observables",
    "title": "Observables.@on",
    "category": "macro",
    "text": "@on(expr)\n\nWrap AbstractObservables in & to execute expression expr using their value. The expression will be computed every time the AbstractObservables are updated.\n\nExamples\n\njulia> a = Observable(2);\n\njulia> b = Observable(3);\n\njulia> Observables.@on println(\"The sum of a+b is $(&a + &b)\");\n\njulia> a[] = 100;\nThe sum of a+b is 103\n\n\n\n\n\n"
},

{
    "location": "observables/#Macros-1",
    "page": "Observables",
    "title": "Macros",
    "category": "section",
    "text": "Interact.@map\nInteract.@map!\nInteract.@on"
},

{
    "location": "widgets/#",
    "page": "Widgets",
    "title": "Widgets",
    "category": "page",
    "text": ""
},

{
    "location": "widgets/#Widgets-1",
    "page": "Widgets",
    "title": "Widgets",
    "category": "section",
    "text": ""
},

{
    "location": "widgets/#What-is-a-widget?-1",
    "page": "Widgets",
    "title": "What is a widget?",
    "category": "section",
    "text": "A widget is simply some graphical component that we can generate from Julia and that has an output. The output of a widget is a Observable and can be accessed with observe.A Widget itself behaves pretty much like a Observable and the techniques discussed in Observables apply. For example:using Interact\ns = slider(1:100);\ns[]\nInteract.@on print(string(\"The value is \", &s))\ns[] = 12;"
},

{
    "location": "widgets/#InteractBase.spinbox",
    "page": "Widgets",
    "title": "InteractBase.spinbox",
    "category": "function",
    "text": "spinbox([range,] label=\"\"; value=nothing)\n\nCreate a widget to select numbers with placeholder label. An optional range first argument specifies maximum and minimum value accepted as well as the step.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.textbox",
    "page": "Widgets",
    "title": "InteractBase.textbox",
    "category": "function",
    "text": "textbox(hint=\"\"; value=\"\")\n\nCreate a text input area with an optional placeholder hint e.g. textbox(\"enter number:\"). Use typ=... to specify the type of text. For example typ=\"email\" or typ=password. Use multiline=true to display a textarea spanning several lines.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.textarea",
    "page": "Widgets",
    "title": "InteractBase.textarea",
    "category": "function",
    "text": "textarea(hint=\"\"; value=\"\")\n\nCreate a textarea with an optional placeholder hint e.g. textarea(\"enter number:\"). Use rows=... to specify how many rows to display\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.autocomplete",
    "page": "Widgets",
    "title": "InteractBase.autocomplete",
    "category": "function",
    "text": "autocomplete(options, label=\"\"; value=\"\")\n\nCreate a textbox input with autocomplete options specified by options, with value as initial value and label as label.\n\n\n\n\n\n"
},

{
    "location": "widgets/#Text-input-1",
    "page": "Widgets",
    "title": "Text input",
    "category": "section",
    "text": "These are widgets to select text input that\'s typed in by the user. For numbers use spinbox and for strings use textbox. String entries (textbox and autocomplete) are initialized as \"\", whereas spinbox defaults to nothing, which corresponds to the empty entry.spinbox\ntextbox\ntextarea\nautocomplete"
},

{
    "location": "widgets/#InteractBase.datepicker",
    "page": "Widgets",
    "title": "InteractBase.datepicker",
    "category": "function",
    "text": "datepicker(value::Union{Dates.Date, Observable, Nothing}=nothing)\n\nCreate a widget to select dates.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.timepicker",
    "page": "Widgets",
    "title": "InteractBase.timepicker",
    "category": "function",
    "text": "timepicker(value::Union{Dates.Time, Observable, Nothing}=nothing)\n\nCreate a widget to select times.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.colorpicker",
    "page": "Widgets",
    "title": "InteractBase.colorpicker",
    "category": "function",
    "text": "colorpicker(value::Union{Color, Observable}=colorant\"#000000\")\n\nCreate a widget to select colors.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.checkbox",
    "page": "Widgets",
    "title": "InteractBase.checkbox",
    "category": "function",
    "text": "checkbox(value::Union{Bool, AbstractObservable}=false; label)\n\nA checkbox. e.g. checkbox(label=\"be my friend?\")\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.toggle",
    "page": "Widgets",
    "title": "InteractBase.toggle",
    "category": "function",
    "text": "toggle(value::Union{Bool, AbstractObservable}=false; label)\n\nA toggle switch. e.g. toggle(label=\"be my friend?\")\n\n\n\n\n\n"
},

{
    "location": "widgets/#Type-input-1",
    "page": "Widgets",
    "title": "Type input",
    "category": "section",
    "text": "These are widgets to select a specific, non-text, type of input. So far, Date, Time, Color and Bool are supported. Types that allow a empty field (Date and Time) are initialized as nothing by default, whereas Color and Bool are initialized with the default HTML value (colorant\"black\" and false respectively).datepicker\ntimepicker\ncolorpicker\ncheckbox\ntoggle"
},

{
    "location": "widgets/#InteractBase.filepicker",
    "page": "Widgets",
    "title": "InteractBase.filepicker",
    "category": "function",
    "text": "filepicker(label=\"Choose a file...\"; multiple=false, accept=\"*\")\n\nCreate a widget to select files. If multiple=true the observable will hold an array containing the paths of all selected files. Use accept to only accept some formats, e.g. accept=\".csv\"\n\n\n\n\n\n"
},

{
    "location": "widgets/#File-input-1",
    "page": "Widgets",
    "title": "File input",
    "category": "section",
    "text": "filepicker"
},

{
    "location": "widgets/#InteractBase.slider",
    "page": "Widgets",
    "title": "InteractBase.slider",
    "category": "function",
    "text": "function slider(vals::AbstractArray;\n                value=medianelement(vals),\n                label=nothing, readout=true, kwargs...)\n\nCreates a slider widget which can take on the values in vals, and updates observable value when the slider is changed.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.rangeslider",
    "page": "Widgets",
    "title": "InteractBase.rangeslider",
    "category": "function",
    "text": "function rangeslider(vals::AbstractArray;\n                value=medianelement(vals),\n                label=nothing, readout=true, kwargs...)\n\nCreates a slider widget which can take on the values in vals and accepts several \"handles\". Pass a vector to value with two values if you want to select a range.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.rangepicker",
    "page": "Widgets",
    "title": "InteractBase.rangepicker",
    "category": "function",
    "text": "function rangepicker(vals::AbstractArray;\n                value=[extrema(vals)...],\n                label=nothing, readout=true, kwargs...)\n\nA multihandle slider with a set of spinboxes, one per handle.\n\n\n\n\n\n"
},

{
    "location": "widgets/#Range-input-1",
    "page": "Widgets",
    "title": "Range input",
    "category": "section",
    "text": "slider\nrangeslider\nrangepicker"
},

{
    "location": "widgets/#InteractBase.button",
    "page": "Widgets",
    "title": "InteractBase.button",
    "category": "function",
    "text": "button(content... = \"Press me!\"; value=0)\n\nA button. content goes inside the button. Note the button content supports a special clicks variable, that gets incremented by 1 with each click e.g.: button(\"clicked {{clicks}} times\"). The clicks variable is initialized at value=0\n\n\n\n\n\n"
},

{
    "location": "widgets/#Callback-input-1",
    "page": "Widgets",
    "title": "Callback input",
    "category": "section",
    "text": "button"
},

{
    "location": "widgets/#Widgets.input",
    "page": "Widgets",
    "title": "Widgets.input",
    "category": "function",
    "text": "input(o; typ=\"text\")\n\nCreate an HTML5 input element of type type (e.g. \"text\", \"color\", \"number\", \"date\") with o as initial value.\n\n\n\n\n\n"
},

{
    "location": "widgets/#HTML5-input-1",
    "page": "Widgets",
    "title": "HTML5 input",
    "category": "section",
    "text": "All of the inputs above are implemented wrapping the input tag of HTML5 which can be accessed more directly as follows:InteractBase.input"
},

{
    "location": "widgets/#InteractBase.dropdown",
    "page": "Widgets",
    "title": "InteractBase.dropdown",
    "category": "function",
    "text": "dropdown(options::AbstractDict;\n         value = first(values(options)),\n         label = nothing,\n         multiple = false)\n\nA dropdown menu whose item labels are the keys of options. If multiple=true the observable will hold an array containing the values of all selected items e.g. dropdown(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ndropdown(values::AbstractArray; kwargs...)\n\ndropdown with labels string.(values) see dropdown(options::AbstractDict; ...) for more details\n\n\n\n\n\ndropdown(options::AbstractObservable;\n         value = first(values(options[])),\n         label = nothing,\n         multiple = false)\n\nA dropdown menu whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = dropdown(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.radiobuttons",
    "page": "Widgets",
    "title": "InteractBase.radiobuttons",
    "category": "function",
    "text": "radiobuttons(options::AbstractDict;\n             value::Union{T, Observable} = first(values(options)))\n\ne.g. radiobuttons(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\nradiobuttons(values::AbstractArray; kwargs...)\n\nradiobuttons with labels string.(values) see radiobuttons(options::AbstractDict; ...) for more details\n\nradiobuttons(options::AbstractObservable; kwargs...)\n\nRadio buttons whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = radiobuttons(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.checkboxes",
    "page": "Widgets",
    "title": "InteractBase.checkboxes",
    "category": "function",
    "text": "checkboxes(options::AbstractDict;\n         value = first(values(options)))\n\nA list of checkboxes whose item labels are the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. checkboxes(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ncheckboxes(values::AbstractArray; kwargs...)\n\ncheckboxes with labels string.(values) see checkboxes(options::AbstractDict; ...) for more details\n\ncheckboxes(options::AbstractObservable; kwargs...)\n\nCheckboxes whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = checkboxes(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.toggles",
    "page": "Widgets",
    "title": "InteractBase.toggles",
    "category": "function",
    "text": "toggles(options::AbstractDict;\n         value = first(values(options)))\n\nA list of toggle switches whose item labels are the keys of options. Tthe observable will hold an array containing the values of all selected items, e.g. toggles(OrderedDict(\"good\"=>1, \"better\"=>2, \"amazing\"=>9001))\n\ntoggles(values::AbstractArray; kwargs...)\n\ntoggles with labels string.(values) see toggles(options::AbstractDict; ...) for more details\n\ntoggles(options::AbstractObservable; kwargs...)\n\nToggles whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = toggles(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.togglebuttons",
    "page": "Widgets",
    "title": "InteractBase.togglebuttons",
    "category": "function",
    "text": "togglebuttons(options::AbstractDict; value::Union{T, Observable})\n\nCreates a set of toggle buttons whose labels are the keys of options.\n\ntogglebuttons(values::AbstractArray; kwargs...)\n\ntogglebuttons with labels string.(values) see togglebuttons(options::AbstractDict; ...) for more details\n\ntogglebuttons(options::AbstractObservable; kwargs...)\n\nTogglebuttons whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = togglebuttons(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.tabs",
    "page": "Widgets",
    "title": "InteractBase.tabs",
    "category": "function",
    "text": "tabs(options::AbstractDict; value::Union{T, Observable})\n\nCreates a set of tabs whose labels are the keys of options. The label can be a link.\n\ntabs(values::AbstractArray; kwargs...)\n\ntabs with labels values see tabs(options::AbstractDict; ...) for more details\n\ntabs(options::AbstractObservable; kwargs...)\n\nTabs whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = tabs(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#Option-input-1",
    "page": "Widgets",
    "title": "Option input",
    "category": "section",
    "text": "dropdown\nradiobuttons\ncheckboxes\ntoggles\ntogglebuttons\ntabs"
},

{
    "location": "widgets/#InteractBase.latex",
    "page": "Widgets",
    "title": "InteractBase.latex",
    "category": "function",
    "text": "latex(txt)\n\nRender txt in LaTeX using KaTeX. Backslashes need to be escaped: latex(\"\\\\sum_{i=1}^{\\\\infty} e^i\")\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.alert",
    "page": "Widgets",
    "title": "InteractBase.alert",
    "category": "function",
    "text": "alert(text=\"\")\n\nCreates a Widget{:alert}. To cause it to trigger an alert, do:\n\nwdg = alert(\"Error!\")\nwdg()\n\nCalling wdg with a string will set the alert message to that string before triggering the alert:\n\nwdg = alert(\"Error!\")\nwdg(\"New error message!\")\n\nFor the javascript to work, the widget needs to be part of the UI, even though it is not visible.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.highlight",
    "page": "Widgets",
    "title": "InteractBase.highlight",
    "category": "function",
    "text": "highlight(txt; language = \"julia\")\n\nlanguage syntax highlighting for txt.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.notifications",
    "page": "Widgets",
    "title": "InteractBase.notifications",
    "category": "function",
    "text": "notifications(v=[]; layout = node(:div))\n\nDisplay elements of v inside notification boxes that can be closed with a close button. The elements are laid out according to layout. observe on this widget returns the observable of the list of elements that have not bein deleted.\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.togglecontent",
    "page": "Widgets",
    "title": "InteractBase.togglecontent",
    "category": "function",
    "text": "togglecontent(content, value::Union{Bool, Observable}=false; label)\n\nA toggle switch that, when activated, displays content e.g. togglecontent(checkbox(\"Yes, I am sure\"), false, label=\"Are you sure?\")\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.tabulator",
    "page": "Widgets",
    "title": "InteractBase.tabulator",
    "category": "function",
    "text": "tabulator(options::AbstractDict; index, key)\n\nCreates a set of toggle buttons whose labels are the keys of options. Displays the value of the selected option underneath. Use index::Int to select which should be the index of the initial option, or key::String. The output is the selected index. Use index=0 to not have any selected option.\n\nExamples\n\ntabulator(OrderedDict(\"plot\" => plot(rand(10)), \"scatter\" => scatter(rand(10))), index = 1)\ntabulator(OrderedDict(\"plot\" => plot(rand(10)), \"scatter\" => scatter(rand(10))), key = \"plot\")\n\ntabulator(values::AbstractArray; kwargs...)\n\ntabulator with labels values see tabulator(options::AbstractDict; ...) for more details\n\ntabulator(options::Observable; kwargs...)\n\nTabulator whose options are a given Observable. Set the Observable to some other value to update the options in real time.\n\nExamples\n\noptions = Observable([\"a\", \"b\", \"c\"])\nwdg = tabulator(options)\noptions[] = [\"c\", \"d\", \"e\"]\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#InteractBase.mask",
    "page": "Widgets",
    "title": "InteractBase.mask",
    "category": "function",
    "text": "mask(options; index, key)\n\nOnly display the index-th element of options. If options is a AbstractDict, it is possible to specify which option to show using key. options can be a Observable, in which case mask updates automatically. Use index=0 or key = nothing to not have any selected option.\n\nExamples\n\nwdg = mask(OrderedDict(\"plot\" => plot(rand(10)), \"scatter\" => scatter(rand(10))), index = 1)\nwdg = mask(OrderedDict(\"plot\" => plot(rand(10)), \"scatter\" => scatter(rand(10))), key = \"plot\")\n\nNote that the options can be modified from the widget directly:\n\nwdg[:options][] = [\"c\", \"d\", \"e\"]\n\n\n\n\n\n"
},

{
    "location": "widgets/#Output-1",
    "page": "Widgets",
    "title": "Output",
    "category": "section",
    "text": "latex\nalert\nhighlight\nInteractBase.notifications\ntogglecontent\ntabulator\nmask"
},

{
    "location": "widgets/#Widgets.widget",
    "page": "Widgets",
    "title": "Widgets.widget",
    "category": "function",
    "text": "widget(args...; kwargs...)\n\nAutomatically convert Julia types into appropriate widgets. kwargs are passed to the more specific widget function.\n\nExamples\n\nmap(display, [\n    widget(1:10),                 # Slider\n    widget(false),                # Checkbox\n    widget(\"text\"),               # Textbox\n    widget(1.1),                  # Spinbox\n    widget([:on, :off]),          # Toggle Buttons\n    widget(Dict(\"π\" => float(π), \"τ\" => 2π)),\n    widget(colorant\"red\"),        # Color picker\n    widget(Dates.today()),        # Date picker\n    widget(Dates.Time()),         # Time picker\n    ]);\n\n\n\n\n\n"
},

{
    "location": "widgets/#Create-widgets-automatically-from-a-Julia-variable-1",
    "page": "Widgets",
    "title": "Create widgets automatically from a Julia variable",
    "category": "section",
    "text": "widget"
},

{
    "location": "custom_widgets/#",
    "page": "Custom widgets",
    "title": "Custom widgets",
    "category": "page",
    "text": ""
},

{
    "location": "custom_widgets/#Custom-widgets-1",
    "page": "Custom widgets",
    "title": "Custom widgets",
    "category": "section",
    "text": "Besides the standard widgets, Interact provides a framework to define custom GUIs. This is currently possible with two approaches, the full featured Widget type and the simple to use but more basic @manipulate macro."
},

{
    "location": "custom_widgets/#Widgets.@layout!",
    "page": "Custom widgets",
    "title": "Widgets.@layout!",
    "category": "macro",
    "text": "@layout!(d, x)\n\nSet d.layout to match the result of Widgets.@layout(x). See Widgets.@layout for more information.\n\nExamples\n\njulia> using Interact\n\njulia> t = Widget{:test}(OrderedDict(:b => slider(1:100), :c => button()));\n\njulia> @layout! t hbox(:b, CSSUtil.hskip(1em), :c);\n\n\n\n\n\n"
},

{
    "location": "custom_widgets/#Widgets.@layout",
    "page": "Custom widgets",
    "title": "Widgets.@layout",
    "category": "macro",
    "text": "@layout(d, x)\n\nApply the expression x to the widget d, replacing e.g. symbol :s with the corresponding subwidget d[:s] In this context, _ refers to the whole widget. To use actual symbols, escape them with ^, as in ^(:a). @layout can be combined with @map to have the layout update interactively as function of some widget.\n\nExamples\n\njulia> using Interact\n\njulia> cpt = OrderedDict(:vertical => Observable(true), :b => slider(1:100), :c => button());\n\njulia> t = Widget{:test}(cpt, output = observe(cpt[:b]));\n\njulia> Widgets.@layout t vbox(:b, CSSUtil.vskip(1em), :c);\n\njulia> Widgets.@layout t Widgets.@map &(:vertical) ? vbox(:b, CSSUtil.vskip(1em), :c) : hbox(:b, CSSUtil.hskip(1em), :c);\n\nUse @layout! to set the widget layout in place:\n\njulia> @layout! t Widgets.@map &(:vertical) ? vbox(:b, CSSUtil.vskip(1em), :c) : hbox(:b, CSSUtil.hskip(1em), :c);\n\n@layout(x)\n\nCurried version of @layout(d, x): anonymous function mapping d to @layout(d, x).\n\n\n\n\n\n"
},

{
    "location": "custom_widgets/#The-Widget-type-1",
    "page": "Custom widgets",
    "title": "The Widget type",
    "category": "section",
    "text": "The Widget type can be used to create custom widgets. The types is parametric, with the parameter being the name of the widget and it takes as argument a OrderedDict of children.For example:d = OrderedDict(:label => \"My label\", :button => button(\"My button\"))\nw = Widget{:mywidget}(d)Children can be accessed and modified using getindex and setindex! on the Widget object:println(w[:label])\nw[:label] = \"A new label\"Optionally, the Widget can have some output, which should be an Observable:d = OrderedDict(:label => \"My label\", :button => button(\"My button\"))\noutput = map(t -> t > 5 ? \"You pressed me many times\" : \"You didn\'t press me enough\", d[:button])\nw = Interact.Widget{:mywidget}(d, output = output)Finally the @layout! macro allows us to set the layout of the widget:@layout! w hbox(vbox(:label, :button), observe(_)) # observe(_) refers to the output of the widget@layout!\nInteract.@layout"
},

{
    "location": "custom_widgets/#Widgets.@nodeps",
    "page": "Custom widgets",
    "title": "Widgets.@nodeps",
    "category": "macro",
    "text": "@nodeps(expr)\n\nMacro to remove need to depend on package X that defines a recipe to use it in one\'s own recipe. For example, InteractBase defines dropwdown recipe. To use dropdown in a recipe in a package, without depending on InteractBase, wrap the dropdown call in the @nodeps macro:\n\nfunction myrecipe(i)\n    label = \"My recipe\"\n    wdg = Widgets.@nodeps dropdown(i)\n    Widget([\"label\" => label, \"dropdown\" => wdg])\nend\n\n\n\n\n\n"
},

{
    "location": "custom_widgets/#Defining-custom-widgets-without-depending-on-Interact-1",
    "page": "Custom widgets",
    "title": "Defining custom widgets without depending on Interact",
    "category": "section",
    "text": "Widgets.@nodeps"
},

{
    "location": "custom_widgets/#InteractBase.@manipulate",
    "page": "Custom widgets",
    "title": "InteractBase.@manipulate",
    "category": "macro",
    "text": "@manipulate expr\n\nThe @manipulate macro lets you play with any expression using widgets. expr needs to be a for loop. The for loop variable are converted to widgets using the widget function (ranges become slider, lists of options become togglebuttons, etc...). The for loop body is displayed beneath the widgets and automatically updated as soon as the widgets change value.\n\nUse throttle = df to only update the output after a small time interval dt (useful if the update is costly as it prevents multiple updates when moving for example a slider).\n\nExamples\n\nusing Colors\n\n@manipulate for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n\n@manipulate throttle = 0.1 for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n\n@layout! can be used to adjust the layout of a manipulate block:\n\nusing Interact\n\nui = @manipulate throttle = 0.1 for r = 0:.05:1, g = 0:.05:1, b = 0:.05:1\n    HTML(string(\"<div style=\'color:#\", hex(RGB(r,g,b)), \"\'>Color me</div>\"))\nend\n@layout! ui dom\"div\"(observe(_), vskip(2em), :r, :g, :b)\nui\n\n\n\n\n\n"
},

{
    "location": "custom_widgets/#A-simpler-approach:-the-manipulate-macro-1",
    "page": "Custom widgets",
    "title": "A simpler approach: the manipulate macro",
    "category": "section",
    "text": "@manipulate"
},

{
    "location": "modifiers/#",
    "page": "Modifiers",
    "title": "Modifiers",
    "category": "page",
    "text": ""
},

{
    "location": "modifiers/#InteractBase.tooltip!",
    "page": "Modifiers",
    "title": "InteractBase.tooltip!",
    "category": "function",
    "text": "tooltip!(wdg::AbstractWidget, tooltip; className = \"\")\n\nExperimental. Add a tooltip to widget wdg. tooltip is the text that will be shown and className can be used to customize the tooltip, for example is-tooltip-bottom or is-tooltip-danger.\n\n\n\n\n\n"
},

{
    "location": "modifiers/#InteractBase.onchange",
    "page": "Modifiers",
    "title": "InteractBase.onchange",
    "category": "function",
    "text": "onchange(w::AbstractWidget, change = w[:changes])\n\nReturn a widget that\'s identical to w but only updates on change. For a slider it corresponds to releasing it and for a textbox it corresponds to losing focus.\n\nExamples\n\nsld = slider(1:100) |> onchange # update on release\ntxt = textbox(\"Write here\") |> onchange # update on losing focuse\n\n\n\n\n\n"
},

{
    "location": "modifiers/#Modifiers-1",
    "page": "Modifiers",
    "title": "Modifiers",
    "category": "section",
    "text": "Interact provides some modifiers to change an existing widget (or return a tranformed version of the widget):InteractBase.tooltip!\nonchange"
},

{
    "location": "layout/#",
    "page": "Layout",
    "title": "Layout",
    "category": "page",
    "text": ""
},

{
    "location": "layout/#Layout-1",
    "page": "Layout",
    "title": "Layout",
    "category": "section",
    "text": "Several utilities are provided to create and align various web elements on the DOM."
},

{
    "location": "layout/#Example-Usage-1",
    "page": "Layout",
    "title": "Example Usage",
    "category": "section",
    "text": "using Interact\n\nel1 =button(\"Hello world!\")\nel2 = button(\"Goodbye world!\")\n\nel3 = hbox(el1, el2) # aligns horizontally\nel4 = hline() # draws horizontal line\nel5 = vbox(el1, el2) # aligns vertically"
},

{
    "location": "deploying/#",
    "page": "Deploying the web app",
    "title": "Deploying the web app",
    "category": "page",
    "text": ""
},

{
    "location": "deploying/#Deploying-the-web-app-1",
    "page": "Deploying the web app",
    "title": "Deploying the web app",
    "category": "section",
    "text": "Interact works with the following frontends:Juno - The hottest Julia IDE\nIJulia - Jupyter notebooks (and Jupyter Lab) for Julia\nBlink - An Electron wrapper you can use to make Desktop apps\nMux - A web server framework"
},

{
    "location": "deploying/#Jupyter-notebook/lab-and-Juno-1",
    "page": "Deploying the web app",
    "title": "Jupyter notebook/lab and Juno",
    "category": "section",
    "text": "Simply use display:using Interact\nui = button()\ndisplay(ui)Note that using Interact in Jupyter Lab requires installing an extension first:cd(Pkg.dir(\"WebIO\", \"assets\"))\n;jupyter labextension install webio\n;jupyter labextension enable webio/jupyterlab_entry"
},

{
    "location": "deploying/#Electron-window-1",
    "page": "Deploying the web app",
    "title": "Electron window",
    "category": "section",
    "text": "To deploy the app as a standalone Electron window, one would use Blink.jl:using Interact, Blink\nw = Window()\nbody!(w, ui);"
},

{
    "location": "deploying/#Browser-1",
    "page": "Deploying the web app",
    "title": "Browser",
    "category": "section",
    "text": "The app can also be served in a webpage:using Interact, Mux\nWebIO.webio_serve(page(\"/\", req -> ui), rand(8000:9000)) # serve on a random port"
},

{
    "location": "tutorial/#",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "page",
    "text": "EditURL = \"https://github.com/JuliaGizmos/Interact.jl/blob/master/docs/src/tutorial.jl\""
},

{
    "location": "tutorial/#Tutorial-1",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "section",
    "text": "This tutorial is available in the Jupyter notebook format, togeter with other example notebooks, in the doc folder. To open Jupyter notebook in the correct folder simply type:using IJulia, Interact\nnotebook(dir = Interact.notebookdir)in your Julia REPL. You can also view it online here."
},

{
    "location": "tutorial/#Installing-everything-1",
    "page": "Tutorial",
    "title": "Installing everything",
    "category": "section",
    "text": "To install Interact, simply typePkg.add(\"Interact\")in the REPL.The basic behavior is as follows: Interact provides a series of widgets. Each widget has an output that can be directly inspected or used to trigger some callbacks (i.e. run some code as soon as the widget changes value): the abstract supertype that gives this behavior is called AbstractObservable. Let\'s see this in practice."
},

{
    "location": "tutorial/#Displaying-a-widget-1",
    "page": "Tutorial",
    "title": "Displaying a widget",
    "category": "section",
    "text": "using Interact\nui = button()\ndisplay(ui)Note that display works in a Jupyter notebook or in Atom/Juno IDE. Interact can also be deployed in Jupyter Lab, but that requires installing an extension first:cd(Pkg.dir(\"WebIO\", \"assets\"))\n;jupyter labextension install webio\n;jupyter labextension enable webio/jupyterlab_entryTo deploy the app as a standalone Electron window, one would use Blink.jl:using Blink\nw = Window()\nbody!(w, ui);The app can also be served in a webpage via Mux.jl:using Mux\nWebIO.webio_serve(page(\"/\", req -> ui), rand(8000:9000)) # serve on a random port"
},

{
    "location": "tutorial/#Adding-behavior-1",
    "page": "Tutorial",
    "title": "Adding behavior",
    "category": "section",
    "text": "The value of our button can be inspected using getindex:ui[]In the case of a button, the observable represents the number of times it has been clicked: click on it and check the value again. For now however this button doesn\'t do anything. This can be changed by adding callbacks to it.To add some behavior to the widget we can use the on construct. on takes two arguments, a function and an AbstractObservable. As soon as the observable is changed, the function is called with the latest value.on(println, ui)If you click again on the button you will see it printing the number of times it has been clicked so far.Tip: anonymous function are very useful in this programming paradigm. For example, if you want the button to say \"Hello!\" when pressed, you should use:on(n -> println(\"Hello!\"), ui)Tip n. 2: using the [] syntax you can also set the value of the widget:ui[] = 33;"
},

{
    "location": "tutorial/#Observables:-the-implementation-of-a-widget\'s-output-1",
    "page": "Tutorial",
    "title": "Observables: the implementation of a widget\'s output",
    "category": "section",
    "text": "The updatable container that only has the output of the widget but not the widget itself is a Observable and can be accessede using observe(ui), though it should normally not be necessary to do so. To learn more about Observables and AbstractObservable, check out their documentation here."
},

{
    "location": "tutorial/#What-widgets-are-there?-1",
    "page": "Tutorial",
    "title": "What widgets are there?",
    "category": "section",
    "text": "Once you have grasped this paradigm, you can play with any of the many widgets available:filepicker() |> display # value is the path of selected file\ntextbox(\"Write here\") |> display # value is the text typed in by the user\nautocomplete([\"Mary\", \"Jane\", \"Jack\"]) |> display # as above, but you can autocomplete words\ncheckbox(label = \"Check me!\") |> display # value is a boolean describing whether it\'s ticked\ntoggle(label = \"I have read and agreed\") |> display # same as a checkbox but styled differently\nslider(1:100, label = \"To what extent?\", value = 33) |> display # value is the number selectedAs well as the option widgets, that allow to choose among options:dropdown([\"a\", \"b\", \"c\"]) |> display # value is option selected\ntogglebuttons([\"a\", \"b\", \"c\"]) |> display # value is option selected\nradiobuttons([\"a\", \"b\", \"c\"]) |> display # value is option selectedThe option widgets can also take as input a dictionary (ordered dictionary is preferrable, to avoid items getting scrambled), in which case the label displays the key while the output stores the value:s = dropdown(OrderedDict(\"a\" => \"Value 1\", \"b\" => \"Value 2\"))\ndisplay(s)s[]"
},

{
    "location": "tutorial/#Creating-custom-widgets-1",
    "page": "Tutorial",
    "title": "Creating custom widgets",
    "category": "section",
    "text": "Interact allows the creation of custom composite widgets starting from simpler ones. Let\'s say for example that we want to create a widget that has three sliders and a color that is updated to match the RGB value we gave with the sliders.import Colors\nusing Plots\n\nfunction mycolorpicker()\n    r = slider(0:255, label = \"red\")\n    g = slider(0:255, label = \"green\")\n    b = slider(0:255, label = \"blue\")\n    output = Interact.@map Colors.RGB(&r/255, &g/255, &b/255)\n    plt = Interact.@map plot(sin, color = &output)\n    wdg = Widget([\"r\" => r, \"g\" => g, \"b\" => b], output = output)\n    @layout! wdg hbox(plt, vbox(:r, :g, :b)) ## custom layout: by default things are stacked vertically\nendAnd now you can simply instantiate the widget withmycolorpicker()Note the &r syntax: it means automatically update the widget as soon as the slider changes value. See Interact.@map for more details. If instead we wanted to only update the plot when a button is pressed we would do:function mycolorpicker()\n    r = slider(0:255, label = \"red\")\n    g = slider(0:255, label = \"green\")\n    b = slider(0:255, label = \"blue\")\n    update = button(\"Update plot\")\n    output = Interact.@map (&update; Colors.RGB(r[]/255, g[]/255, b[]/255))\n    plt = Interact.@map plot(sin, color = &output)\n    wdg = Widget([\"r\" => r, \"g\" => g, \"b\" => b, \"update\" => update], output = output)\n    @layout! wdg hbox(plt, vbox(:r, :g, :b, :update)) ## custom layout: by default things are stacked vertically\nend"
},

{
    "location": "tutorial/#A-simpler-approach-for-simpler-cases-1",
    "page": "Tutorial",
    "title": "A simpler approach for simpler cases",
    "category": "section",
    "text": "While the approach sketched above works for all sorts of situations, there is a specific marcro to simplify it in some specific case. If you just want to update some result (maybe a plot) as a function of some parameters (discrete or continuous) simply write @manipulate before the for loop. Discrete parameters will be replaced by togglebuttons and continuous parameters by slider: the result will be updated as soon as you click on a button or move the slider:width, height = 700, 300\ncolors = [\"black\", \"gray\", \"silver\", \"maroon\", \"red\", \"olive\", \"yellow\", \"green\", \"lime\", \"teal\", \"aqua\", \"navy\", \"blue\", \"purple\", \"fuchsia\"]\ncolor(i) = colors[i%length(colors)+1]\nui = @manipulate for nsamples in 1:200,\n        sample_step in slider(0.01:0.01:1.0, value=0.1, label=\"sample step\"),\n        phase in slider(0:0.1:2pi, value=0.0, label=\"phase\"),\n        radii in 0.1:0.1:60\n    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]\n    cys = sin.(cxs_unscaled) .* height/3 .+ height/2\n    cxs = cxs_unscaled .* width/4pi\n    dom\"svg:svg[width=$width, height=$height]\"(\n        (dom\"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(color(i))]\"()\n            for i in 1:nsamples)...\n    )\nendor, if you want a plot with some variables taking discrete values:using Plots\n\nx = y = 0:0.1:30\n\nfreqs = OrderedDict(zip([\"pi/4\", \"π/2\", \"3π/4\", \"π\"], [π/4, π/2, 3π/4, π]))\n\nmp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label=\"freq2\")\n    y = @. sin(freq1*x) * sin(freq2*x)\n    plot(x, y)\nend"
},

{
    "location": "tutorial/#Widget-layout-1",
    "page": "Tutorial",
    "title": "Widget layout",
    "category": "section",
    "text": "To create a full blown web-app, you should learn the layout tools that the CSS framework you are using provides. See for example the columns and layout section of the Bulma docs. You can use WebIO to create from Julia the HTML required to create these layouts.However, this can be overwhelming at first (especially for users with no prior experience in web design). A simpler solution is CSSUtil, a package that provides some tools to create simple layouts.loadbutton = filepicker()\nhellobutton = button(\"Hello!\")\ngoodbyebutton = button(\"Good bye!\")\nui = vbox( # put things one on top of the other\n    loadbutton,\n    hbox( # put things one next to the other\n        pad(1em, hellobutton), # to allow some white space around the widget\n        pad(1em, goodbyebutton),\n    )\n)\ndisplay(ui)"
},

{
    "location": "tutorial/#Update-widgets-as-function-of-other-widgets-1",
    "page": "Tutorial",
    "title": "Update widgets as function of other widgets",
    "category": "section",
    "text": "Sometimes the full structure of the GUI is not known in advance. For example, let\'s imagine we want to load a DataFrame and create a button per column. Not to make it completely trivial, as soon as a button is pressed, we want to plot a histogram of the corresponding column.Important note: this app needs to run in Blink, as the browser doesn\'t allow us to get access to the local path of a file.We start by adding a filepicker to choose the file, and only once we have a file we want to update the GUI. this can be done as follows:loadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())columnbuttons is the div object that will contain all the relevant buttons. it is an Observable as we want its value to change over time. To add behavior, we can use map!:using CSV, DataFrames\ndata = Observable{Any}(DataFrame)\nmap!(CSV.read, data, loadbutton)Now as soon as a file is uploaded, the Observable data gets updated with the correct value. Now, as soon as data is updated, we want to update our buttons.function makebuttons(df)\n    buttons = button.(names(df))\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)We are almost done, we only need to add a callback to the buttons. The cleanest way is to do it during button initialization, meaning during our makebuttons step:using Plots\nplt = Observable{Any}(plot()) # the container for our plot\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, btn)\n    end\n    dom\"div\"(hbox(buttons))\nendTo put it all together:using CSV, DataFrames, Interact, Plots\nloadbutton = filepicker()\ncolumnbuttons = Observable{Any}(dom\"div\"())\ndata = Observable{Any}(DataFrame)\nplt = Observable{Any}(plot())\nmap!(CSV.read, data, loadbutton)\n\nfunction makebuttons(df)\n    buttons = button.(string.(names(df)))\n    for (btn, name) in zip(buttons, names(df))\n        map!(t -> histogram(df[name]), plt, btn)\n    end\n    dom\"div\"(hbox(buttons))\nend\n\nmap!(makebuttons, columnbuttons, data)\n\nui = dom\"div\"(loadbutton, columnbuttons, plt)And now to serve it in Blink:using Blink\nw = Window()\nbody!(w, ui)This page was generated using Literate.jl."
},

]}
