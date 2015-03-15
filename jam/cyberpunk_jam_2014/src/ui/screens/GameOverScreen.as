package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	
	public class GameOverScreen extends Screen
	{
		private var _img :Image;
		
		public function GameOverScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			ScreenDuration = 3.0;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Assets.GameOverScreenTexture);
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
