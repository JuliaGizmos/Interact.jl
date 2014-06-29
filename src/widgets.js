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
	sendUpdate: undefined
    };

    var Slider = function (typ, id, init) {
	var attr = { type:  "range",
		     value: init.value,
		     min:   init.start,
		     max:   init.stop,
		     step:  init.step },
	    elem = createElem("input", attr),
	    self = this;

	elem.onchange = function () {
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this); // Initialize communication
    }
    Slider.prototype = Widget;

    var Checkbox = function (typ, id, init) {
	var attr = { type: "checkbox",
		     checked: init.value },
	    elem = createElem("input", attr),
	    self = this;

	this.getState = function () {
	    return elem.checked;
	}
	elem.onchange = function () {
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this);
    }
    Checkbox.prototype = Widget;

    var Button = function (typ, id, init) {
	var attr = { type:    "button",
		     value:   init.label },
	    elem = createElem("input", attr),
	    self = this;
	this.getState = function () {
	    return null;
	}
	elem.onclick = function () {
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this);
    }
    Button.prototype = Widget;

    var Text = function (typ, id, init) {
	var attr = { type:  "text",
		     placeholder: init.label,
		     value: init.value },
	    elem = createElem("input", attr),
	    self = this;
	this.getState = function () {
	    return elem.value;
	}
	elem.onkeyup = function () {
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this);
    }
    Text.prototype = Widget;

    var Textarea = function (typ, id, init) {
	var attr = { placeholder: init.label },
	    elem = createElem("textarea", attr, init.value),
	    self = this;
	this.getState = function () {
	    return elem.value;
	}
	elem.onchange = function () {
	    self.sendUpdate();
	}

	this.id = id;
	this.elem = elem;
	this.label = init.label;

	InputWidgets.commInitializer(this);
    }
    Textarea.prototype = Widget;
    
    // RadioButtons
    // Dropdown
    // HTML
    // Latex

    var InputWidgets = {
	Slider: Slider,
	Checkbox: Checkbox,
	Button: Button,
	Text: Text,
	Textarea: Textarea,
	debug: false,
	log: function () {
	    if (InputWidgets.debug) {
		console.log.apply(console, arguments);
	    }
	},
	// a central way to initalize communication
	// for widgets.
	commInitializer: function (widget) {
	    widget.sendUpdate = function () {};
	}
    };

    window.InputWidgets = InputWidgets;

})(jQuery, undefined);
