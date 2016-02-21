
/// <reference path="../lib/phaser.d.ts" />

class ManyNinjas {

	game :Phaser.Game;
	WIDTH :number = 800;
	HEIGHT :number = 600;

	constructor() {
		this.game = new Phaser.Game(this.WIDTH, this.HEIGHT, Phaser.AUTO, 'game',
		{
			preload: this.preload,
			create: this.create
		});
	}

	preload() {
		// load any sprite assets, etc. here
	}

	create() {
		var style = { font: "32px Arial", fill: "white" };
		this.game.add.text(10, 10, "Testing Text", style);
	}

} // class ManyNinjas

var game = new ManyNinjas();
