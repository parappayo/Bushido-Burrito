package ui.screens 
{
	import starling.display.Image;
	import starling.textures.Texture;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import resources.*;

	public class MissionSelectScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _missionCaptions :Array;
		private var _cursor :Image;
		
		public var _selectedIndex :int;
		public function getSelectedIndex() :int { return _selectedIndex; }
		
		public function MissionSelectScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			_sprite = new Sprite();

			_selectedIndex = 0;
			
			var numMissions :int = 1; // Settings.StartingLevels.length;
			var width :Number = Settings.ScreenWidth;
			var height :Number = 452;
			
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);
			
			var caption :TextField = new TextField(160, 30, "", "fortress", 18, 0xffffff);
			var startingY :Number = (Settings.ScreenHeight / 3) - (numMissions * caption.height + 20) / 2;
			
			_missionCaptions = new Array();
			for (var i :int = 0; i < numMissions; i++)
			{
				caption = new TextField(160, 30, "", "fortress", 18, 0xffffff);
				caption.text = "Mission " + (i + 1);
				_missionCaptions.push(caption);
				_sprite.addChild(caption);
				
				caption.x = (Settings.ScreenWidth - caption.width) / 2;
				caption.y = startingY + i * (caption.height + 20);
			}

			_cursor = new Image(Atlases.ElementsTextures.getTexture("kid_idle_right1"));
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
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			switch (signal)
			{
				case Signals.MOVE_DOWN_KEYUP:
					{
						_selectedIndex += 1;
						if (_selectedIndex >= _missionCaptions.length)
						{
							_selectedIndex = 0;
						}
						refreshCursorPosition();
					}
					break;
					
				case Signals.MOVE_UP_KEYUP:
					{
						_selectedIndex -= 1;
						if (_selectedIndex < 0)
						{
							_selectedIndex = _missionCaptions.length - 1;
						}
						refreshCursorPosition();
					}
					break;
					
				case Signals.ACCEPT_KEYUP:
					{
						_parent.handleChildDone();
					}
					break;
			}
		}
		
		private function refreshCursorPosition() :void
		{
			_cursor.x = _missionCaptions[_selectedIndex].x - _cursor.width;
			_cursor.y = _missionCaptions[_selectedIndex].y - (_cursor.height / 4);			
		}
		
	} // class

} // package
