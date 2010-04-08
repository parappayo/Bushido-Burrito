
var black_img, white_img;  // graphics

var gBoardState = new Array();
var gBoardWidth = 19;
var gBoardHeight = 19;

var gIsBlackTurn = true;

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

	var i = y * gBoardWidth + x;
	return gBoardState[i];
}

//------------------------------------------------------------------------------
function place_stone(x, y, color) {

	var i = y * gBoardWidth + x;
	gBoardState[i] = color;

	// TODO: check for removals
}

//------------------------------------------------------------------------------
function belongs_to_group(stone, group)
{

}

//------------------------------------------------------------------------------
function draw_board() {

	var ctx = document.getElementById('canvas').getContext('2d');

	ctx.fillStyle = "rgb(220, 220, 220)";
	ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);

	for (var y = 0; y < gBoardHeight; y++) {
		for (var x = 0; x < gBoardWidth; x++) {

			var i = y * gBoardWidth + x;
			var color = gBoardState[i];
			var img_x = x * black_img.width;
			var img_y = y * black_img.height;

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
	if (gIsBlackTurn) {
		place_stone(x, y, 'black');
	} else {
		place_stone(x, y, 'white');
	}
	gIsBlackTurn = !gIsBlackTurn;
}

//------------------------------------------------------------------------------
//  input handling
//------------------------------------------------------------------------------
function handleMouseClick(e) {

	var e = window.event || e;

	var board_x = Math.floor(e.clientX / black_img.width);
	var board_y = Math.floor(e.clientY / black_img.height);

	var color = get_stone(board_x, board_y);
	if (color == 'clear') {
		take_move(board_x, board_y);
	}

	draw_board();
}

