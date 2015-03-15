package ui.screens 
{
	import starling.display.*;
	import starling.text.TextField;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;

	public class LegalScreen extends Screen
	{
		private var _sprite :Sprite;
//		private var _img :Image;
		private var _caption :TextField;

		public function LegalScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			_sprite = new Sprite();
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
				
//				_img = new Image(Assets.LegalScreenTexture);
//				_sprite.addChild(_img);

				_caption = new TextField(Settings.ScreenWidth, Settings.ScreenHeight, "", Settings.DefaultFont, Settings.FontSize);
				_caption.text = Settings.SplashCaption;
				_sprite.addChild(_caption);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
				_sprite.removeChildren();
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_timeElapsedInState > MinScreenDuration &&
				( signal == Signals.ACCEPT_KEYUP ||
					signal == Signals.BACK_KEYUP ||
					signal == Signals.TOUCH_BEGAN) )
			{
				_parent.handleChildDone();
				return true;
			}
			
			return super.handleSignal(signal, sender, args);
		}

	} // class

} // package