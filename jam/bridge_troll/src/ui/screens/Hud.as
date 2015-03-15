package ui.screens 
{
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	
	public class Hud extends Screen 
	{
		private var _sprite :Sprite;
		private var _textEntry :TextField;

		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var textHeight :Number = 40;
			var textBacking :Quad = new Quad(Settings.ScreenWidth, textHeight, 0x000000);
			textBacking.y = Settings.ScreenHeight - textHeight;
			_sprite.addChild(textBacking);
			
			_textEntry = new TextField(Settings.ScreenWidth, textHeight, "", Settings.DefaultFont, 32, 0xffffff);
			_textEntry.y = Settings.ScreenHeight - textHeight;
			_textEntry.hAlign = "left";
			_sprite.addChild(_textEntry);
			
			_textEntry.text = "> ";
		
			_sprite.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			_sprite.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}
		
		private function handleAddedToStage() :void
		{	
			//_sprite.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_sprite.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleRemovedFromStage() :void
		{
			//_sprite.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_sprite.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
		}
		
		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);
		}
		
		private function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			if (keyEvent.keyCode == 8) // backspace
			{
				if (_textEntry.text.length > 2)
				{
					_textEntry.text = _textEntry.text.substring(0, _textEntry.text.length - 1);
				}
				return;
			}
			
			if (keyEvent.keyCode == 13) // enter
			{
				_game.commandParser.handleInput(_textEntry.text.substring(2));
				
				_textEntry.text = "> ";
				return;
			}
			
			if (_textEntry.text.length >= 36) { return; } // input character limit
			
			var keyChar :String = String.fromCharCode(keyEvent.charCode).toLowerCase();
			if (keyChar == " " || (keyChar >= "a" && keyChar <= "z") )
			{
				_textEntry.text += keyChar.valueOf();
			}
		}
		
	} // class
	
} // package
