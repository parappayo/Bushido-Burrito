
var GoBoard;

function initGame()
{
	GoBoard = createGoBoard(19, 19);
}

function areStonesAdjacent(stone1, stone2)
{
	return	(stone1.y == stone2.y &&
			(stone1.x == stone2.x - 1 || stone1.x == stone2.x + 1)
		) ||
			(stone1.x == stone2.x &&
			(stone1.y == stone2.y - 1 || stone1.y == stone2.y + 1)
		);
}

function createGoStoneGroup()
{
	var group = {

		stones : new Array(),

		getColor : function ()
		{
			if (group.stones.length < 1) { return false; }
			return group.stones[0].color;
		},

		containsStone : function (stone)
		{
			if (this.stones.length < 1) { return false; }
			if (stone.color !== this.stones[0].color) { return false; }

			for (var i in this.stones) {
				var member = this.stones[i];
				if (member.x == stone.x && member.y == stone.y) {
					return true;
				}
				if (areStonesAdjacent(stone, member)) {
					return true;
				}
			}
			return false;
		},

		bordersOnStone : function (stone)
		{
			for (var i in this.stones) {
				var member = this.stones[i];
				if (areStonesAdjacent(stone, member)) {
					return true;
				}
			}
			return false;
		},

		hasNoLiberties : function (board)
		{
			for (var i in this.stones) {
				var stone = this.stones[i];
				if (board.getCellState(stone.x - 1, stone.y) == 'clear') { return false; }
				if (board.getCellState(stone.x + 1, stone.y) == 'clear') { return false; }
				if (board.getCellState(stone.x, stone.y - 1) == 'clear') { return false; }
				if (board.getCellState(stone.x, stone.y + 1) == 'clear') { return false; }
			}
			return true;
		},
	};

	return group;
}

function createGoBoard(width, height)
{
	var board = {

		cellState : null,
		groups : null,
		moveHistory : null,
		isBlackTurn : true,
		gridWidth : width,
		gridHeight : height,

		startNewGame : function ()
		{
			this.cellState = new Array();
			this.groups = new Array();
			this.moveHistory = new Array();
			this.isBlackTurn = true;

			for (var i = 0; i < this.gridWidth * this.gridHeight; i++) {
				this.cellState[i] = 'clear';
			}
		},

		getCellState : function (x, y)
		{
			if (x < 0 || x >= this.gridWidth ||
				y < 0 || y >= this.gridHeight) {
				return false;
			}

			return this.cellState[y * this.gridWidth + x];
		},

		setCellState : function (x, y, state)
		{
			this.cellState[y * this.gridWidth + x] = state;
		},

		addStone : function (stone)
		{
			this.setCellState(stone.x, stone.y, stone.color);
		},

		removeStone : function (stone)
		{
			this.setCellState(stone.x, stone.y, 'clear');
		},

		createStone : function (x, y)
		{
			var stone = new Object();
			stone.x = x;
			stone.y = y;

			if (this.isBlackTurn) {
				stone.color = 'black';
			} else {
				stone.color = 'white';
			}

			return stone;
		},

		updateGroups : function (stone)
		{
			var new_group = this.createGroup();
			new_group.stones.push(stone);

			var groups_to_merge = new Array();
			for (var i in this.groups) {
				var group = this.groups[i];
				if (group == new_group) { continue; }
				if (group.containsStone(stone)) {
					// don't modify this.groups while we're walking it
					groups_to_merge.push(group);
				}
			}
			for (var i in groups_to_merge) {
				var group = groups_to_merge[i];
				new_group = this.mergeGroup(new_group, group);
			}

			return new_group;
		},

		removeSurroundedGroups : function ()
		{
			for (var i in this.groups) {
				var group = this.groups[i];
				if (group.hasNoLiberties(this)) {
					this.removeGroup(group);
				}
			}
		},

		isBorderingEnemyGroup : function (stone, group)
		{
			if (stone.color === group.getColor()) { return false; }
			return group.bordersOnStone(stone);
		},

		createGroup : function()
		{
			var new_group = createGoStoneGroup();
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

		findGroup : function (stone)
		{
			for (var i in this.groups) {
				var group = this.groups[i];

				if (group.containsStone(stone)) {
					return group;
				}
			}

			return null;
		},

		findNeighbouringGroups : function (stone)
		{
			var retval = new Array();
			for (var i in this.groups) {
				var group = this.groups[i];
				if (this.isBorderingEnemyGroup(stone, group)) {
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

		drawStones : function (draw_context)
		{
			for (var y = 0; y < this.gridHeight; y++) {
				for (var x = 0; x < this.gridWidth; x++) {

					var color = this.cellState[y * this.gridWidth + x];
					var img_x = x * this.blackStoneImage.width;
					var img_y = y * this.blackStoneImage.height;

					if (color == 'black') {
						draw_context.drawImage(this.blackStoneImage, img_x, img_y);
					} else if (color == 'white') {
						draw_context.drawImage(this.whiteStoneImage, img_x, img_y);
					}
				}
			}
		},

		drawBoard : function ()
		{
			var draw_context = document.getElementById('canvas').getContext('2d');

			this.drawBoardBackground(draw_context);
			this.drawGrid(draw_context, this.gridWidth, this.gridHeight, this.blackStoneImage.width, this.blackStoneImage.height);
			this.drawStones(draw_context);
		},

		canTakeMove : function (x, y)
		{
			// TODO: implement ko rule

			return true;
		},

		takeMove : function (x, y)
		{
			if (!this.canTakeMove(x, y)) { return; }

			var stone = this.createStone(x, y);
			this.addStone(stone);
			var newGroup = this.updateGroups(stone);

			if (newGroup.hasNoLiberties(this)) {
				this.revertMoveInProgress();
				return;
			}

			this.removeSurroundedGroups();
			this.moveHistory.push(stone);
			this.isBlackTurn = !this.isBlackTurn;
		},

		takeMoves : function (moves)
		{
			for (var i in moves) {
				var move = moves[i];
				this.takeMove(move.x, move.y);
			}
		},

		setupBoard : function (moves)
		{
			this.startNewGame();
			this.takeMoves(moves);
		},

		revertMoveInProgress : function ()
		{
			this.setupBoard(this.moveHistory);
		},
	};

	board.blackStoneImage = new Image();
	board.blackStoneImage.onload = function() {

		board.whiteStoneImage = new Image();
		board.whiteStoneImage.onload = function() {

			board.startNewGame();
			board.drawBoard();

			var canvas = document.getElementById('canvas');
			canvas.onclick = function (e)
			{
				var e = window.event || e;

				var board_x = Math.floor(e.clientX / board.blackStoneImage.width);
				var board_y = Math.floor(e.clientY / board.blackStoneImage.height);

				var stone = board.getCellState(board_x, board_y);
				if (stone == 'clear') {
					board.takeMove(board_x, board_y);
					board.drawBoard();
				}
			};
		};
		board.whiteStoneImage.src = 'white_stone.png';
	};
	board.blackStoneImage.src = 'black_stone.png';

	return board;
}
