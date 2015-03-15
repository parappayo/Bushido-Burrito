package
{
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;

	public class Game extends Sprite
	{
		private var _inputHandler :InputHandler;
		
		private var _keycodeTextField :TextField;

		public function Game()
		{
			_keycodeTextField = new TextField(320, 100, "no key", "Verdana", 32, 0xffffff);
			_keycodeTextField.x = 20;
			_keycodeTextField.y = 10;
			_keycodeTextField.hAlign = "left";
			addChild(_keycodeTextField);

			_inputHandler = new InputHandler(this);
			addChild(_inputHandler);
		}

		public function handleKeyUp(keyEvent :KeyboardEvent) :void
		{
			_keycodeTextField.text = "key up: " + keyEvent.keyCode;
		}

		public function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			_keycodeTextField.text = "key down: " + keyEvent.keyCode;
		}
	}

} // package

