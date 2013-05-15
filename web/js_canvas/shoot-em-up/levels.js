//------------------------------------------------------------------------------
//  levels.js - level timeline logic and data
//------------------------------------------------------------------------------

"use strict";

//------------------------------------------------------------------------------
var gLevel1 = {
	0: {	"time" : 0,
		"action" : function() { new Enemy1(); } },

	1: {	"time" : 50,
		"action" : function() { new Enemy1(); } },

	2: {	"time" : 100,
		"action" : function() { new Enemy1(); } },

	3: {	"time" : 150,
		"action" : function() { new Enemy1(); } },
}

//------------------------------------------------------------------------------
function LevelManager() {

	this.init();

	this.currentLevel = new Array();
	this.t = 0;
	this.eventIndex = 0;
	this.levelDone = false;
}
LevelManager.inherits(Actor);

//------------------------------------------------------------------------------
LevelManager.method('update', function() {

	this.t += 1;

	if (this.levelDone) { return; }

	if (this.eventIndex >= this.currentLevel.length) {
		this.levelDone = true;
		return;
	}

	while (true) {

		var levelEvent = this.currentLevel[this.eventIndex];
		if (levelEvent == undefined) { break; }

		if (levelEvent.time == undefined) {
			this.eventIndex += 1;
			continue;
		}

		if (this.t >= levelEvent.time) {
			levelEvent.action();
			this.eventIndex += 1;
			continue;
		}

		break;
	}	
});

//------------------------------------------------------------------------------
LevelManager.method('startLevel', function(level) {

	// TODO: should scrub gActors here to clean-up from the last level

	this.currentLevel = new Array();
	this.t = 0;
	this.eventIndex = 0;
	this.levelDone = false;

	for (var i in level) {
		this.currentLevel.push(level[i]);
	}
});

