package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	import resources.*;
	
	public class GameOverScreen extends Screen
	{
		private var _img :Image;
		private var _img2 :Image;
		private var _animationTimer :Number;

		public static var AnimationFrequency :Number = 0.2;
		
		public function GameOverScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			ScreenDuration = 3.0;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Screens.Gameover1Texture);
				_img2 = new Image(Screens.Gameover2Texture);
				_img2.visible = false;
				_game.UISprite.addChild(_img);
				_game.UISprite.addChild(_img2);

				_animationTimer = AnimationFrequency;
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
			
			_animationTimer -= elapsed;
			if (_animationTimer <= 0)
			{
				_animationTimer = AnimationFrequency;
				if (_img.visible)
				{
					_img.visible = false;
					_img2.visible = true;
				}
				else
				{
					_img.visible = true;
					_img2.visible = false;
				}
			}

			if (_timeElapsedInState > ScreenDuration) // advance automatically
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
