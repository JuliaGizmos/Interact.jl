(function (IPython, $, _, Widgets) {
    $.event.special.destroyed = {
	remove: function(o) {
	    if (o.handler) {
		o.handler.apply(this, arguments)
	    }
	}
    }

    $(document).ready(function() {
	Widgets.debug = false; // log messages etc in console.
	function initComm(evt, data) {
	    var comm_manager = data.kernel.comm_manager;
	    comm_manager.register_target("Signal", function (comm) {
		comm.on_msg(function (msg) {
		    //Widgets.log("message received", msg);
		    var val = msg.content.data.value;
		    $(".signal-" + comm.comm_id).each(function() {
			var self = this;
			var type = $(this).data("type");
			if (val[type]) {
			    var selector = $(self).empty();
			    var oa = new IPython.OutputArea(_.extend(selector, {
				selector: selector,
				prompt_area: true,
				events: IPython.events,
				keyboard_manager: IPython.keyboard_manager
			    })); // Hack to work with IPython 2.1.0
			    var toinsert = IPython.OutputArea.append_map[type].apply(
				oa, [val[type], {}, selector]
			    );
			    delete toinsert;
			}
		    });
		    delete val;
		    delete msg.content.data.value;
		});
	    });

	    // coordingate with Comm and redraw Signals
	    // XXX: Test using React here to improve performance
	    $([IPython.events]).on(
		'output_appended.OutputArea', function (event, type, value, md, toinsert) {
		    if (md && md.reactive) {
			// console.log(md.comm_id);
			toinsert.addClass("signal-" + md.comm_id);
			toinsert.data("type", type);
			// Signal back indicating the mimetype required
			var comm_manager = IPython.notebook.kernel.comm_manager;
			var comm = comm_manager.comms[md.comm_id];
			comm.send({action: "subscribe_mime",
				   mime: type});
			toinsert.bind("destroyed", function() {
			    comm.send({action: "unsubscribe_mime",
				       mime: type});
			});
		    }
	    });

	    // Set up communication for Widgets
	    Widgets.commInitializer = function (widget) {
		var comm = comm_manager.new_comm(
		    "InputWidget", {widget_id: widget.id}
		);
		widget.sendUpdate = function () {
		    // `this` is a widget here.
		    // TODO: I have a feeling there's some
		    //       IPython bookkeeping to be done here.
		    // Widgets.log("State changed", this, this.getState());
		    comm.send({value: this.getState()});
		}
	    };
	}

	try {
	    // try to initialize right away. otherwise, wait on the status_started event.
	    initComm(undefined, IPython.notebook);
	} catch (e) {
	    $([IPython.events]).on('status_started.Kernel', initComm);
	}
    });
})(IPython, jQuery, _, InputWidgets);
