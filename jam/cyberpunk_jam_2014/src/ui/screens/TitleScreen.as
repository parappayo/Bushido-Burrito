package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	
	public class TitleScreen extends Screen
	{
		private const CaptionOnTimer :Number = 0.5; // seconds
		private const CaptionOffTimer :Number = 0.3; // seconds
		private const ExitTimer :Number = 0.5; // seconds
		private var _img :Image;
		private var _caption :TextField;
		private var _timer :Number;
		private var _exit :Boolean;
		
		public function TitleScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_img = new Image(Assets.TitleScreenTexture);
				_caption = new TextField(Settings.ScreenWidth, 30, "Press [" + Settings.AcceptButton + "] to begin", Settings.DefaultFont, Settings.FontSize, 0xffffff);
				_caption.y = 540;
				_caption.visible = false;
				_timer = 0;
				_exit = false;
				_game.UISprite.addChild(_img);
				_game.UISprite.addChild(_caption);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_img, true);
				_game.UISprite.removeChild(_caption, true);
				_img = null;
				_caption = null;
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_timeElapsedInState > MinScreenDuration && signal == Signals.ACCEPT_KEYUP && !_exit)
			{
				_caption.visible = false;
				_timer = 0;
				_exit = true;
				return true;
			}
			
			return super.handleSignal(signal, sender, args);
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);

			// exiting
			if (_exit)
			{
				if (_timer > ExitTimer)
				{
					_parent.handleChildDone();
				}
			}
			// updating
			else
			{
				var toggle :Boolean = false;
				if (_caption.visible)
				{
					toggle = (_timer > CaptionOnTimer);
				}
				else
				{
					toggle = (_timer > CaptionOffTimer);
				}
				if (toggle)
				{
					_caption.visible = !_caption.visible;
					_timer = 0;
				}	
			}
			
			// timer
			if (_timeElapsedInState > MinScreenDuration)
			{
				_timer += elapsed;
			}
		}

	} // class

} // package
