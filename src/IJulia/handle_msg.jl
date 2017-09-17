import Interact.recv_msg

function handle_msg(w::InputWidget, msg)
    if msg.content["data"]["method"] == "update" &&
            haskey(msg.content["data"]["state"], "value") #sometimes it sends just selected_label, not value...
        IJulia.set_cur_msg(msg)
        recv_msg(w, msg.content["data"]["state"]["value"])
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

# keys2idx(x::OptionDict, ks) = findin(keys(s.options), ks)
idxs2keys(x::Interact.OptionDict, indexes) = collect(keys(s.options))[indexes .+ 1]

function handle_msg{view}(w::Options{view}, msg)
    if msg.content["data"]["method"] == "update" && haskey(msg.content["data"], "state")
            #sometimes it sends just selected_label, not value...
        IJulia.set_cur_msg(msg)
        if view == :SelectMultiple
            if haskey(msg.content["data"]["state"], "value")
                keys = msg.content["data"]["state"]["value"]
                if all(map(key->haskey(w.options, key), keys))
                    recv_msg(w, map(key->w.options[key], keys))
                end
            elseif haskey(msg.content["data"]["state"], "index")
                indexes = Array{Int}(msg.content["data"]["state"]["index"])
                w.index = indexes
                keys = idxs2keys(w.options, indexes)
                if all(map(key->haskey(w.options, key), keys))
                    recv_msg(w, map(key->w.options[key], keys))
                end
            end
        else
            s = msg.content["data"]["state"]
            if haskey(s, "index")
                idx = s["index"] + 1
                key = collect(Base.keys(w.options.dict))[idx]
            elseif haskey(s, "value")
                key = s["value"]
            end

            if haskey(w.options, key)
                w.value_label = key
                recv_msg(w, w.options[key])
            end
        end
    end
end
