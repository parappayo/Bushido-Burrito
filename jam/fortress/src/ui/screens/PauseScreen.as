package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import resources.*;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class PauseScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		
		public function PauseScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var box :Image = new Image(Screens.dialogue_popupTexture);
			_sprite.addChild(box);
			
			var width :Number = 500;
			var height :Number = 300;
			_caption = new TextField(width - 100, height, "", "fortress", 18, 0xffffff);
			_caption.x += 50;
			_caption.text = "Paused";
			_sprite.addChild(_caption);

			_sprite.x = (Settings.ScreenWidth - width) / 2;
			_sprite.y = (Settings.ScreenHeight - height) / 2;
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
			
			if (_timeElapsedInState > MinScreenDuration &&
				(signal == Signals.BACK_KEYUP) || (signal == Signals.ACCEPT_KEYUP) )
			{
				_parent.handleChildDone();
			}
		}
		
	} // class

} // package
