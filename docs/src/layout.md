# Layout

Several utilities are provided to create and align
various web elements on the DOM.

## Example Usage
```julia
using Interact

el1 =button("Hello world!")
el2 = button("Goodbye world!")

el3 = hbox(el1, el2) # aligns horizontally
el4 = hline() # draws horizontal line
el5 = vbox(el1, el2) # aligns vertically
```
