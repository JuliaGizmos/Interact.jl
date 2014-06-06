(function ($, undefined) {

    function createElem(tag, attr, content) {
	// TODO: remove jQuery dependency
	var el = $("<" + tag + "/>").attr(attr);
	if (content) {
	    el.append(content);
	}
	return el[0];
    }

    // A widget must expose an id field which identifies it to the backend,
    // an elem attribute which is will be added to the DOM, and
    // a getState method which returns the value to be sent to the backend
    var Widget = {
	id: undefined,
	elem: undefined,
	getState: function () {
	    return this.elem.value;
	}
    };

    var Slider = function (typ, id, init) {
	var attr = { type: "range",
		     value: init.value,
		     min:   init.min,
		     max:   init.max };
	elem = createElem("input", attr);

	elem.onchange = InputWidgets.updateSender(this);

	this.id = id;
	this.elem = elem;
    }
    Slider.prototype = Widget;

    var InputWidgets = {
	Slider: Slider,
	setCommHandler: function (f) {
	    // TODO: wrap f to throttle
	    InputWidgets._communicate = f;
	},
	updateSender: function (widget) {
	    return function () {
		InputWidgets._communicate(widget);
	    };
	},
	_communicate: function (widget) {
	    console.log("State update (", widget.id, "):", widget.getState());
	}
    };

    window.InputWidgets = InputWidgets;

})(jQuery, undefined);
