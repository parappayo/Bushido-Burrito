package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	import resources.Screens;
	
	public class GameOverScreen extends Screen
	{
		private const ScreenDuration :Number = 2.0; // seconds
		private var _img :Image;
		
		public function GameOverScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Screens.GameoverTexture);
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

			if (_timeElapsedInState > ScreenDuration) // advance automatically
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
