package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class VictoryScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		
		public function VictoryScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var width :Number = Settings.ScreenWidth * 0.75;
			var height :Number = Settings.ScreenHeight * 0.5;

			var box :Image = new Image(Assets.DialogueScreenTexture);
			box.width = width + 8;
			box.height = height + 8;
			box.x = (Settings.ScreenWidth - box.width) * 0.5;
			box.y = (Settings.ScreenHeight - box.height) * 0.5;
			_sprite.addChild(box);
			
			_caption = new TextField(width, height, Settings.VictoryCaption, Settings.DefaultFont, Settings.FontSize, 0x000000);
			_caption.x = (Settings.ScreenWidth - _caption.width) * 0.5;
			_caption.y = (Settings.ScreenHeight - _caption.height) * 0.5;
			_caption.hAlign = HAlign.CENTER;
			_caption.vAlign = VAlign.CENTER;
			_sprite.addChild(_caption);
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
			if (signal == Signals.ACCEPT_KEYDOWN && _timeElapsedInState > 1.0)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return false;
		}

	} // class

} // package
