package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	import resources.*;
	
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
				_img = new Image(Screens.GameovercreditsTexture);
				_game.UISprite.addChild(_img);
				SoundPlayer.play(Audio.Ghost_Pixels_Theme, Settings.VolumeSfxLoud);
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

		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (_timeElapsedInState > ScreenDuration && signal == Signals.ACCEPT_KEYUP)
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
