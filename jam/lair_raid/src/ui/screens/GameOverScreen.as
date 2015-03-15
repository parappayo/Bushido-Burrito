package ui.screens 
{
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	import feathers.data.*;
	import starling.text.TextField;

	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import ui.widgets.PartyView;
	import sim.SimStage;
	import sim.Character;

	public class GameOverScreen extends ui.screens.Screen
	{
		private var _caption :TextField;
		private var _timeLeft :ProgressBar;
		private var _text :TextField;
		private var _party :PartyView;
		
		public function GameOverScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			ScreenDuration = SimStage.StageLength;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_timeLeft = new ProgressBar();
				_timeLeft.maximum = 10;
				_timeLeft.minimum = 0;
				_timeLeft.width = Settings.ScreenWidth;
				_timeLeft.height = 50;
				_game.UISprite.addChild(_timeLeft);

				_caption = new TextField(Settings.ScreenWidth, 50, "Back to Town", "theme_font", 16, 0x000000);
				_game.UISprite.addChild(_caption);
				
				_party = new PartyView();
				_party.width = Settings.ScreenWidth;
				_party.height = 250;
				_party.y = Settings.ScreenHeight - _party.height;
				_game.UISprite.addChild(_party);
				
				for each (var chara :Character in _game.Recruit.Party)
				{
					_party.addCharacter(chara, true);
				}
				_party.refreshLayout();
				
				_text = new TextField(Settings.ScreenWidth, Settings.ScreenHeight - _caption.height - _party.height, "", "theme_font", 16, 0x000000);
				_text.text = Settings.GameOverCaption;
				_text.y = _timeLeft.height;
				_game.UISprite.addChild(_text);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_caption, true);
				_caption = null;
				
				_game.UISprite.removeChild(_timeLeft, true);
				_timeLeft = null;
				
				_game.UISprite.removeChild(_text, true);
				_text = null;
				
				_game.UISprite.removeChild(_party, true);
				_party = null;
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			_timeLeft.value = (ScreenDuration - _timeElapsedInState);
			
			if (_timeElapsedInState > ScreenDuration)
			{
				_parent.handleChildDone();
				return;
			}
			
			for each (var chara :Character in _game.Recruit.Party)
			{
				_party.updateData(chara);
			}
		}

	} // class
	
} // package
