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
    // a getState() method which returns the value to be sent to the backend
    // a sendUpdate() method which sends its current value to the backend
    var Widget = {
	id: undefined,
	elem: undefined,
	label: undefined,
	getState: function () {
	    return this.elem.value;
	},
	sendUpdate: function () {
	}
    };

    var Slider = function (typ, id, init) {
	var attr = { type:  "range",
		     value: init.value,
		     min:   init.min,
		     max:   init.max,
		     step:  init.step },
	    elem = createElem("input", attr),
	    self = this;

	elem.onchange = function () {
	    console.log("state change", self.getState());
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this); // Initialize communication
    }
    Slider.prototype = Widget;

    var InputWidgets = {
	Slider: Slider,
	// a central way to initalize communication
	// for widgets.
	commInitializer: function (widget) {
	    widget.sendUpdate = function () {};
	}
    };

    window.InputWidgets = InputWidgets;

})(jQuery, undefined);
