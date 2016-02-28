
/// <reference path="../lib/node.d.ts" />

import readline = require("readline");

var menuOptions = {
	"t" : {
		caption: "(t)ick sim",
		handler: tickSim 
	}
};

function tickSim()
{
	console.log("should tick sim here");
}

function printMenu(menuOptions)
{
	for (var key in menuOptions) {
		var option = menuOptions[key];
		console.log(option.caption);
	}
}

function main()
{
	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout
	});

	rl.setPrompt(">");
	printMenu(menuOptions);
	rl.prompt();

	rl.on("line", line => {
		var command : string = line.trim();
		if (command in menuOptions)
		{
			menuOptions[command].handler();
		}
		else
		{
			console.log("unrecognized command: " + command);
		}
		printMenu(menuOptions);
		rl.prompt();
	}).on("close", () => {
		process.exit(0);
	});
}

main();
