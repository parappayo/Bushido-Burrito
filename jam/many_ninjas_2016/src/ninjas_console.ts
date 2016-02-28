
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
	public options = {};

	print()
	{
		for (var key in this.options) {
			var menuOption :MenuOption = this.options[key];
			console.log(menuOption.caption);
		}
	}

	hasCommand(command :string) :boolean
	{
		return command in this.options;
	}

	handleCommand(command :string)
	{
		this.options[command].handler();
	}
}

function printTickReport(gameSim :sim.Sim)
{
	console.log("total pop: " + gameSim.settlements[0].population.total());
}

function main()
{
	var gameSim :sim.Sim = new sim.Sim();
	var settlement = gameSim.spawnSettlement();

	var menu :Menu = new Menu();
	menu.options = {
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

	rl.setPrompt(">");
	menu.print();
	rl.prompt();

	rl.on("line", line => {
		var command :string = line.trim();
		if (command.length < 1) {
			// do nothing, just re-prompt
		} else if (menu.hasCommand(command)) {
			menu.handleCommand(command);
		} else {
			console.log("unrecognized command: " + command);
		}
		menu.print();
		rl.prompt();
	}).on("close", () => {
		process.exit(0);
	});
}

main();
