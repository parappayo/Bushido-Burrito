package ui.flows 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import sim.Level;
	import ui.screens.*;
	import resources.*;

	public class InGameFlow extends Flow
	{
		private var _hud :Hud;
		private var _radioDialog :RadioDialog;
		private var _victoryScreen :VictoryScreen;
		private var _gameOverScreen :GameOverScreen;
		private var _creditsScreen :CreditsScreen;
		private var _pauseScreen :PauseScreen;
		
		private var _game :Game;
//		public var startingLevel :String;

		public function InGameFlow(parent :Flow, game :Game) 
		{
			super(parent);
			_game = game;
			
			_hud = new Hud(this, game);
			_radioDialog = new RadioDialog(this, game);
			_victoryScreen = new VictoryScreen(this, game);
			_gameOverScreen = new GameOverScreen(this, game);
			_creditsScreen = new CreditsScreen(this, game);
			_pauseScreen = new PauseScreen(this, game);
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			switch (_state)
			{
				case FlowStates.ACTIVE:
					{
						_game.updateSim(elapsed);
						_hud.update(elapsed);
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
						else if (signal == Signals.BACK_KEYUP)
						{
							queueSignal(Signals.PAUSE_GAME);
						}
						else if (signal == Signals.PAUSE_GAME)
						{
							changeState(FlowStates.PAUSE_SCREEN);
						}
					}
					break;
					
				case FlowStates.PAUSE_SCREEN:
					{
						if (signal == Signals.RESUME_GAME)
						{
							changeState(FlowStates.ACTIVE);
						}
					}
					break;

				case FlowStates.RADIO_DIALOG:
					{
						if (signal == Signals.RESUME_GAME)
						{
							changeState(FlowStates.ACTIVE);
						}
						else if (signal == Signals.PAUSE_GAME)
						{
							changeState(FlowStates.PAUSE_SCREEN);
						}
					}
					break;
			}
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.ACTIVE:
					{
						_hud.show();
						
						// hack to resume music after an app pause
						if (SoundPlayer._musicChannel == null)
						{
							SoundPlayer.playMusic();
						}
					}
					break;
					
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
						SoundPlayer._musicChannel.stop();
						SoundPlayer.play(Audio.Sting_Win, Settings.VolumeMusic);
					}
					break;
					
				case FlowStates.GAME_OVER_SCREEN:
					{
						_child = _gameOverScreen;
						_child.changeState(FlowStates.ACTIVE);
						SoundPlayer._musicChannel.stop();
						SoundPlayer.play(Audio.Sting_Death, Settings.VolumeMusic);
					}
					break;
					
				case FlowStates.CREDITS_SCREEN:
					{
						_child = _creditsScreen;
						_child.changeState(FlowStates.ACTIVE);						
					}
					break;
					
				case FlowStates.PAUSE_SCREEN:
					{
						_child = _pauseScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.EXIT:
					{
						SoundPlayer._musicChannel.stop();						
					}
					break;
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			switch (oldState)
			{
				case FlowStates.ACTIVE:
					{
						_hud.hide();
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
						changeState(FlowStates.CREDITS_SCREEN);
					}
					break;

				case FlowStates.GAME_OVER_SCREEN:
					{
						changeState(FlowStates.ACTIVE);
						
						if (_game.isInBossFight())
						{
							_game.clearPlayer(false);
							_game.handleSignal(Signals.LEVEL_RESET);
						}
						else
						{
							enterGame();
						}
					}
					break;
					
				case FlowStates.CREDITS_SCREEN:
					{
						// return to main menu
						exitGame();
						_parent.handleChildDone();
					}
					break;
					
				case FlowStates.PAUSE_SCREEN:
					{
						queueSignal(Signals.RESUME_GAME);
					}
					break;
			}
		}
		
		private function enterGame() :void
		{
			_game.clearPlayer(true);

			if (Settings.LoadSandbox)
			{
				_game.loadLevel("Sandbox");
			}
			else
			{
//				_game.loadLevel(startingLevel);
				_game.generateLevel();
			}
			
			SoundPlayer._musicChannel = SoundPlayer.playLooping(Audio.Song_Pillow_Theme, Settings.VolumeMusic);
		}
		
		private function exitGame() :void
		{
			_game.clearLevel();
			SoundPlayer._musicChannel.stop();
		}
	}

} // package
