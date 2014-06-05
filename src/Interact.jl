
module Interact

using React

import Base: mimewritable, writemime
export InputWidget, Slider, ToggleButton, Button, Text, Textarea,
       NumberText, RadioButtons, Dropdown, HTML, Latex


include("widgets.jl")


if isdefined(Main, :IJulia)
    include("ijulia_setup.jl")
end

end # module
