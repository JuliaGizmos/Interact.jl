
import Base: writemime
export HTML


type HTML <: Widget{String}
    value :: String
end

# assume we already have HTML
writemime(io::IO, m::MIME{symbol("text/html")}, h::HTML) =
    write(io, h.value)
