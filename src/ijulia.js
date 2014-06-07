(function (IPython, $, Widgets) {

    Widgets.debug = true; // log messages etc in console.
    var comm_manager = IPython.notebook.kernel.comm_manager;

    // coordingate with Comm and redraw Signals
    // XXX: Test using React here to improve performance
    $([IPython.events]).on(
	'output_appended.OutputArea', function (event, type, value, md, toinsert) {
    	if (md && md.reactive) {
    	    toinsert.addClass("signal-" + md.comm_id);
    	    toinsert.data("type", type);
    	}
    });

    comm_manager.register_target("Signal", function (comm) {
    	comm.on_msg(function (msg) {
	    Widgets.log("message received", msg);
    	    var val = msg.content.data.value;
    	    $(".signal-" + comm.comm_id).each(function() {
    		var self = this;
    		var type = $(this).data("type");
    		if (val[type]) {
    		    var oa = new IPython.OutputArea();
    		    var toinsert = IPython.OutputArea.append_map[type].apply(
    			oa, [val[type], {}, $("<div/>")]
    		    );
    		    $(self).html(toinsert.html());
    		}
    	    });
    	});
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
	    Widgets.log("State changed", this, this.getState());
	    comm.send({value: this.getState()});
	}
    };
})(IPython, jQuery, InputWidgets);
