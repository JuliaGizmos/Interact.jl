(function (IPython, $) {
    var comm_manager = IPython.notebook.kernel.comm_manager;
    console.log(comm_manager);

    $([IPython.events]).on(
	'output_appended.OutputArea', function (event, type, value, md, toinsert) {
    	if (md && md.reactive) {
    	    toinsert.addClass("signal-" + md.comm_id);
    	    toinsert.data("type", type);
    	}
    });

    comm_manager.register_target("Signal", function (comm) {
    	comm.on_msg(function (msg) {
	    console.log("MSG", msg);
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
})(IPython, jQuery);
