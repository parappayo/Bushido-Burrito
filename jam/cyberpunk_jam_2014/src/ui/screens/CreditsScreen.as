package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	
	public class CreditsScreen extends Screen
	{
		private var _img :Image;
		
		public function CreditsScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			ScreenDuration = 2.0;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Assets.CreditsScreenTexture);
				_game.UISprite.addChild(_img);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_img, true);
				_img = null;
			}
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_timeElapsedInState > ScreenDuration && signal == Signals.ACCEPT_KEYUP)
			{
				_parent.handleChildDone();
				return true;
			}

			return super.handleSignal(signal, sender, args);
		}

	} // class

} // package
