
var GoBoard = {};

GoBoard.init = function ()
{
	GoBoard.cellState = new Array();
	GoBoard.groups = new Array();
	GoBoard.isBlackTurn = true;
	GoBoard.gridWidth = 19;
	GoBoard.gridHeight = 19;

	for (var i = 0; i < GoBoard.gridWidth * GoBoard.gridHeight; i++) {
		GoBoard.cellState[i] = 'clear';
	}

	GoBoard.blackPieceImage = new Image();
	GoBoard.blackPieceImage.onload = function() {

		GoBoard.whitePieceImage = new Image();
		GoBoard.whitePieceImage.onload = function() {

			var canvas = document.getElementById('canvas');
			canvas.onclick = GoBoard.handleMouseClick;

			draw_board();
		};
		GoBoard.whitePieceImage.src = 'white_stone.png';
	};
	GoBoard.blackPieceImage.src = 'black_stone.png';
};

GoBoard.getCellState = function (x, y)
{
	return GoBoard.cellState[y * GoBoard.gridWidth + x];
};

GoBoard.setCellState = function (x, y, state)
{
	GoBoard.cellState[y * GoBoard.gridWidth + x] = state;
};

GoBoard.addStone = function (stone)
{
	GoBoard.cellState[stone.y * GoBoard.gridWidth + stone.x] = stone.color;

	GoBoard.updateGroups(stone);

	// TODO: implement ko rule

	// capture before die rule: check neighbouring groups first
	/*
	var neighbouring_groups = find_neighbouring_groups(stone);
	for (var i in neighbouring_groups) {
		var group = neighbouring_groups[i];
		if (GoBoard.belongsToGroup(stone, group)) {
			continue;
		}
		if (has_no_liberties(group)) {
			GoBoard.removeGroup(group);
		}
	}
	*/

	GoBoard.removeSurroundedGroups();
};

GoBoard.removeStone = function (stone)
{
	GoBoard.setCellState(stone.x, stone.y, 'clear');
};

GoBoard.updateGroups = function (stone)
{
	var new_group = create_group();
	new_group.stones.push(stone);

	var groups_to_merge = new Array();
	for (var i in GoBoard.groups) {
		var group = GoBoard.groups[i];
		if (group == new_group) { continue; }
		if (GoBoard.belongsToGroup(stone, group)) {
			// don't modify GoBoard.groups while we're walking it
			groups_to_merge.push(group);
		}
	}
	for (var i in groups_to_merge) {
		var group = groups_to_merge[i];
		new_group = merge_groups(new_group, group);
	}
};

GoBoard.removeSurroundedGroups = function ()
{
	for (var i in GoBoard.groups) {
		var group = GoBoard.groups[i];
		if (has_no_liberties(group)) {
			GoBoard.removeGroup(group);
		}
	}
};

GoBoard.isAdjacent = function (stone1, stone2)
{
	return	(stone1.y == stone2.y &&
			(stone1.x == stone2.x - 1 || stone1.x == stone2.x + 1)
		) ||
			(stone1.x == stone2.x &&
			(stone1.y == stone2.y - 1 || stone1.y == stone2.y + 1)
		);
};

GoBoard.belongsToGroup = function (stone, group)
{
	if (group.stones.length < 1) { return false; }
	if (stone.color !== group.stones[0].color) { return false; }

	for (var i in group.stones) {
		var member = group.stones[i];
		if (member.x == stone.x && member.y == stone.y) {
			return true;
		}
		if (GoBoard.isAdjacent(stone, member)) {
			return true;
		}
	}
	return false;
};

GoBoard.isBorderingEnemyGroup = function (stone, group)
{
	if (group.stones.length < 1) { return false; }
	if (stone.color === group.stones[0].color) { return false; }

	for (var i in group.stones) {
		var member = group.stones[i];
		if (GoBoard.isAdjacent(stone, member)) {
			return true;
		}
	}
	return false;
};

function count_liberties(group)
{
	var retval = 0;

	var found_liberties = new Object();
	function found_liberty(stone) {
		var i = stone.y * GoBoard.gridWidth + stone.x;
		found_liberties[i] = true;
	}

	for (var i in group.stones) {
		var stone = group.stones[i];
		var neighbour;

		if (stone.x > 0) {
			neighbour = GoBoard.getCellState(stone.x - 1, stone.y);
			if (neighbour == 'clear') { found_liberty(neighbour); }
		}
		if (stone.x < GoBoard.gridWidth - 1) {
			neighbour = GoBoard.getCellState(stone.x + 1, stone.y);
			if (neighbour == 'clear') { found_liberty(neighbour); }
		}
		if (stone.y > 0) {
			neighbour = GoBoard.getCellState(stone.x, stone.y - 1);
			if (neighbour == 'clear') { found_liberty(neighbour); }
		}
		if (stone.y < GoBoard.gridHeight - 1) {
			neighbour = GoBoard.getCellState(stone.x, stone.y + 1);
			if (neighbour == 'clear') { found_liberty(neighbour); }
		}
	}

	for (var i in found_liberties) { retval += 1; }
	return retval;
}

function has_no_liberties(group)
{
	for (var i in group.stones) {
		var stone = group.stones[i];
		var neighbour;

		if (stone.x > 0) {
			neighbour = GoBoard.getCellState(stone.x - 1, stone.y);
			if (neighbour == 'clear') { return false; }
		}
		if (stone.x < GoBoard.gridWidth - 1) {
			neighbour = GoBoard.getCellState(stone.x + 1, stone.y);
			if (neighbour == 'clear') { return false; }
		}
		if (stone.y > 0) {
			neighbour = GoBoard.getCellState(stone.x, stone.y - 1);
			if (neighbour == 'clear') { return false; }
		}
		if (stone.y < GoBoard.gridHeight - 1) {
			neighbour = GoBoard.getCellState(stone.x, stone.y + 1);
			if (neighbour == 'clear') { return false; }
		}
	}

	return true;
}

function create_group()
{
	var new_group = new Object();
	new_group.stones = new Array();
	new_group.index = GoBoard.groups.length;
	GoBoard.groups.push(new_group);
	return new_group;
}

GoBoard.deleteGroup = function (group)
{
	GoBoard.groups.splice(group.index, 1);
	for (var i in GoBoard.groups) {
		var group = GoBoard.groups[i];
		group.index = i;
	}
}

GoBoard.removeGroup = function (group)
{
	for (var i in group.stones) {
		var stone = group.stones[i];
		GoBoard.removeStone(stone);
	}
	GoBoard.deleteGroup(group);
}

function merge_groups(group1, group2)
{
	var merged_stones = new Array();

	for (var i in group1.stones) {
		var stone = group1.stones[i];
		merged_stones.push(stone);
	}
	for (var i in group2.stones) {
		var stone = group2.stones[i];
		merged_stones.push(stone);
	}

	GoBoard.deleteGroup(group1);
	GoBoard.deleteGroup(group2);

	var new_group = create_group();
	new_group.stones = merged_stones;
	return new_group;
}

function find_neighbouring_groups(stone)
{
	var retval = new Array();

	for (var i in GoBoard.groups) {
		var group = GoBoard.groups[i];
		if (GoBoard.isBorderingEnemyGroup(group)) {
			// TODO: don't add group more than once
			retval.push(group);
		}
	}
	
	return retval;
}

function draw_board_background(draw_context)
{
	draw_context.fillStyle = "rgb(220, 220, 220)";
	draw_context.fillRect(0, 0, draw_context.canvas.width, draw_context.canvas.height);
}

function draw_grid(draw_context, grid_width, grid_height, cell_width, cell_height)
{
	for (var x = 0; x < grid_width; x++) {
		draw_context.moveTo(x * cell_width + cell_width / 2.0, cell_height / 2.0);
		draw_context.lineTo(x * cell_width + cell_width / 2.0, grid_height * cell_height - cell_height / 2.0);
		draw_context.stroke();
	}
	for (var y = 0; y < grid_height; y++) {
		draw_context.moveTo(cell_width / 2.0, y * cell_height + cell_height / 2.0);
		draw_context.lineTo(grid_width * cell_width - cell_width / 2.0, y * cell_height + cell_height / 2.0);
		draw_context.stroke();
	}
}

function draw_pieces(draw_context)
{
	for (var y = 0; y < GoBoard.gridHeight; y++) {
		for (var x = 0; x < GoBoard.gridWidth; x++) {

			var color = GoBoard.cellState[y * GoBoard.gridWidth + x];
			var img_x = x * GoBoard.blackPieceImage.width;
			var img_y = y * GoBoard.blackPieceImage.height;

			if (color == 'black') {
				draw_context.drawImage(GoBoard.blackPieceImage, img_x, img_y);
			} else if (color == 'white') {
				draw_context.drawImage(GoBoard.whitePieceImage, img_x, img_y);
			}
		}
	}
}

function draw_board()
{
	var draw_context = document.getElementById('canvas').getContext('2d');

	draw_board_background(draw_context);
	draw_grid(draw_context, GoBoard.gridWidth, GoBoard.gridHeight, GoBoard.blackPieceImage.width, GoBoard.blackPieceImage.height);
	draw_pieces(draw_context);
}

function take_move(x, y)
{
	// TODO: need to do some checking to see if the given move is valid
	// eg. can't place stone where it will immediately die unless it
	// captures a group first

	var stone = new Object();
	stone.x = x;
	stone.y = y;

	if (GoBoard.isBlackTurn) {
		stone.color = 'black';
	} else {
		stone.color = 'white';
	}
	GoBoard.isBlackTurn = !GoBoard.isBlackTurn;

	GoBoard.addStone(stone);
}

GoBoard.handleMouseClick = function (e)
{
	var e = window.event || e;

	var board_x = Math.floor(e.clientX / GoBoard.blackPieceImage.width);
	var board_y = Math.floor(e.clientY / GoBoard.blackPieceImage.height);

	var stone = GoBoard.getCellState(board_x, board_y);
	if (stone == 'clear') {
		take_move(board_x, board_y);
		draw_board();
	}
};
