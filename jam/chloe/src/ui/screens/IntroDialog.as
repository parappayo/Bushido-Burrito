package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class IntroDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _caption :TextField;
		
		private const MinScreenDuration :Number = 1.0; // seconds
		
		public function IntroDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			var width :Number = 640;
			var height :Number = 500;
			
			_sprite = new Sprite();
			
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);
			
			_caption = new TextField(width, height, "", "default", 18, 0xffffff);
			_sprite.addChild(_caption);

			_sprite.x = (Settings.ScreenWidth - width) / 2;
			_sprite.y = (Settings.ScreenHeight - height) / 2;
			
			_caption.text = Settings.IntroCaption;
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
				signal == Signals.ACCEPT_KEYUP)
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
