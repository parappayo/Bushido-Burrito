/**
 *  FlippyBox class
 *
 *  A small graphical widget that flips between two colors via a rotation
 *  parameter.
 */

import flash.display.Sprite;

class FlippyBox extends Sprite
{
	public var size :Float;       // in pixels
	public var frontColor :UInt; // rgb
	public var backColor :UInt;  // rgb
	public var flipRotation :Float; // in degrees

	private var _child :Sprite;

	public function new()
	{
		super();

		_child = new Sprite();
		addChild(_child);

		// defaults
		flipRotation = 0;
		frontColor = 0xff0000;
		backColor = 0x00ff00;
		size = 64;
	}

	public function refresh() :Void
	{
		// bounds checking
		flipRotation = flipRotation % 360;
		if (flipRotation < 0) { flipRotation += 360; }

		var isBackFacing = flipRotation > 90 && flipRotation < 270;

		var rotRad = (flipRotation % 180) * Math.PI / 180;
		var rotFactor :Float = 1.0 - Math.sin(rotRad);

		var width = size;
		var height = size * rotFactor;

		var x = 0;
		var y = (size - height) / 2;

		var color = frontColor;
		if (isBackFacing)
		{
			color = backColor;
		}

		_child.graphics.clear();
		_child.graphics.beginFill(color);
		_child.graphics.drawRect(x, y, width, height);
		_child.graphics.endFill();
	}
}

