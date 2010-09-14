
import flash.events.Event;
import flash.display.Sprite;

class Main
{
	static var boxes :FlippyBoxes;

	static function main()
	{
		boxes = new FlippyBoxes();
		flash.Lib.current.addChild(boxes);

		var eventSprite = new Sprite();
		flash.Lib.current.addChild(eventSprite);
		eventSprite.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
	}

	private static function handleEnterFrame(_) :Void
	{
		boxes.update();
	}
}

