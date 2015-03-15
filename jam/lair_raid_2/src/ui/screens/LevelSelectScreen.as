package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;

	import starling.display.*;
	import starling.textures.Texture;
	import starling.text.TextField;

	public class LevelSelectScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _captions :Array;
		private var _cursor :DisplayObject;
		
		public var _selectedIndex :int;
		public function getSelectedIndex() :int { return _selectedIndex; }
		
		public function LevelSelectScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			_sprite = new Sprite();

			_selectedIndex = 0;
			
			var numLevels :int = 1; // Settings.StartingLevels.length;
			var width :Number = Settings.ScreenWidth;
			var height :Number = 452;
			
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);
			
			var caption :TextField = new TextField(160, 30, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			var startingY :Number = (Settings.ScreenHeight / 3) - (numLevels * caption.height + 20) / 2;
			
			_captions = new Array();
			for (var i :int = 0; i < numLevels; i++)
			{
				caption = new TextField(160, 30, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
				caption.text = "Mission " + (i + 1);
				_captions.push(caption);
				_sprite.addChild(caption);
				
				caption.x = (Settings.ScreenWidth - caption.width) / 2;
				caption.y = startingY + i * (caption.height + 20);
			}

			_cursor = new Quad(32, 32); // TODO: put a cursor texture here
			_sprite.addChild(_cursor);
			refreshCursorPosition();
			
			_sprite.x = 0;
			_sprite.y = 134;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.MOVE_DOWN_KEYUP:
					{
						_selectedIndex += 1;
						if (_selectedIndex >= _captions.length)
						{
							_selectedIndex = 0;
						}
						refreshCursorPosition();
						return true;
					}
					break;
					
				case Signals.MOVE_UP_KEYUP:
					{
						_selectedIndex -= 1;
						if (_selectedIndex < 0)
						{
							_selectedIndex = _captions.length - 1;
						}
						refreshCursorPosition();
						return true;
					}
					break;
					
				case Signals.ACCEPT_KEYUP:
					{
						_parent.handleChildDone();
						return true;
					}
					break;
			}
			
			return super.handleSignal(signal, sender, args);
		}
		
		private function refreshCursorPosition() :void
		{
			_cursor.x = _captions[_selectedIndex].x - _cursor.width;
			_cursor.y = _captions[_selectedIndex].y - (_cursor.height / 4);			
		}
		
	} // class

} // package
