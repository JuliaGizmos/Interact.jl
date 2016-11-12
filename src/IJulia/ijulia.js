
(function (IPython, $, _, MathJax) {
    $.event.special.destroyed = {
	remove: function(o) {
	    if (o.handler) {
		o.handler.apply(this, arguments)
	    }
	}
    }

    var OutputArea = IPython.version >= "4.0.0" ? require("notebook/js/outputarea").OutputArea : IPython.OutputArea;

    var redrawValue = function (container, type, val) {
	var selector = $("<div/>");
	var oa = new OutputArea(_.extend(selector, {
	    selector: selector,
	    prompt_area: true,
	    events: IPython.events,
	    keyboard_manager: IPython.keyboard_manager
	})); // Hack to work with IPython 2.1.0

	switch (type) {
	case "image/png":
            var _src = 'data:' + type + ';base64,' + val;
	    $(container).find("img").attr('src', _src);
	    break;
	default:
	    var toinsert = OutputArea.append_map[type].apply(
		oa, [val, {}, selector]
	    );
	    $(container).empty().append(toinsert.contents());
	    selector.remove();
	}
	if (type === "text/latex" && MathJax) {
	    MathJax.Hub.Queue(["Typeset", MathJax.Hub, toinsert.get(0)]);
	}
    }


    $(document).ready(function() {
	function initComm(evt, data) {
	    var comm_manager = data.kernel.comm_manager;
        //_.extend(comm_manager.targets, require("widgets/js/widget"))
	    comm_manager.register_target("Signal", function (comm) {
            comm.on_msg(function (msg) {
                var val = msg.content.data.value;
                $(".signal-" + comm.comm_id).each(function() {
                var type = $(this).data("type");
                if (typeof(val[type]) !== "underfined" && val[type] !== null) {
                    redrawValue(this, type, val[type], type);
                }
                });
                delete val;
                delete msg.content.data.value;
            });
	    });

	    // coordingate with Comm and redraw Signals
	    // XXX: Test using Reactive here to improve performance
	    $([IPython.events]).on(
		'output_appended.OutputArea', function (event, type, value, md, toinsert) {
		    if (md && md.reactive) {
                // console.log(md.comm_id);
                toinsert.addClass("signal-" + md.comm_id);
                toinsert.data("type", type);
                // Signal back indicating the mimetype required
                var comm_manager = IPython.notebook.kernel.comm_manager;
                var comm = comm_manager.comms[md.comm_id];
                comm.then(function (c) {
                    c.send({action: "subscribe_mime",
                       mime: type});
                    toinsert.bind("destroyed", function() {
                        c.send({action: "unsubscribe_mime",
                               mime: type});
                    });
                })
		    }
	    });
	}

	try {
	    // try to initialize right away. otherwise, wait on the status_started event.
	    initComm(undefined, IPython.notebook);
	} catch (e) {
	    $([IPython.events]).on('kernel_created.Kernel kernel_created.Session', initComm);
	}
    });
})(IPython, jQuery, _, MathJax);
