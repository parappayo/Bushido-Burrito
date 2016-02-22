
/// <reference path="../lib/phaser.d.ts" />

class ManyNinjas {

	game :Phaser.Game;
	WIDTH :number = 800;
	HEIGHT :number = 600;

	constructor() {
		this.game = new Phaser.Game(this.WIDTH, this.HEIGHT, Phaser.AUTO, "game",
		{
			preload: this.preload,
			create: this.create
		});
	}

	preload() {
		this.game.load.atlasJSONHash("sprites", "atlases/sprites.png", "atlases/sprites.json");
	}

	create() {
		var style = { font: "32px Arial", fill: "white" };
		this.game.add.text(10, 10, "Testing Text", style);

		var ninja = this.game.add.sprite(50, 50, "sprites");
		ninja.animations.add("walk", Phaser.Animation.generateFrameNames("ninja", 1, 2, ".png"));

		ninja.texture.baseTexture.scaleMode = PIXI.scaleModes.NEAREST;
		ninja.scale.setTo(3, 3);

		var fps = 6;
		var loop = true;
		ninja.animations.play("walk", fps, loop);
	}

} // class ManyNinjas

var game = new ManyNinjas();
