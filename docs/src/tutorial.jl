# # Tutorial
#md #
#md # This tutorial is available in the Jupyter notebook format, together with other example notebooks, in the doc folder.
#md # To open the Jupyter notebook in the correct folder, simply type:
#md # ```julia
#md # using IJulia, Interact
#md # notebook(dir = Interact.notebookdir)
#md # ```
#md # in your Julia REPL. You can also view it online [here](https://github.com/JuliaGizmos/Interact.jl/blob/master/doc/notebooks/tutorial.ipynb).
#
# ## Installing everything
#
# To install Interact, simply type
# ```julia
# Pkg.add("Interact")
# ```

# in the REPL.
#
# The basic behavior is as follows: Interact provides a series of widgets. Each widget has an output that can be directly inspected, or used to trigger some callbacks (i.e. run some code as soon as the widget changes value). The abstract supertype that gives this behavior is called `AbstractObservable`. Let's see this in practice.
#
# ## Displaying a widget
using Interact
ui = button()
display(ui)

# Note that `display` works in a [Jupyter notebook](https://github.com/JuliaLang/IJulia.jl) or in [Atom/Juno IDE](https://github.com/JunoLab/Juno.jl).
# Interact can also be deployed in Jupyter Lab, but that requires installing an extension first:
using Pkg
Pkg.add("WebIO")
using WebIO
cd(joinpath(dirname(pathof(WebIO)), "..", "packages"))
;jupyter labextension link webio
;jupyter labextension install jupyter-lab-provider
# To deploy the app as a standalone Electron window, one would use [Blink.jl](https://github.com/JunoLab/Blink.jl):
using Blink
w = Window()
body!(w, ui);
# The app can also be served in a webpage via [Mux.jl](https://github.com/JuliaWeb/Mux.jl):
using Mux
WebIO.webio_serve(page("/", req -> ui), rand(8000:9000)) # serve on a random port
#
# ## Adding behavior
# The value of our button can be inspected using `getindex`:
ui[]
# In the case of a button, the observable represents the number of times it has been clicked: click on it and check the value again.
# This button doesn't do anything yet, but we can add callbacks to it.
#
# To add some behavior to the widget, we can use the `on` construct. `on` takes two arguments: a function, and an `AbstractObservable`. As soon as the observable is changed, the function is called with the latest value.
on(println, ui)
# Now when you click on the button, Julia will print the number of times it has been clicked in total.
#
# *Tip*: anonymous functions are very useful in this programming paradigm. For example, if you want the button to say "Hello!" when pressed, you should use:
on(n -> println("Hello!"), ui)
#
# *Tip n. 2*: using the `[]` syntax you can also set the value of the widget:
ui[] = 33;

# ### Observables: the implementation of a widget's output
# The updatable container that only has the output of the widget, but not the widget itself, is a `Observable`. It is accessible via `observe(ui)`, but you should normally not need to access it in this way.
# To learn more about `Observables` and `AbstractObservable`, check out their documentation [here](https://juliagizmos.github.io/Observables.jl/latest/).

# ## What widgets are there?
#
# Now that you've got the big idea, you can play with the many widgets available:
filepicker() |> display # value is the path of selected file
textbox("Write here") |> display # value is the text typed in by the user
autocomplete(["Mary", "Jane", "Jack"]) |> display # as above, but you can autocomplete words
checkbox(label = "Check me!") |> display # value is a boolean describing whether it's ticked
toggle(label = "I have read and agreed") |> display # same as a checkbox but styled differently
slider(1:100; label="To what extent?", value=33) |> display # value is the number selected

# Option widgets allow the user to choose among specified options:

dropdown(["a", "b", "c"]) |> display # value is option selected
togglebuttons(["a", "b", "c"]) |> display # value is option selected
radiobuttons(["a", "b", "c"]) |> display # value is option selected

# Option widgets can also take as input a dictionary (ordered dictionary is preferable, to avoid items getting scrambled), in which case the label displays the key, while the output stores the value:

s = dropdown(OrderedDict("a" => "Value 1", "b" => "Value 2"))
display(s)
#-
s[]
#
# ## Creating custom widgets
#
# Interact allows the creation of custom composite widgets starting from simpler ones.
# Suppose we want to create a widget with separate R, G, and B sliders, and we wish to display the color corresponding to the combined RGB value.

import Colors
using Plots

function mycolorpicker()
    r = slider(0:255, label="red")
    g = slider(0:255, label="green")
    b = slider(0:255, label="blue")
    output = Interact.@map Colors.RGB(&r / 255, &g / 255, &b / 255)
    plt = Interact.@map plot(sin, color = &output)
    wdg = Widget(["r" => r, "g" => g, "b" => b], output = output)
    @layout! wdg hbox(plt, vbox(:r, :g, :b)) ## custom layout: by default things are stacked vertically
end

# Simply instantiate the widget with
mycolorpicker()
# Note the `&r` syntax: it means automatically update the widget as soon as the
# slider changes value. See [`Interact.@map`](@ref) for more details.
# If instead we wanted to only update the plot when a button is pressed, we would do:
function mycolorpicker()
    r = slider(0:255, label="red")
    g = slider(0:255, label="green")
    b = slider(0:255, label="blue")
    update = button("Update plot")
    output = Interact.@map (&update; Colors.RGB(r[] / 255, g[] / 255, b[] / 255))
    plt = Interact.@map plot(sin, color = &output)
    wdg = Widget(["r" => r, "g" => g, "b" => b, "update" => update], output = output)
    @layout! wdg hbox(plt, vbox(:r, :g, :b, :update)) ## custom layout: by default things are stacked vertically
end

# ## A simpler approach for simpler cases
#
# While the approach sketched above works in many situations, there is a specific macro to simplify it in one specific case. If you just want to update some result (likely a plot) as a function of some parameters (discrete or continuous), simply write `@manipulate` before a `for` loop. Discrete parameters will be replaced by `togglebuttons`, and continuous parameters by `slider`s: the result will be updated as soon as you interact with any button or slider:
#
width, height = 700, 300
colors = ["black", "gray", "silver", "maroon", "red", "olive", "yellow", "green", "lime", "teal", "aqua", "navy", "blue", "purple", "fuchsia"]
color(i) = colors[i%length(colors)+1]
ui = @manipulate for nsamples in 1:200,
        sample_step in slider(0.01:0.01:1.0; value=0.1, label="sample step"),
        phase in slider(0:0.1:2pi; value=0.0, label="phase"),
        radii in 0.1:0.1:60
    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]
    cys = sin.(cxs_unscaled) .* height / 3 .+ height / 2
    cxs = cxs_unscaled .* width / 4pi
    dom"svg:svg[width=$width, height=$height]"(
        (dom"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(color(i))]"()
            for i in 1:nsamples)...
    )
end
# or, if you want a plot with some variables taking discrete values:
using Plots

x = y = 0:0.1:30

freqs = OrderedDict(zip(["pi/4", "π/2", "3π/4", "π"], [π / 4, π / 2, 3π / 4, π]))

mp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label="freq2")
    y = @. sin(freq1 * x) * sin(freq2 * x)
    plot(x, y)
end

# ## Widget layout
#
# To create a full-blown web app, you should learn the layout tools provided by the CSS framework you are using. See for example the [columns](https://bulma.io/documentation/columns/) and [layout](https://bulma.io/documentation/layout/) sections of the Bulma docs. You can use [WebIO](https://github.com/JuliaGizmos/WebIO.jl) to create, from Julia, the HTML required to create these layouts.
#
# This can be overwhelming at first, especially for users with no prior experience in web design. A simpler solution comes with [CSSUtil](https://github.com/JuliaGizmos/CSSUtil.jl):
loadbutton = filepicker()
hellobutton = button("Hello!")
goodbyebutton = button("Good bye!")
ui = vbox( # put things one on top of the other
    loadbutton,
    hbox( # put things one next to the other
        pad(1em, hellobutton), # to allow some white space around the widget
        pad(1em, goodbyebutton),
    )
)
display(ui)
#
# ## Update widgets as function of other widgets
#
# Sometimes the full structure of the GUI is not known in advance. For example, imagine we want to load a DataFrame and create one button per column. When a button is pressed, we want to plot a histogram of the corresponding column.
#
# *Important note*: this app needs to run in Blink, as the browser doesn't allow us to get access to the local path of a file.
#
# We start by adding a `filepicker` to choose the file, and only once we have a file we want to update the GUI. this can be done as follows:
loadbutton = filepicker()
columnbuttons = Observable{Any}(dom"div"())
# `columnbuttons` is the `div` object that will contain all the relevant buttons. it is an `Observable` as we want its value to change over time.
# To add behavior, we can use `map!`:
using CSV, DataFrames
data = Observable{Any}(DataFrame)
map!(CSV.read, data, loadbutton)
#
# Now as soon as a file is uploaded, the `Observable` `data` gets updated with the correct value. Now, as soon as `data` is updated, we want to update our buttons.
function makebuttons(df)
    buttons = button.(names(df))
    dom"div"(hbox(buttons))
end

map!(makebuttons, columnbuttons, data)
# We are almost done, we only need to add a callback to the buttons. The cleanest way is to do it during button initialization, meaning during our `makebuttons` step:
using Plots
plt = Observable{Any}(plot()) # the container for our plot
function makebuttons(df)
    buttons = button.(string.(names(df)))
    for (btn, name) in zip(buttons, names(df))
        map!(t -> histogram(df[name]), plt, btn)
    end
    dom"div"(hbox(buttons))
end
#
# To put it all together:
using CSV, DataFrames, Interact, Plots
loadbutton = filepicker()
columnbuttons = Observable{Any}(dom"div"())
data = Observable{Any}(DataFrame)
plt = Observable{Any}(plot())
map!(CSV.read, data, loadbutton)

function makebuttons(df)
    buttons = button.(string.(names(df)))
    for (btn, name) in zip(buttons, names(df))
        map!(t -> histogram(df[name]), plt, btn)
    end
    dom"div"(hbox(buttons))
end

map!(makebuttons, columnbuttons, data)

ui = dom"div"(loadbutton, columnbuttons, plt)
#
# And now to serve it in Blink:
using Blink
w = Window()
body!(w, ui)
