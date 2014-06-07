# IJulia specific code goes here.
# Assume IJulia is running

const ijulia_js  = readall(joinpath(dirname(Base.source_path()), "ijulia.js"))

try
    display("text/html", """<script charset="utf-8">$(ijulia_js)</script>""")
catch
end

using  Main.IJulia
using  Main.IJulia.CommManager
import Main.IJulia.CommManager: register_comm
import Main.IJulia: metadata

export register_comm

const comms = Dict{Int, Comm}()
const signals = Dict{String, Signal}()

function send_update(comm :: Comm, v)
    # do this better!!
    # Thoughts:
    #    Queue upto 3, buffer others
    #    Diff and send
    #    Is display_dict the right thing?
    send_comm(comm, ["value" => Main.IJulia.display_dict(v)])
end


function Main.IJulia.metadata(x :: Signal)
    if ~haskey(comms, x.id)
        # One Comm channel per signal object
        comm = Comm("Signal")

        comms[x.id] = comm   # Backend -> Comm
        signals[comm.id] = x # Comm -> Backend

        # prevent resending the first time?
        lift(v -> send_update(comm, v), x)
    else
        comm = comms[x.id]
    end
    return ["reactive"=>true, "comm_id"=>comm.id]
end

Main.IJulia.display_dict(x :: Signal) =
    Main.IJulia.display_dict(x.value)

# Render the value of a signal.
mimewritable(m :: MIME, s :: Signal) =
    mimewritable(m, s.value)


writemime(m :: MIME, s :: Signal) =
    writemime(m, s.value)

import Base.convert

function register_comm(comm :: Comm{:InputWidget}, msg)
    w_id = msg.content["data"]["widget_id"]

    w = get_widget(w_id)

    function recv_value(msg)
        v =  msg.content["data"]["value"]
        recv(w, parse(v, w))
    end

    on_msg(comm, recv_value)
end
