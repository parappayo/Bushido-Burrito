//------------------------------------------------------------------------------
//  sprites.js - classes, supporting functions, and asset definitions
//------------------------------------------------------------------------------

"use strict";

var gSprites = [];

//------------------------------------------------------------------------------
//  class SpriteFrame - properties for a single frame of a sprite animation
//------------------------------------------------------------------------------
function SpriteFrame() {

	// sprite sheet coords
	this.u = 0;
	this.v = 0;
	this.w = 0;
	this.h = 0;
}

//------------------------------------------------------------------------------
//  class Sprite - a positionable, animated 2d graphics object
//------------------------------------------------------------------------------
function Sprite() {

	this.frames = [];

	this.frame = 0;

	// canvas coords
	this.x = 0;
	this.y = 0;

	this.visible = true;
	this.animationLoops = true;
	this.animationDone = false;
}

//------------------------------------------------------------------------------
Sprite.method('init', function() {

	gSprites.push(this);
	this.index = gSprites.length-1;
});

//------------------------------------------------------------------------------
Sprite.method('kill', function() {

	gSprites.splice(this.index, 1);
	for (var i in gSprites) {
		gSprites[i].index = i;
	}
});

//------------------------------------------------------------------------------
//  Sprite.draw
//
//  ctx - canvas 2d context to draw to
//  bmp - sprite sheet Image object to use
//------------------------------------------------------------------------------
Sprite.method('draw', function(ctx, bmp) {

	if (!this.visible) { return; }

	var f = this.frames[this.frame];
	ctx.drawImage(
		bmp,
		f.u, f.v, f.w, f.h,
		this.x, this.y, f.w, f.h
		);
});

//------------------------------------------------------------------------------
//  Sprite.pointHitTest - collision detection with a given point
//------------------------------------------------------------------------------
Sprite.method('pointHitTest', function(x, y) {

	if (	x < this.x ||
		y < this.y ||
		x > this.x + this.frames[this.frame].w ||
	  	y > this.y + this.frames[this.frame].h ||
		typeof(x) === undefined ||
		typeof(y) === undefined ||
		isNaN(x) || isNaN(y) ) {

		return false;
	}
	return true;
});

//------------------------------------------------------------------------------
//  Sprite.rectHitTest
//------------------------------------------------------------------------------
Sprite.method('rectHitTest', function(x1, y1, x2, y2) {

	return this.pointHitTest(x1, y1) || this.pointHitTest(x2, y2);
});

//------------------------------------------------------------------------------
//  Sprite.hitTest - collision detection with a given sprite
//------------------------------------------------------------------------------
Sprite.method('hitTest', function(target) {

	return this.rectHitTest(
		target.x,
		target.y,
		target.x + target.frames[target.frame].w,
		target.y + target.frames[target.frame].h );
});

//------------------------------------------------------------------------------
//  Sprite.arrHitTest - collision detection with an array of sprites
//------------------------------------------------------------------------------
Sprite.method('arrHitTest', function(targets) {

	for (var i in targets) {
		if (this.hitTest(targets[i])) {
			return true;
		}
	}
	return false;
});

//------------------------------------------------------------------------------
//  Sprite.update
//------------------------------------------------------------------------------
Sprite.method('update', function() {

});

//------------------------------------------------------------------------------
//  Sprite.addFrame
//------------------------------------------------------------------------------
Sprite.method('addFrame', function(u, v, w, h) {

	var f = new SpriteFrame();
	f.u = u;
	f.v = v;
	f.w = w;
	f.h = h;
	this.frames.push(f);
});

//------------------------------------------------------------------------------
//  Sprite.nextFrame
//------------------------------------------------------------------------------
Sprite.method('nextFrame', function() {

	this.frame += 1;
	if (this.frame >= this.frames.length) {
		if (this.animationLoops) {
			this.frame = 0;
		} else {
			this.frame = this.frames.length-1;
		}
		this.animationDone = true;
	}
});

//------------------------------------------------------------------------------
//  Sprite.addHorizontalFrames - populate with a horizontal strip of frames
//------------------------------------------------------------------------------
Sprite.method('addHorizontalFrames', function(
		count,
		start_x, start_y,
		width, height, spacing) {

	for (var i = 0; i < count; i++) {
		var x = start_x + i * (width + spacing);
		var y = start_y;
		this.addFrame(x, y, width, height);
	}
});

//------------------------------------------------------------------------------
Sprite.method('resetAnimation', function() {

	this.animationDone = false;
	this.frame = 0;
});

//------------------------------------------------------------------------------
//  class PlayerSprite
//------------------------------------------------------------------------------
function PlayerSprite() {

	this.init();
	this.addFrame(18, 412, 64, 64);
}
PlayerSprite.inherits(Sprite);

//------------------------------------------------------------------------------
//  class BulletSprite
//------------------------------------------------------------------------------
function BulletSprite() {

	this.init();
	this.addFrame(22, 186, 20, 20);
}
BulletSprite.inherits(Sprite);

//------------------------------------------------------------------------------
//  class Enemy1Sprite
//------------------------------------------------------------------------------
function Enemy1Sprite() {

	this.init();
	this.addHorizontalFrames(8, 19, 16, 30, 30, 3);

	// position last frame
	this.last_x = 0;
	this.last_y = 0;
}
Enemy1Sprite.inherits(Sprite);

//------------------------------------------------------------------------------
//  Enemy1Sprite.update
//------------------------------------------------------------------------------
Enemy1Sprite.method('update', function() {

	const pi8 = Math.PI / 8;

	var dx = this.x - this.last_x;
	var dy = this.y - this.last_y;
	var angle = Math.atan2(dx, dy);

	// sprite's frame depends on it's heading
	if (angle >= 0 && angle < pi8) {
		this.frame = 0;
	} else if (angle >= pi8 && angle < 3*pi8) {
		this.frame = 1;
	} else if (angle >= 3*pi8 && angle < 5*pi8) {
		this.frame = 2;
	} else if (angle >= 5*pi8 && angle < 7*pi8) {
		this.frame = 3;
	} else if (angle >= 7*pi8 && angle < Math.PI) {
		this.frame = 4;
	} else if (angle >= -pi8 && angle < 0) {
		this.frame = 0;
	} else if (angle >= -3*pi8 && angle < -pi8) {
		this.frame = 7;
	} else if (angle >= -5*pi8 && angle < -3*pi8) {
		this.frame = 6;
	} else if (angle >= -7*pi8 && angle < -5*pi8) {
		this.frame = 5;
      	} else {
		this.frame = 4;
	}

	this.last_x = this.x;
	this.last_y = this.y;
});

//------------------------------------------------------------------------------
//  class ExplosionSprite
//------------------------------------------------------------------------------
function ExplosionSprite() {

	this.init();
	this.addHorizontalFrames(7, 19, 313, 62, 62, 4);
	this.animationLoops = false;
}
ExplosionSprite.inherits(Sprite);

//------------------------------------------------------------------------------
//  ExplosionSprite.update
//------------------------------------------------------------------------------
ExplosionSprite.method('update', function() {

	this.nextFrame();
});

