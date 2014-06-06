
module Interact

import Base: mimewritable, writemime
export InputWidget, Slider, ToggleButton, Button, Text, Textarea,
       NumberText, RadioButtons, Dropdown, HTML, Latex, set_debug,
       attach!, detach!

include("widgets.jl")


if isdefined(Main, :IJulia)
    include("js_setup.jl")
    include("ijulia_setup.jl")
end

end # module
