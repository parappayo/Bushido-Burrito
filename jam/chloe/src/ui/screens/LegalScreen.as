package ui.screens 
{
	import starling.display.Image;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import resources.Screens;

	public class LegalScreen extends Screen
	{
		private const ScreenDuration :Number = 3.0; // seconds
		private var _img :Image;

		public function LegalScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Screens.LegalTexture);
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
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			if (_timeElapsedInState > ScreenDuration)
			{
				_parent.handleChildDone();
			}
		}
		
	} // class

} // package