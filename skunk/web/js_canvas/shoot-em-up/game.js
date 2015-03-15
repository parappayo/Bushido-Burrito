//------------------------------------------------------------------------------
//  game.js - main game logic
//------------------------------------------------------------------------------

"use strict";

var img;  // holds the sprite sheet
var gPlayer;
var gLevelManager;

//------------------------------------------------------------------------------
//  called when the document is finished loading
//------------------------------------------------------------------------------
function init() {

	gPlayer = new Player();
	gLevelManager = new LevelManager();

	img = new Image();
	img.onload = game_start;
	img.src = '1945.png';
}

//------------------------------------------------------------------------------
//  called when sprite texture sheet is finished loading
//------------------------------------------------------------------------------
function game_start() {

	game_loop();
	setInterval(game_loop, 50);

	gLevelManager.startLevel(gLevel1);
}

//------------------------------------------------------------------------------
//  advances the game one frame
//------------------------------------------------------------------------------
function game_loop() {

	var ctx = document.getElementById('canvas').getContext('2d');

	ctx.fillStyle = "rgb(0, 67, 171)";
	ctx.fillRect(0, 0, 640, 480);

	for (var i in gActors) {
		gActors[i].update();
	}
	for (var i in gSprites) {
		gSprites[i].update();
	}
	for (var i in gSprites) {
		gSprites[i].draw(ctx, img);
	}
}

