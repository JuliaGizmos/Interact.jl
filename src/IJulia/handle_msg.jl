
function handle_msg(w::InputWidget, msg)
    if msg.content["data"]["method"] == "backbone"
        recv(w, msg.content["data"]["sync_data"]["value"])
    end
end

function handle_msg{T}(w::Button{T}, msg)
    try
        if msg.content["data"]["method"] == "custom" &&
            msg.content["data"]["content"]["event"] == "click"
            # click event occured
            recv(w, convert(T, w.value))
        end
    catch e
        warn(string("Couldn't handle Button message ", e))
    end
end

function handle_msg{view}(w::Options{view}, msg)
    try
        if msg.content["data"]["method"] == "backbone"
            key = msg.content["data"]["sync_data"]["value_name"]
            if haskey(w.options, key)
                recv(w, w.options[key])
            end
        end
    catch e
        warn(string("Couldn't handle ", view, " message ", e))
    end
end
