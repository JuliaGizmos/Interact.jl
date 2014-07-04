
type Container{t}
    objects::Vector
end

typealias Elem Any # This is anything that can be displayed

empty() = Container(Dict(), Elem[])
elem(obj) = Container{:elem}([obj])
flow(t :: Symbol, objects::Any)
