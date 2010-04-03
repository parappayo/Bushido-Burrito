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
}

//------------------------------------------------------------------------------
Sprite.method('init', function() {

	gSprites.push(this);
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
		x > this.x + this.w ||
	  	y > this.y + this.h ||
		typeof(x) === undefined ||
		typeof(y) === undefined ) {

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
		target.x + target.w,
		target.y + target.h );
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

	this.nextFrame();
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
		this.frame = 0;
	}
});

//------------------------------------------------------------------------------
//  Sprite.add_horizontal_frames - populate with a horizontal strip of frames
//------------------------------------------------------------------------------
Sprite.method('add_horizontal_frames', function(
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
	this.add_horizontal_frames(8, 18, 15, 32, 32, 1);
}
Enemy1Sprite.inherits(Sprite);

//------------------------------------------------------------------------------
//  class ExplosionSprite
//------------------------------------------------------------------------------
function ExplosionSprite() {

	this.init();
	this.add_horizontal_frames(7, 18, 312, 65, 65, 1);
}
ExplosionSprite.inherits(Sprite);

