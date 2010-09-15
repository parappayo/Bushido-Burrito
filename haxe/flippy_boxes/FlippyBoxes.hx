
import flash.events.MouseEvent;
import flash.display.Sprite;

class FlippyBoxes extends Sprite
{
	private var _boxes :Array<FlippyBox>;

	private var _boxSize :UInt;
	private var _boxSpacing :UInt;

	public function new()
	{
		super();

		_boxes = new Array();

		_boxSize = 32;
		_boxSpacing = 8;

		var tempBoxSize = _boxSize + _boxSpacing;
		for (y in 0...12)
		{
			for (x in 0...16)
			{
				var box = spawnBox(x * tempBoxSize, y * tempBoxSize);
				box.flipRotation = 0;
				box.refresh();
			}
		}
	}

	private function spawnBox(x :UInt, y :UInt) :FlippyBox
	{
		var box = new FlippyBox();
		box.size = _boxSize;
		box.x = x;
		box.y = y;

		addChild(box);
		_boxes.push(box);

		return box;
	}

	public function update() :Void
	{
		for (box in _boxes)
		{
			box.update();
		}
	}

	public function handleMouseMove(event :MouseEvent)
	{
		var mouseX = event.stageX;
		var mouseY = event.stageY;

		for (box in _boxes)
		{
			var flipFactor = 1.0;
			var innerRadius = 30;

			var dx = mouseX - (box.x + box.width / 2);
			var dy = mouseY - (box.y + box.height / 2);
			var dist = Math.sqrt( (dx * dx) + (dy * dy) );

			var rot = 180 + innerRadius - dist * flipFactor;
			if (rot < 0) { rot = 0; }
			if (rot > 180) { rot = 180; }

			box.flipRotation = rot;
			box.refresh();
		}
	}
}

