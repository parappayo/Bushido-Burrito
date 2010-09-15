
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Sprite;

class Main
{
	static var boxes :FlippyBoxes;

	static function main()
	{
		boxes = new FlippyBoxes();
		flash.Lib.current.addChild(boxes);

		var stage = flash.Lib.current.parent;
		stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
	}

	private static function handleEnterFrame(event :Event) :Void
	{
		boxes.update();
	}

	private static function handleMouseMove(event :MouseEvent) :Void
	{
		boxes.handleMouseMove(event);
	}
}

