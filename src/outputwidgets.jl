
import Base: writemime
export HTML, Latex

type HTML <: Widget
    value::String
end

# assume we already have HTML
writemime(io::IO, m::MIME{symbol("text/html")}, h::HTML) =
    write(io, h.value)

type Latex <: Widget
    value::String
end

# assume we already have Latex
writemime(io::IO, m::MIME{symbol("application/x-latex")}, l::Latex) =
    write(io, l.value)
