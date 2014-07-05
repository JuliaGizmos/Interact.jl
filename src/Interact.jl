
module Interact

import Base: mimewritable, writemime
export attach!, detach!, register_widget, get_widget, parse, recv

include("widgets.jl")
include("html_setup.jl")

end # module
