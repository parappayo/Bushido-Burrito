/**
 *  GraphCalc class
 *
 *  A simple graphing calculator canvas.  Provides options for plotting a
 *  function of one variable.
 */

import flash.display.Sprite;

class GraphCalc extends Sprite
{
	// the dimensions in which to draw stuff
	public var canvasWidth :UInt;
	public var canvasHeight :UInt;

	public var frontColor :UInt; // rgb
	public var backColor :UInt;  // rgb

	public var lineThickness :Float;
	public var stepSize :Float; // in pixels

	public function new()
	{
		super();

		// defaults
		canvasWidth = 100;
		canvasHeight = 100;
		frontColor = 0x000000;
		backColor = 0xffffff;
		lineThickness = 3;
		stepSize = 10;
	}

	public function plot( plotFunc : Float -> Float -> Float, 
		minX :Float, maxX :Float, t :Float )
	{
		graphics.clear();
		graphics.beginFill(backColor);
		graphics.drawRect(x, y, x + canvasWidth, y + canvasHeight);
		graphics.endFill();

		var domainStep = stepSize * (maxX - minX) / canvasWidth;
		var numSteps :UInt = Std.int(canvasWidth / stepSize);

		var minY :Float = 0;
		var maxY :Float = 0;

		var results :Array<Float> = new Array();

		var i :UInt;
		for( i in 0...numSteps ) {

			var x = i * domainStep;
			var y = plotFunc(x, t);

			if (y > maxY) { maxY = y; }
			if (y < minY) { minY = y; }

			results.push(y);
		}

		var rangeScale :Float = canvasHeight / (maxY - minY);
		var yOffset :Float = canvasHeight / 2;

		graphics.lineStyle(lineThickness, frontColor);
		graphics.moveTo(x, results[0] * rangeScale + yOffset);
		for( i in 1...numSteps ) {

			graphics.lineTo(
				x + i * stepSize,
				y + results[i] * rangeScale + yOffset);
		}
	}

}

