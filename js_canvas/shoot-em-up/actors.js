//------------------------------------------------------------------------------
//  actors.js - players, enemies, ten-thousand bullets, etc.
//------------------------------------------------------------------------------

"use strict";

// all actors live here
var gActors = [];

var gPlayerShots = [];

//------------------------------------------------------------------------------
//  class Actor
//------------------------------------------------------------------------------
function Actor() { }
Actor.method('update', function() { });

//------------------------------------------------------------------------------
//  class Player - handles player movement, etc.
//------------------------------------------------------------------------------
function Player() {

	gActors.push(this);

	this.sprite = new PlayerSprite();

	gInputHandlers.player = this;

	this.moveSpeed = 10;

	// screen bounds
	this.max_x = 640 - 64;
	this.max_y = 480 - 64;

	// input state vars
	this.moveLeft = false;
	this.moveRight = false;
	this.moveUp = false;
	this.moveDown = false;
	this.isShooting = false;
}
Player.inherits(Actor);

//------------------------------------------------------------------------------
Player.method('update', function() {

	if (this.moveUp) {
		this.sprite.y -= this.moveSpeed;
	}
	if (this.moveDown) {
		this.sprite.y += this.moveSpeed;
	}
	if (this.moveLeft) {
		this.sprite.x -= this.moveSpeed;
	}
	if (this.moveRight) {
		this.sprite.x += this.moveSpeed;
	}

	this.sprite.x = Math.max(this.sprite.x, 0);
	this.sprite.y = Math.max(this.sprite.y, 0);
	this.sprite.x = Math.min(this.sprite.x, this.max_x);
	this.sprite.y = Math.min(this.sprite.y, this.max_y);

	if (this.isShooting) {
		this.spawnBullet();
	}
});

//------------------------------------------------------------------------------
Player.method('handleKeyPress', function(code) {

	//alert('Player.handleKeyPress called ' + code);
});

//------------------------------------------------------------------------------
Player.method('handleKeyDown', function(code) {

	if (code == KEY_DOWN) {
		this.moveDown = true;

	} else if (code == KEY_UP) {
		this.moveUp = true;

	} else if (code == KEY_RIGHT) {
		this.moveRight = true;

	} else if (code == KEY_LEFT) {
		this.moveLeft = true;

	} else if (code == KEY_SPACE) {
		this.isShooting = true;

	} else {
		// WASD support
		var key = String.fromCharCode(code);

		if (key == 'w' || key == 'W') {
			this.moveUp = true;

		} else if (key == 'a' || key == 'A') {
			this.moveLeft = true;

		} else if (key == 's' || key == 'S') {
			this.moveDown = true;

		} else if (key == 'd' || key == 'D') {
			this.moveRight = true;
		}
	}
});

//------------------------------------------------------------------------------
Player.method('handleKeyUp', function(code) {

	if (code == KEY_DOWN) {
		this.moveDown = false;

	} else if (code == KEY_UP) {
		this.moveUp = false;

	} else if (code == KEY_RIGHT) {
		this.moveRight = false;

	} else if (code == KEY_LEFT) {
		this.moveLeft = false;

	} else if (code == KEY_SPACE) {
		this.isShooting = false;

	} else {
		// WASD support
		var key = String.fromCharCode(code);

		if (key == 'w' || key == 'W') {
			this.moveUp = false;

		} else if (key == 'a' || key == 'A') {
			this.moveLeft = false;

		} else if (key == 's' || key == 'S') {
			this.moveDown = false;

		} else if (key == 'd' || key == 'D') {
			this.moveRight = false;
		}
	}
});

//------------------------------------------------------------------------------
Player.method('spawnBullet', function(code) {

	var bullet = new Bullet();
	gPlayerShots.push(bullet);

	// initial position
	bullet.sprite.x = this.sprite.x;// + this.sprite.w / 2;
	bullet.sprite.y = this.sprite.y;// + 2;

	// TODO: can improve bullet speed logic, maybe add player's speed
	bullet.vy = -20;
});

//------------------------------------------------------------------------------
function Bullet() {

	gActors.push(this);

	this.sprite = new BulletSprite();

	// velocity
	this.vx = 0;
	this.vy = 0;
}
Bullet.inherits(Actor);

//------------------------------------------------------------------------------
Bullet.method('update', function() {

	this.sprite.x += this.vx;
	this.sprite.y += this.vy;

	// TODO: bounds checking, delete if off-screen
});

//------------------------------------------------------------------------------
function Enemy1() {

	gActors.push(this);

	this.sprite = new Enemy1Sprite();

	this.explosionSprite = new ExplosionSprite();
	this.explosionSprite.visible = false;

	this.t = 0; // frame counter
}
Enemy1.inherits(Actor);

//------------------------------------------------------------------------------
Enemy1.method('update', function() {

	// logic below is only for alive planes
	if (this.isDead) { return; }

	this.t += 1;

	// let's do some crazy movement
	this.sprite.x = -50 + 2 * this.t + 50 * Math.cos(this.t / 4);
	this.sprite.y = 50 + 50 * Math.sin(this.t / 4);

	// collision detection on player's bullets
	for (var i in gPlayerShots) {
		var shot = gPlayerShots[i];
		if (this.sprite.hitTest(shot.sprite)) {
			//console.log("hit!");
			this.die();
			break;
		}
	}
});

//------------------------------------------------------------------------------
Enemy1.method('die', function() {

	if (this.isDead) { return; }
	this.isDead = true;

	this.sprite.visible = false;
	this.explosionSprite.visible = true;

	this.explosionSprite.x = this.sprite.x;
	this.explosionSprite.y = this.sprite.y;

	// TODO: disappear after the animation is done
});

