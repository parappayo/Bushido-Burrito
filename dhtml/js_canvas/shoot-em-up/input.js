//------------------------------------------------------------------------------
//  input handling
//
//  found some useful help here:
//  http://www.javascriptkit.com/javatutors/
//------------------------------------------------------------------------------

var gInputHandlers = [];

//------------------------------------------------------------------------------
//  key code definitions
//------------------------------------------------------------------------------

var KEY_UP = 38;
var KEY_DOWN = 40;
var KEY_LEFT = 37;
var KEY_RIGHT = 39;
var KEY_SPACE = 32;

//------------------------------------------------------------------------------
document.onkeypress = function(e) {

	var evt = window.event ? event : e; // IE compatible
	var code = evt.keyCode;
	//var key = String.fromCharCode(code);
	
	for (var i in gInputHandlers) {
		gInputHandlers[i].handleKeyPress(code);
	}
}

//------------------------------------------------------------------------------
document.onkeydown = function(e) {

	var evt = window.event ? event : e; // IE compatible
	var code = evt.keyCode;
	//var key = String.fromCharCode(code);
	
	for (var i in gInputHandlers) {
		gInputHandlers[i].handleKeyDown(code);
	}
}

//------------------------------------------------------------------------------
document.onkeyup = function(e) {

	var evt = window.event ? event : e; // IE compatible
	var code = evt.keyCode;
	//var key = String.fromCharCode(code);
	
	for (var i in gInputHandlers) {
		gInputHandlers[i].handleKeyUp(code);
	}
}

