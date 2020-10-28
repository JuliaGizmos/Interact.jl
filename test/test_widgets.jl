using Interact, Blink, Colors

w = Window()

#---
f = filepicker(label = "Upload");
body!(w, f)
observe(f)
#---

f = filepicker(multiple = true, accept = ".csv");
display(f)
observe(f)
#---
s = Interact.input("Write here")
body!(w, s)
observe(s)
#---
s = textbox("Write here", value = "A", className="is-danger")
body!(w, s)
observe(s)
#---
s = autocomplete(["Opt 1", "Option 2", "Opt 3"], "Write here")
body!(w, s)
observe(s)
opentools(w)
#---
v = Observable(RGB(1,0,0))
s = colorpicker(v)
body!(w, s)
observe(s)
#---
s1 = slider(1:20, style = Dict("width"=>"400px"))
sobs = observe(s1)
body!(w, vbox(s1, sobs));
#---
s1 = slider(vcat(0, exp10.(range(-2, stop = 2, length = 50))), label = "Log slider")
sobs = observe(s1)
body!(w, vbox(s1, sobs));
#---
button1 = button("button one {{clicks}}")
num_clicks = observe(button1)
button2 = button("button two {{clicks}}", value = num_clicks)
body!(w, hbox(button1, button2, num_clicks));
#---
body!(w, button(label = "Press!"))
#---
v = checkbox(label = "Agree")
body!(w, v)
observe(v)
#---
v = toggle(true, "Agree", className="is-danger")
body!(w, v)
observe(v)
#---
v = checkboxes(["A", "B", "C"]);
body!(w, v)
observe(v)
#---
v = toggles(["A", "B", "C"], className="is-danger");
body!(w, v)
observe(v)
#---
using WebIO, Blink, Observables

width, height = 700, 300
colors = ["black", "gray", "silver", "maroon", "red", "olive", "yellow", "green", "lime", "teal", "aqua", "navy", "blue", "purple", "fuchsia"]
_color(i) = colors[i%length(colors)+1]
ui = @manipulate for nsamples in 1:200,
        sample_step in slider(0.01:0.01:1.0, value=0.1, label="sample step"),
        phase in slider(0:0.1:2pi, value=0.0, label="phase"),
        radii in 0.1:0.1:60,
        show_image in true,
        s in Observable(true)
    cxs_unscaled = [i*sample_step + phase for i in 1:nsamples]
    cys = sin.(cxs_unscaled) .* height/3 .+ height/2
    cxs = cxs_unscaled .* width/4pi
    show_image ? dom"svg:svg[width=$width, height=$height]"(
        (dom"svg:circle[cx=$(cxs[i]), cy=$(cys[i]), r=$radii, fill=$(_color(i))]"()
            for i in 1:nsamples)...
    ) : dom"div"("Nothing to see here")
end
body!(w, ui)
opentools(w)
#---

using Plots

x = y = 0:0.1:30

freqs = OrderedDict(zip(["pi/4", "π/2", "3π/4", "π"], [π/4, π/2, 3π/4, π]))

mp = @manipulate for freq1 in freqs, freq2 in slider(0.01:0.1:4π; label="freq2")
    y = @. sin(freq1*x) * sin(freq2*x)
    plot(x, y)
end
body!(w, mp)

#---
s = dropdown(["a1", "a2nt", "a3"], label = "test")
body!(w, s)
observe(s)
#---

s = togglebuttons(["a1", "a2nt", "a3"], label = "x");
body!(w, s)
observe(s)
#---

s = radiobuttons(["a1", "a2nt", "a3"]);
display(s)
observe(s)
#---
# IJulia
ui = s
display(ui);
# Mux
using Mux
webio_serve(page("/", req -> ui))
#---
