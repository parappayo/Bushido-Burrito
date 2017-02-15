
var GoBoard;

function init_game()
{
	GoBoard = create_go_board(19, 19);
}

function create_go_board(width, height)
{
	var board = {

		cellState : new Array(),
		groups : new Array(),
		isBlackTurn : true,
		gridWidth : width,
		gridHeight : height,

		getCellState : function (x, y)
		{
			return this.cellState[y * this.gridWidth + x];
		},

		setCellState : function (x, y, state)
		{
			this.cellState[y * this.gridWidth + x] = state;
		},

		addStone : function (stone)
		{
			this.cellState[stone.y * this.gridWidth + stone.x] = stone.color;

			this.updateGroups(stone);

			// TODO: implement ko rule

			// capture before die rule: check neighbouring groups first
			/*
			var neighbouring_groups = this.findNeighbouringGroups(stone);
			for (var i in neighbouring_groups) {
				var group = neighbouring_groups[i];
				if (this.belongsToGroup(stone, group)) {
					continue;
				}
				if (this.hasNoLiberties(group)) {
					this.removeGroup(group);
				}
			}
			*/

			this.removeSurroundedGroups();
		},

		removeStone : function (stone)
		{
			this.setCellState(stone.x, stone.y, 'clear');
		},

		updateGroups : function (stone)
		{
			var new_group = this.createGroup();
			new_group.stones.push(stone);

			var groups_to_merge = new Array();
			for (var i in this.groups) {
				var group = this.groups[i];
				if (group == new_group) { continue; }
				if (this.belongsToGroup(stone, group)) {
					// don't modify this.groups while we're walking it
					groups_to_merge.push(group);
				}
			}
			for (var i in groups_to_merge) {
				var group = groups_to_merge[i];
				new_group = this.mergeGroup(new_group, group);
			}
		},

		removeSurroundedGroups : function ()
		{
			for (var i in this.groups) {
				var group = this.groups[i];
				if (this.hasNoLiberties(group)) {
					this.removeGroup(group);
				}
			}
		},

		isAdjacent : function (stone1, stone2)
		{
			return	(stone1.y == stone2.y &&
					(stone1.x == stone2.x - 1 || stone1.x == stone2.x + 1)
				) ||
					(stone1.x == stone2.x &&
					(stone1.y == stone2.y - 1 || stone1.y == stone2.y + 1)
				);
		},

		belongsToGroup : function (stone, group)
		{
			if (group.stones.length < 1) { return false; }
			if (stone.color !== group.stones[0].color) { return false; }

			for (var i in group.stones) {
				var member = group.stones[i];
				if (member.x == stone.x && member.y == stone.y) {
					return true;
				}
				if (this.isAdjacent(stone, member)) {
					return true;
				}
			}
			return false;
		},

		isBorderingEnemyGroup : function (stone, group)
		{
			if (group.stones.length < 1) { return false; }
			if (stone.color === group.stones[0].color) { return false; }

			for (var i in group.stones) {
				var member = group.stones[i];
				if (this.isAdjacent(stone, member)) {
					return true;
				}
			}
			return false;
		},

		countLiberties : function (group)
		{
			var retval = 0;

			var found_liberties = new Object();
			function found_liberty(stone) {
				var i = stone.y * this.gridWidth + stone.x;
				found_liberties[i] = true;
			}

			for (var i in group.stones) {
				var stone = group.stones[i];
				var neighbour;

				if (stone.x > 0) {
					neighbour = this.getCellState(stone.x - 1, stone.y);
					if (neighbour == 'clear') { found_liberty(neighbour); }
				}
				if (stone.x < this.gridWidth - 1) {
					neighbour = this.getCellState(stone.x + 1, stone.y);
					if (neighbour == 'clear') { found_liberty(neighbour); }
				}
				if (stone.y > 0) {
					neighbour = this.getCellState(stone.x, stone.y - 1);
					if (neighbour == 'clear') { found_liberty(neighbour); }
				}
				if (stone.y < this.gridHeight - 1) {
					neighbour = this.getCellState(stone.x, stone.y + 1);
					if (neighbour == 'clear') { found_liberty(neighbour); }
				}
			}

			for (var i in found_liberties) { retval += 1; }
			return retval;
		},

		hasNoLiberties : function (group)
		{
			for (var i in group.stones) {
				var stone = group.stones[i];
				var neighbour;

				if (stone.x > 0) {
					neighbour = this.getCellState(stone.x - 1, stone.y);
					if (neighbour == 'clear') { return false; }
				}
				if (stone.x < this.gridWidth - 1) {
					neighbour = this.getCellState(stone.x + 1, stone.y);
					if (neighbour == 'clear') { return false; }
				}
				if (stone.y > 0) {
					neighbour = this.getCellState(stone.x, stone.y - 1);
					if (neighbour == 'clear') { return false; }
				}
				if (stone.y < this.gridHeight - 1) {
					neighbour = this.getCellState(stone.x, stone.y + 1);
					if (neighbour == 'clear') { return false; }
				}
			}

			return true;
		},

		createGroup : function()
		{
			var new_group = new Object();
			new_group.stones = new Array();
			new_group.index = this.groups.length;
			this.groups.push(new_group);
			return new_group;
		},

		deleteGroup : function (group)
		{
			this.groups.splice(group.index, 1);
			for (var i in this.groups) {
				var group = this.groups[i];
				group.index = i;
			}
		},

		removeGroup : function (group)
		{
			for (var i in group.stones) {
				var stone = group.stones[i];
				this.removeStone(stone);
			}
			this.deleteGroup(group);
		},

		mergeGroup : function (group1, group2)
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

			this.deleteGroup(group1);
			this.deleteGroup(group2);

			var new_group = this.createGroup();
			new_group.stones = merged_stones;
			return new_group;
		},

		findNeighbouringGroups : function (stone)
		{
			var retval = new Array();
			for (var i in this.groups) {
				var group = this.groups[i];
				if (this.isBorderingEnemyGroup(group)) {
					// TODO: don't add group more than once
					retval.push(group);
				}
			}
			return retval;
		},

		drawBoardBackground : function (draw_context)
		{
			draw_context.fillStyle = "rgb(220, 220, 220)";
			draw_context.fillRect(0, 0, draw_context.canvas.width, draw_context.canvas.height);
		},

		drawGrid : function (draw_context, grid_width, grid_height, cell_width, cell_height)
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
		},

		drawPieces : function (draw_context)
		{
			for (var y = 0; y < this.gridHeight; y++) {
				for (var x = 0; x < this.gridWidth; x++) {

					var color = this.cellState[y * this.gridWidth + x];
					var img_x = x * this.blackPieceImage.width;
					var img_y = y * this.blackPieceImage.height;

					if (color == 'black') {
						draw_context.drawImage(this.blackPieceImage, img_x, img_y);
					} else if (color == 'white') {
						draw_context.drawImage(this.whitePieceImage, img_x, img_y);
					}
				}
			}
		},

		drawBoard : function ()
		{
			var draw_context = document.getElementById('canvas').getContext('2d');

			this.drawBoardBackground(draw_context);
			this.drawGrid(draw_context, this.gridWidth, this.gridHeight, this.blackPieceImage.width, this.blackPieceImage.height);
			this.drawPieces(draw_context);
		},

		takeMove : function (x, y)
		{
			// TODO: need to do some checking to see if the given move is valid
			// eg. can't place stone where it will immediately die unless it
			// captures a group first

			var stone = new Object();
			stone.x = x;
			stone.y = y;

			if (this.isBlackTurn) {
				stone.color = 'black';
			} else {
				stone.color = 'white';
			}
			this.isBlackTurn = !this.isBlackTurn;

			this.addStone(stone);
		},

		handleMouseClick : function (e)
		{
			var e = window.event || e;

			var board_x = Math.floor(e.clientX / GoBoard.blackPieceImage.width);
			var board_y = Math.floor(e.clientY / GoBoard.blackPieceImage.height);

			var stone = GoBoard.getCellState(board_x, board_y);
			if (stone == 'clear') {
				GoBoard.takeMove(board_x, board_y);
				GoBoard.drawBoard();
			}
		},
	};

	for (var i = 0; i < board.gridWidth * board.gridHeight; i++) {
		board.cellState[i] = 'clear';
	}

	board.blackPieceImage = new Image();
	board.blackPieceImage.onload = function() {

		board.whitePieceImage = new Image();
		board.whitePieceImage.onload = function() {

			var canvas = document.getElementById('canvas');
			canvas.onclick = board.handleMouseClick;

			board.drawBoard();
		};
		board.whitePieceImage.src = 'white_stone.png';
	};
	board.blackPieceImage.src = 'black_stone.png';

	return board;
}
