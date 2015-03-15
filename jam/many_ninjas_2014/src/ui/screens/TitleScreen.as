package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.*;
	import starling.text.TextField;
	
	public class TitleScreen extends Screen
	{
		private var _sprite :Sprite;
		
		private const CaptionOnTimer :Number = 0.5; // seconds
		private const CaptionOffTimer :Number = 0.3; // seconds
		private const ExitTimer :Number = 0.5; // seconds

//		private var _img :Image;
		private var _title :TextField;
		private var _caption :TextField;
		private var _timer :Number;
		private var _exit :Boolean;
		
		public function TitleScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			_sprite = new Sprite();
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
				
//				_img = new Image(Assets.TitleScreenTexture);
//				_game.UISprite.addChild(_img);

				_title = new TextField(Settings.ScreenWidth, 100, "Many Ninjas", Settings.DefaultFont, 32);
				_title.y = Settings.ScreenHeight * 0.4;
				_sprite.addChild(_title);

				_caption = new TextField(Settings.ScreenWidth, 30, "Press [" + Settings.AcceptButton + "] to begin", Settings.DefaultFont, Settings.FontSize);
				_caption.y = Settings.ScreenHeight * 0.6;
				_caption.visible = false;
				_sprite.addChild(_caption);

				_timer = 0;
				_exit = false;
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
				(signal == Signals.ACCEPT_KEYUP || signal == Signals.TOUCH_BEGAN) &&
				!_exit)
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
