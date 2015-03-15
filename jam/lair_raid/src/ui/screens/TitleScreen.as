package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	
	import starling.display.*;
	import starling.text.TextField;
	
	public class TitleScreen extends Screen
	{
		//private var _img :Image;
		private var _title :TextField;
		private var _prompt :TextField;
		private var _exit :Boolean;
		
		public function TitleScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				//_img = new Image(Assets.TitleScreenTexture);
				//_game.UISprite.addChild(_img);
				
				_title = new TextField(Settings.ScreenWidth, 250, "Lair Raid 2014", "theme_font", 32, 0x000000);
				_title.y = (Settings.ScreenHeight - _title.height) / 2 - 50;
				_game.UISprite.addChild(_title);

				_prompt = new TextField(Settings.ScreenWidth, 250, "Click to Begin", "theme_font", 32, 0x000000);
				_prompt.y = (Settings.ScreenHeight - _title.height) * 0.8;
				_prompt.visible = false;
				_game.UISprite.addChild(_prompt);

				_exit = false;
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				//_game.UISprite.removeChild(_img, true);
				//_img = null;
				
				_game.UISprite.removeChild(_title, true);
				_title = null;
				
				_game.UISprite.removeChild(_prompt, true);
				_prompt = null;
			}
		}
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (_timeElapsedInState > MinScreenDuration && signal == Signals.ACCEPT_KEYUP && !_exit)
			{
				_prompt.visible = false;
				_exit = true;
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);

			if (_exit && _timeElapsedInState > MinScreenDuration)
			{
				_parent.handleChildDone();
			}
			else
			{
				_prompt.visible = (_timeElapsedInState > MinScreenDuration)
			}
		}

	} // class

} // package
