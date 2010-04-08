
var black_img, white_img;  // graphics

var gBoardState = new Array();
var gBoardWidth = 19;
var gBoardHeight = 19;

var gIsBlackTurn = true;

var gKnownGroups = new Array();

//------------------------------------------------------------------------------
//  called when HTML document is finished loading
//------------------------------------------------------------------------------
function init() {

	black_img = new Image();
	black_img.onload = function() {

		white_img = new Image();
		white_img.onload = function() {
			main_start();
		};
		white_img.src = 'white_stone.png';
	};
	black_img.src = 'black_stone.png';

}

//------------------------------------------------------------------------------
function main_start() {

	// no need to loop, just start listening for input
	var canvas = document.getElementById('canvas');
	canvas.onclick = handleMouseClick;

	clear_board();
	draw_board();
}

//------------------------------------------------------------------------------
function clear_board() {

	for (var i = 0; i < gBoardWidth * gBoardHeight; i++) {
		gBoardState[i] = 'clear';
	}
}

//------------------------------------------------------------------------------
function get_stone(x, y) {

	var stone = new Object();
	stone.x = x;
	stone.y = y;

	var i = y * gBoardWidth + x;
	stone.color = gBoardState[i];

	return stone;
}

//------------------------------------------------------------------------------
function place_stone(stone) {

	var i = stone.y * gBoardWidth + stone.x;
	gBoardState[i] = stone.color;

	// update groups
	var group;
	var foundGroup = false;
	for (var i in gKnownGroups) {
		group = gKnownGroups[i];
		if (belongs_to_group(stone, group)) {
			group.push(stone);
			foundGroup = true;
			break;
		}
	}
	if (!foundGroup) {
		group = new Array();
		group.push(stone);
		group.index = gKnownGroups.length;
		gKnownGroups.push(group);
	}

	// capture before die rule: check neighbouring groups first
	/*
	var neighbouring_groups = find_neighbouring_groups(stone);
	for (var i in neighbouring_groups) {
		var group = neighbouring_groups[i];
		if (count_liberties(group) == 0) {
			remove_group(group);
		}
	}

	// check for removals
	for (var i in gKnownGroups) {
		var group = gKnownGroups[i];
		if (count_liberties(group) == 0) {
			remove_group(group);
		}
	}
	*/
}

//------------------------------------------------------------------------------
function clear_stone(stone) {

	var i = stone.y * gBoardWidth + stone.x;
	gBoardState[i] = 'clear';
}

//------------------------------------------------------------------------------
function is_adjacent(stone1, stone2) {

	return	(stone1.x == stone2.x - 1 || stone1.x == stone2.x + 1) &&
		(stone1.y == stone2.y - 1 || stone1.y == stone2.y + 1);
}

//------------------------------------------------------------------------------
function belongs_to_group(stone, group) {

	for (var i in group) {
		var member = group[i];
		if (	stone.color === member.color &&
			is_adjacent(stone, member) ) {

			return true;
		}
	}
	return false;
}

//------------------------------------------------------------------------------
function count_liberties(group) {

	var retval = 0;

	for (var i in group) {
		var stone = group[i];
		var neighbour;

		if (stone.x > 0) {
			neighbour = get_stone(stone.x - 1, stone.y);
			if (neighbour.color == 'clear') { retval += 1; }
		}
		if (stone.x < gBoardWidth - 1) {
			neighbour = get_stone(stone.x + 1, stone.y);
			if (neighbour.color == 'clear') { retval += 1; }
		}
		if (stone.y > 0) {
			neighbour = get_stone(stone.x, stone.y - 1);
			if (neighbour.color == 'clear') { retval += 1; }
		}
		if (stone.y < gBoardHeight - 1) {
			neighbour = get_stone(stone.x, stone.y + 1);
			if (neighbour.color == 'clear') { retval += 1; }
		}
	}

	return retval;
}

//------------------------------------------------------------------------------
function remove_group(group) {

	for (var i in group) {
		var stone = group[i];
		clear_stone(stone);
	}

	gKnownGroups.splice(group.index, 1);
}

//------------------------------------------------------------------------------
function find_neighouring_groups(stone) {

	var retval = new Array();

	// TODO: implement me!!
	
	return retval;
}

//------------------------------------------------------------------------------
function draw_board() {

	var ctx = document.getElementById('canvas').getContext('2d');

	ctx.fillStyle = "rgb(220, 220, 220)";
	ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);

	// piece dimensions
	var img_w = black_img.width;
	var img_h = black_img.height;

	// draw play grid
	for (var x = 0; x < gBoardWidth; x++) {
		ctx.moveTo(x * img_w + img_w / 2.0, img_h / 2.0);
		ctx.lineTo(x * img_w + img_w / 2.0, gBoardHeight * img_h - img_h / 2.0);
		ctx.stroke();
	}
	for (var y = 0; y < gBoardHeight; y++) {
		ctx.moveTo(img_w / 2.0, y * img_h + img_h / 2.0);
		ctx.lineTo(gBoardWidth * img_w - img_w / 2.0, y * img_h + img_h / 2.0);
		ctx.stroke();
	}

	// draw the pieces
	for (var y = 0; y < gBoardHeight; y++) {
		for (var x = 0; x < gBoardWidth; x++) {

			var i = y * gBoardWidth + x;
			var color = gBoardState[i];
			var img_x = x * img_w;
			var img_y = y * img_h;

			if (color == 'black') {
				ctx.drawImage(black_img, img_x, img_y);

			} else if (color == 'white') {
				ctx.drawImage(white_img, img_x, img_y);
			}
		}
	}
}

//------------------------------------------------------------------------------
function take_move(x, y)
{
	var stone = new Object();
	stone.x = x;
	stone.y = y;

	if (gIsBlackTurn) {
		stone.color = 'black';
	} else {
		stone.color = 'white';
	}
	gIsBlackTurn = !gIsBlackTurn;

	place_stone(stone);
}

//------------------------------------------------------------------------------
//  input handling
//------------------------------------------------------------------------------
function handleMouseClick(e) {

	var e = window.event || e;

	var board_x = Math.floor(e.clientX / black_img.width);
	var board_y = Math.floor(e.clientY / black_img.height);

	var stone = get_stone(board_x, board_y);
	if (stone.color == 'clear') {
		take_move(board_x, board_y);
	}

	draw_board();
}

