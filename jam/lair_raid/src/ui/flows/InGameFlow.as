package ui.flows 
{
	import ui.screens.*;

	public class InGameFlow extends Flow 
	{
		private var _recruitScreen :RecruitScreen;
		private var _trashMobsScreen :TrashMobsScreen;
		private var _bossScreen :BossScreen;
		private var _victoryScreen :VictoryScreen;
		private var _gameOverScreen :GameOverScreen;
		
		private var _game :Game;

		public function InGameFlow(parent :Flow, game :Game) 
		{
			super(parent);
			_game = game;
			
			_recruitScreen = new RecruitScreen(this, game);
			_trashMobsScreen = new TrashMobsScreen(this, game);
			_bossScreen = new BossScreen(this, game);
			_victoryScreen = new VictoryScreen(this, game);
			_gameOverScreen = new GameOverScreen(this, game);
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			// put a limit on how long a frame can be
			if (elapsed > 0.1) { elapsed = 0.1; }
			
			switch (_state)
			{
				case FlowStates.RECRUIT_SCREEN:
					{
						_game.Recruit.update(_game, elapsed);
					}
					break;
					
				case FlowStates.TRASH_MOBS_SCREEN:
					{
						_game.TrashMobs.update(_game, elapsed);
					}
					break;
					
				case FlowStates.BOSS_SCREEN:
					{
						_game.Boss.update(_game, elapsed);
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
						changeState(FlowStates.RECRUIT_SCREEN);
					}
					break;
					
				case FlowStates.RECRUIT_SCREEN:
					{
						_child = _recruitScreen;
						_child.changeState(FlowStates.ACTIVE);						
					}
					break;
					
				case FlowStates.TRASH_MOBS_SCREEN:
					{
						_child = _trashMobsScreen;
						_child.changeState(FlowStates.ACTIVE);						
					}
					break;
					
				case FlowStates.BOSS_SCREEN:
					{
						_child = _bossScreen;
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
				case FlowStates.RECRUIT_SCREEN:
					{
						if (Settings.SkipToBossFight)
						{
							changeState(FlowStates.BOSS_SCREEN);
						}
						else
						{
							changeState(FlowStates.TRASH_MOBS_SCREEN);
						}
					}
					break;
					
				case FlowStates.TRASH_MOBS_SCREEN:
					{
						if (_game.TrashMobs.succeeded())
						{
							changeState(FlowStates.BOSS_SCREEN);
						}
						else
						{
							changeState(FlowStates.GAME_OVER_SCREEN);	
						}
					}
					break;
					
				case FlowStates.BOSS_SCREEN:
					{
						if (_game.Boss.succeeded())
						{
							changeState(FlowStates.VICTORY_SCREEN);
						}
						else
						{
							changeState(FlowStates.GAME_OVER_SCREEN);
						}
					}
					break;
					
				case FlowStates.VICTORY_SCREEN:
					{
						// return to main menu
						//_parent.handleChildDone();
						
						changeState(FlowStates.ACTIVE);
					}
					break;

				case FlowStates.GAME_OVER_SCREEN:
					{
						changeState(FlowStates.ACTIVE);
					}
					break;
			}
		}
		
	} // class

} // package
