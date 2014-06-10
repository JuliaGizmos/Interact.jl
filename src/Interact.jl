
module Interact

import Base: mimewritable, writemime
export InputWidget, Slider, ToggleButton, Button, Checkbox, Text, Textarea,
       RadioButtons, Dropdown, HTML, Latex, set_debug,  attach!, detach!,
       register_widget, get_widget, parse, recv


include("widgets.jl")
include("html_setup.jl")


end # module
