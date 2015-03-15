package ui.flows 
{
	import wyverntail.core.Flow;
	import ui.screens.*;

	public class InGameFlow extends Flow
	{
		private var _game :Game;
		private var _hud :Hud;
		private var _victoryScreen :VictoryScreen;
		private var _gameOverScreen :GameOverScreen;
		private var _creditsScreen :CreditsScreen;
		private var _pauseScreen :PauseScreen;
		private var _messageDialog :MessageDialog;
		private var _epilogueScreen :EpilogueScreen;
		
		public function InGameFlow(parent :Flow, game :Game) 
		{
			super(parent);
			
			_game = game;
			_hud = new Hud(this, game);
			_victoryScreen = new VictoryScreen(this, game);
			_gameOverScreen = new GameOverScreen(this, game);
			_creditsScreen = new CreditsScreen(this, game);
			_pauseScreen = new PauseScreen(this, game);
			_messageDialog = new MessageDialog(this, game);
			_epilogueScreen = new EpilogueScreen(this, game);
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
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			// some signals are processed regardless of state
			if (signal == Signals.VICTORY)
			{
				changeState(FlowStates.VICTORY_SCREEN);
				return true;
			}
			else if (signal == Signals.PLAYER_DIED)
			{
				changeState(FlowStates.GAME_OVER_SCREEN);
				return true;
			}

			switch (_state)
			{
				case FlowStates.ACTIVE:
					{
						if (signal == Signals.BACK_KEYUP ||
							signal == Signals.HELP_KEYUP)
						{
							queueSignal(Signals.PAUSE_GAME, null, null);
							return true;
						}
						else if (signal == Signals.PAUSE_GAME)
						{
							changeState(FlowStates.PAUSE_SCREEN);
							return true;
						}
						else if (signal == Signals.SHOW_DIALOG)
						{
							_messageDialog.setCaption(args.caption);
							changeState(FlowStates.MESSAGE_DIALOG);
							return true;
						}
						else if (signal == Signals.LEVEL_TRANSITION)
						{
							_game.loadLevel(Assets[args.target_level], args.target_spawn);
						}
					}
					break;
					
				case FlowStates.PAUSE_SCREEN:
					{
						if (signal == Signals.RESUME_GAME)
						{
							changeState(FlowStates.ACTIVE);
							return true;
						}
					}
					break;
			}

			return super.handleSignal(signal, sender, args);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.ACTIVE:
					{
						_hud.show();

						// TODO: resume in-game music here
					}
					break;
					
				case FlowStates.LOADING:
					{
						_game.loadLevel(Settings.StartingLevel, "default");
						changeState(FlowStates.ACTIVE);
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
					
				case FlowStates.MESSAGE_DIALOG:
					{
						_child = _messageDialog;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.EPILOGUE_SCREEN:
					{
						SoundPlayer.playMusic(Assets.AmbientMusic);
						
						_child = _epilogueScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.EXIT:
					{
						// TODO: stop game music here
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
				case FlowStates.VICTORY_SCREEN:
					{
						var nextLevel :Class = _game.getNextLevel();
						if (nextLevel == null)
						{
							changeState(FlowStates.EPILOGUE_SCREEN);
						}
						else
						{
							_game.loadLevel(nextLevel, "default");
							changeState(FlowStates.ACTIVE);
						}
					}
					break;
					
				case FlowStates.EPILOGUE_SCREEN:
					{
						changeState(FlowStates.CREDITS_SCREEN);
					}
					break;

				case FlowStates.GAME_OVER_SCREEN:
					{
						changeState(FlowStates.ACTIVE);
						
						// TODO: reset the player state here
						_game.handleSignal(Signals.LEVEL_RESET, this, {});
					}
					break;
					
				case FlowStates.CREDITS_SCREEN:
					{
						// return to main menu
						_game.unloadLevel();
						_parent.handleChildDone();
					}
					break;
					
				case FlowStates.PAUSE_SCREEN:
					{
						queueSignal(Signals.RESUME_GAME, null, null);
					}
					break;
					
				case FlowStates.MESSAGE_DIALOG:
					{
						changeState(FlowStates.ACTIVE);			
					}
					break;
					
				case FlowStates.STOCK_MARKET_SCREEN:
					{
						changeState(FlowStates.ACTIVE);
					}
					break;
			}
		}		
	}

} // package
