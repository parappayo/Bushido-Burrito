/*
 *  GridFontGlyph.as
 *
 *  ActionScript 3.0 class to graphically represent a single character of grid font text.
 */

package {

import flash.display.Sprite;
import flash.geom.Point;

public class GridFontGlyph extends Sprite
{
	private var _width :Number;
	private var _height :Number;

	private var _gridWidth :Number;
	private var _gridHeight :Number;
	private var _cellSize :Number;

	// arrays of Boolean data represent strokes
	private var _horizontalLines :Array;
	private var _verticalLines :Array;
	private var _forwardLines :Array; // forward-slash diagonals
	private var _backLines :Array; // backslash diagonals

	public function GridFontGlyph()
	{
		_gridWidth = 3;
		_gridHeight = 9;
		_cellSize = 20;  // TODO: should be based on Sprite dims

		Init();
	}

	private function Init() :void
	{
		_width = _gridWidth * _cellSize;
		_height = _gridHeight * _cellSize;

		_horizontalLines = new Array();
		_verticalLines = new Array();
		_forwardLines = new Array();
		_backLines = new Array();

		var i :Number;

		for (i = 0; i < _gridWidth * (_gridHeight + 1); i++) {
			_horizontalLines[i] = false;
		}
		for (i = 0; i < _gridHeight * (_gridWidth + 1); i++) {
			_verticalLines[i] = false;
		}
		for (i = 0; i < _gridWidth * _gridHeight; i++) {
			_forwardLines[i] = false;
			_backLines[i] = false;
		}

		Draw();
	}

	private function Draw() :void
	{
		graphics.lineStyle(0, 0x000000, 0); // hide
		//graphics.beginFill(0xffffffff);
		graphics.beginFill(0xa0a0ff);  // debug: let's make the position of the glyph obvious for now
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();

		// TODO: line style must be configurable
		graphics.lineStyle(2, 0x000000);

		var i :Number, x :Number, y :Number, px :Number, py :Number;

		for (x = 0; x < _gridWidth; x++) {
			for (y = 0; y < _gridHeight; y++) {

				i = y * _gridWidth + x;

				// pixel coordinates
				px = x * _cellSize;
				py = y * _cellSize;

				if (_horizontalLines[i]) {
					graphics.moveTo(px, py);
					graphics.lineTo(px + _cellSize, py);
				}

				if (_verticalLines[i]) {
					graphics.moveTo(px, py);
					graphics.lineTo(px, py + _cellSize);
				}

				if (_forwardLines[i]) {
					graphics.moveTo(px, py);
					graphics.lineTo(px + _cellSize, py + _cellSize);
				}
				if (_backLines[i]) {
					graphics.moveTo(px + _cellSize, py);
					graphics.lineTo(px, py + _cellSize);
				}
			}
		}

		// last row of horizontal strokes
		y = _gridHeight;
		for (x = 0; x < _gridWidth; x++) {

			i = y * _gridWidth + x;
			px = x * _cellSize;
			py = y * _cellSize;

			if (_horizontalLines[i]) {
				graphics.moveTo(px, py);
				graphics.lineTo(px + _cellSize, py);
			}
		}

		// last column of vertical strokes
		x = _gridWidth;
		for (y = 0; y < _gridHeight; y++) {

			i = y * _gridWidth + x;
			px = x * _cellSize;
			py = y * _cellSize;

			if (_verticalLines[i]) {
				graphics.moveTo(px, py);
				graphics.lineTo(px, py + _cellSize);
			}
		}
	}
	
	public function ToggleLineFromPos(pos_x :Number, pos_y :Number) :void
	{
		var cell_x :int = Math.round(pos_x / _cellSize);
		var cell_y :int = Math.round(pos_y / _cellSize);
		var cell_i :int = cell_y * _gridWidth + cell_x;

		// for now, let's just use the closest(?) vertical line
		_verticalLines[cell_i] = !_verticalLines[cell_i];

		Draw();
	}
	
	public function set gridWidth(value :Number) :void
	{
		_gridWidth = value;
		Init(); // clobbers any existing data
	}

	public function get gridWidth() :Number { return _gridWidth; }

	public function set gridHeight(value :Number) :void
	{
		_gridHeight = value;
		Init(); // clobbers any existing data
	}

	public function get gridHeight() :Number { return _gridHeight; }
}

} // package

