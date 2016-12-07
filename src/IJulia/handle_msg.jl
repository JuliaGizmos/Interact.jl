import Interact.recv_msg

function handle_msg(w::InputWidget, msg)
    if msg.content["data"]["method"] == "backbone"
        IJulia.set_cur_msg(msg)
        recv_msg(w, msg.content["data"]["sync_data"]["value"])
    end
end

function handle_msg{T}(w::Button{T}, msg)
    try
        if msg.content["data"]["method"] == "custom" &&
            msg.content["data"]["content"]["event"] == "click"
            IJulia.set_cur_msg(msg)
            # click event occured
            recv_msg(w, convert(T, w.value))
        end
    catch e
        warn(string("Couldn't handle Button message ", e))
    end
end

function handle_msg{view}(w::Options{view}, msg)
        if msg.content["data"]["method"] == "backbone"
            IJulia.set_cur_msg(msg)
            if view == :SelectMultiple
                keys = msg.content["data"]["sync_data"]["value"]
                if map(key->haskey(w.options, key), keys) |> all
                    recv_msg(w, map(key->w.options[key], keys))
                end
            else
                key = string(msg.content["data"]["sync_data"]["value"])
                if haskey(w.options, key)
                    recv_msg(w, w.options[key])
                end
            end
        end
end
