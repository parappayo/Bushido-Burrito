
/// <reference path="../lib/node.d.ts" />
/// <reference path="sim.ts" />

import readline = require("readline");
import sim = require("./sim");

interface MenuCommandHandler
{
	() :void;
}

interface MenuOption
{
	caption :string,
	handler :MenuCommandHandler
}

class Menu
{
	private _prompt :string = ">";
	public options = {};

	private parent :Menu;
	private activeSubMenu :Menu;

	constructor(prompt? :string)
	{
		if (prompt) {
			this._prompt = prompt;
		}
	}

	prompt() :string
	{
		if (this.activeSubMenu != null) {
			return this.activeSubMenu.prompt();
		}
		return this._prompt;
	}

	print()
	{
		if (this.activeSubMenu != null) {
			this.activeSubMenu.print();
			return;
		}

		for (var key in this.options) {
			var menuOption :MenuOption = this.options[key];
			console.log(menuOption.caption);
		}
	}

	hasCommand(command :string) :boolean
	{
		if (this.activeSubMenu != null) {
			return this.activeSubMenu.hasCommand(command);
		}

		return command in this.options;
	}

	handleCommand(command :string)
	{
		if (this.activeSubMenu != null) {
			return this.activeSubMenu.handleCommand(command);
		}

		this.options[command].handler();
	}

	enterSubMenu(subMenu :Menu)
	{
		subMenu.parent = this;
		this.activeSubMenu = subMenu;
	}

	exit()
	{
		if (this.parent != null &&
			this.parent.activeSubMenu == this) {
			this.parent.activeSubMenu = null;
		}
	}
}

function printTickReport(gameSim :sim.Sim)
{
	var settlement = gameSim.settlements[0];

	console.log("");
	console.log("ticked sim");
	console.log("barracks is " + (settlement.barracks.isIdle() ? "idle" : "busy"));
	console.log("farm is " + (settlement.farm.isIdle() ? "idle" : "busy"));
	console.log("total pop: " + settlement.population.total());
}

function main()
{
	var gameSim :sim.Sim = new sim.Sim();
	var settlement = gameSim.spawnSettlement();

	var barracksMenu :Menu = new Menu("barracks>");
	barracksMenu.options = {
		"c" : {
			caption: "(c)ook",
			handler: () => {
				var barracks = gameSim.settlements[0].barracks;
				if (barracks.isIdle()) {
					barracks.cook();
					console.log("started cooking");
				} else {
					console.log("barracks is busy");
				}
			}
		},
		"x" : {
			caption: "e(x)it",
			handler: () => { barracksMenu.exit(); }
		}
	};

	var farmMenu :Menu = new Menu("farm>");
	farmMenu.options = {
		"h" : {
			caption: "(h)arvest",
			handler: () => {
				var farm = gameSim.settlements[0].farm;
				if (farm.isIdle()) {
					farm.harvest();
					console.log("started harvest");
				} else {
					console.log("farm is busy");
				}
			}
		},
		"x" : {
			caption: "e(x)it",
			handler: () => { farmMenu.exit(); }
		}
	};

	var mainMenu :Menu = new Menu("main>");
	mainMenu.options = {
		"b" : {
			caption: "(b)arracks",
			handler: () => { mainMenu.enterSubMenu(barracksMenu); }
		},
		"f" : {
			caption: "(f)arm",
			handler: () => { mainMenu.enterSubMenu(farmMenu); }
		},
		"t" : {
			caption: "(t)ick sim",
			handler: () => { gameSim.tick(); printTickReport(gameSim); }
		},
		"q" : {
			caption: "(q)uit",
			handler: () => { process.exit(0); }
		}
	};

	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout
	});

	rl.setPrompt(mainMenu.prompt());
	mainMenu.print();
	rl.prompt();

	rl.on("line", line => {
		var command :string = line.trim();
		if (command.length < 1) {
			// do nothing, just re-prompt
		} else if (mainMenu.hasCommand(command)) {
			mainMenu.handleCommand(command);
		} else {
			console.log("unrecognized command: " + command);
		}
		console.log("");
		mainMenu.print();
		rl.setPrompt(mainMenu.prompt());
		rl.prompt();
	}).on("close", () => {
		process.exit(0);
	});
}

main();
