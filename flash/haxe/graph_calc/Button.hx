
import flash.display.Sprite;
import flash.text.TextField;
import flash.events.Event;
import flash.events.MouseEvent;

class Button extends Sprite
{
	public static var CLICK :String = "click";

	private var inner :Sprite;
	private var caption :TextField;

	public function new()
	{
		super();

		inner = new Sprite();
		this.addChild(inner);
		inner.addEventListener(
			MouseEvent.MOUSE_DOWN, handleMouseDown);

		caption = new TextField();
		inner.addChild(caption);
		caption.selectable = false;

		draw();
	}

	public function draw()
	{
		inner.graphics.lineStyle(1, 0x000000);
		inner.graphics.beginFill(0xffffff);
		inner.graphics.drawRect(0, 0, 100, 40);
		inner.graphics.endFill();
	}

	public function setCaption(text :String)
	{
		caption.text = text;
	}

	private function handleMouseDown(e :MouseEvent)
	{
		dispatchEvent(new Event(CLICK));
	}
}

