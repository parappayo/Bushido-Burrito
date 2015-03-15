package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.Image;
	import resources.Screens;
	
	public class VictoryScreen extends Screen
	{
		private var _img :Image;
		
		private const MinScreenDuration :Number = 1.0; // seconds
		
		public function VictoryScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}

		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Screens.VictoryTexture);
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

		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (_timeElapsedInState > MinScreenDuration &&
				signal == Signals.ACCEPT_KEYUP)
			{
				// TODO: fix me!
				//_parent.handleChildDone();
			}
		}

	} // class

} // package
