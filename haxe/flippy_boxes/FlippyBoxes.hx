
import flash.display.Sprite;

class FlippyBoxes extends Sprite
{
	private var _boxes :Array<FlippyBox>;

	public function new()
	{
		super();

		_boxes = new Array();

		for (y in 0...16)
		{
			for (x in 0...16)
			{
				var box = new FlippyBox();
				box.size = 20;
				box.x = x * 20;
				box.y = y * 20;
				box.flipRotation = 10 * (x + y);

				addChild(box);
				_boxes.push(box);
			}
		}
	}

	public function update() :Void
	{
		for (box in _boxes)
		{
			box.flipRotation += 2;
			box.refresh();
		}
	}
}

