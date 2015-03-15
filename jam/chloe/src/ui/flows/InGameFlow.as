package ui.flows 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import resources.*;
	import sim.Level;
	import ui.screens.*;

	public class InGameFlow extends Flow 
	{
		private var _hud :Hud;
		private var _radioDialog :RadioDialog;
		private var _victoryScreen :VictoryScreen;
		private var _gameOverScreen :GameOverScreen;
		
		private var _game :Game;
		private var _mx1MusicChannel: SoundChannel;

		public var gameLevel :Level;

		public function InGameFlow(parent :Flow, game :Game) 
		{
			super(parent);
			_game = game;
			
			_hud = new Hud(this, game);
			_radioDialog = new RadioDialog(this, game);
			_victoryScreen = new VictoryScreen(this, game);
			_gameOverScreen = new GameOverScreen(this, game);
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			switch (_state)
			{
				case FlowStates.ACTIVE:
					{
						_game.updateSim(elapsed);
					}
					break;
			}
		}
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			// some signals are processed regardless of state
			if (signal == Signals.VICTORY)
			{
				changeState(FlowStates.VICTORY_SCREEN);
			}
			else if (signal == Signals.PLAYER_DIED)
			{
				changeState(FlowStates.GAME_OVER_SCREEN);
			}
			
			switch (_state)
			{
				case FlowStates.ACTIVE:
					{
						if (signal == Signals.RADIO_USED)
						{
							changeState(FlowStates.RADIO_DIALOG);
							_game.setRadioCaption(_radioDialog);
						}
					}
					break;
					
				case FlowStates.RADIO_DIALOG:
					{
						if (signal == Signals.RESUME_GAME)
						{
							changeState(FlowStates.ACTIVE);
						}
					}
					break;					
			}
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.LOADING:
					{
						enterGame();
						changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.RADIO_DIALOG:
					{
						_child = _radioDialog;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;

				case FlowStates.VICTORY_SCREEN:
					{
						_child = _victoryScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.GAME_OVER_SCREEN:
					{
						_child = _gameOverScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
			}
		}
		
		override public function handleChildDone() :void
		{
			super.handleChildDone();
			
			switch (_state)
			{
				case FlowStates.RADIO_DIALOG:
					{
						changeState(FlowStates.ACTIVE);
					}
					break;

				case FlowStates.VICTORY_SCREEN:
					{
						// return to main menu
						_parent.handleChildDone();
					}
					break;

				case FlowStates.GAME_OVER_SCREEN:
					{
						changeState(FlowStates.ACTIVE);
						_game.handleSignal(Signals.LEVEL_RESET);
					}
					break;
			}
		}
		
		private function enterGame() :void
		{
			_game.loadLevel(Settings.StartingLevel);
			_hud.show();
		}
	}

} // package
