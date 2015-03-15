package ui.screens 
{
	import starling.text.TextField;
	import starling.display.Image;
	
	import ui.flows.Flow;
	import ui.flows.FlowStates;

	public class SplashScreen extends Screen
	{
		//private var _img :Image;

		private var _caption :TextField;		
		
		public function SplashScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				//_img = new Image(Assets.LegalScreenTexture);
				//_game.UISprite.addChild(_img);
				
				_caption = new TextField(Settings.ScreenWidth, Settings.ScreenHeight, Settings.SplashCaption, "theme_font", 32, 0x000000);
				//_caption.y = (Settings.ScreenHeight - _caption.height) / 2;
				_game.UISprite.addChild(_caption);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				//_game.UISprite.removeChild(_img, true);
				//_img = null;
				
				_game.UISprite.removeChild(_caption, true);
				_caption = null;
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			if (_timeElapsedInState > ScreenDuration)
			{
				_parent.handleChildDone();
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
