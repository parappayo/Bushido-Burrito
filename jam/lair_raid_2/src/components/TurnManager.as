package components 
{
	import wyverntail.core.*;

	public class TurnManager extends Component
	{
		private var _game :Game;

		private var _isPlayerTurn :Boolean;
		public function get isPlayerTurn() :Boolean { return _isPlayerTurn; }
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			
			_isPlayerTurn = true;
		}
		
		override public function update(elapsed :Number) :void
		{
			var unit :Entity;
			var stats :UnitStats;
			var mover :TacticalGridMovement;
			var units :Vector.<Entity> = scene.findEntities(UnitStats);
			
			var gameOver :Boolean = true;
			var victory :Boolean = true;
			for each (unit in units)
			{
				stats = unit.getComponent(UnitStats) as UnitStats;
				if (stats.playerSide && !stats.isDead()) { gameOver = false; }
				if (!stats.playerSide && !stats.isDead()) { victory = false; }
			}
			
			if (gameOver)
			{
				_game.handleSignal(Signals.PLAYER_DIED, this, {});
				return;
			}
			if (victory)
			{
				_game.handleSignal(Signals.VICTORY, this, {});
				return;
			}
			
			if (_isPlayerTurn)
			{
				var turnDone :Boolean = true;

				// end the turn automatically when all player units have moved
				for each (unit in units)
				{
					stats = unit.getComponent(UnitStats) as UnitStats;
					if (!stats.playerSide || stats.isDead()) { continue; }
					mover = unit.getComponent(TacticalGridMovement) as TacticalGridMovement;
					turnDone = turnDone && stats.hasMoved; // && stats.hasAttacked; // TODO: check for "can attack"
				}
				
				if (turnDone) { startNextTurn(); }
			}
			else
			{
				// move all of the AI units
				for each (unit in units)
				{
					stats = unit.getComponent(UnitStats) as UnitStats;
					if (stats.playerSide) { continue; }
					mover = unit.getComponent(TacticalGridMovement) as TacticalGridMovement;
					if (mover.moveTowardNearestHostile())
					{
						// execute an additional melee attack
						// note: not guaranteed to be the same unit we moved toward
						var target :Entity = mover.findNearestHostile();
						var targetMover :TacticalGridMovement = target.getComponent(TacticalGridMovement) as TacticalGridMovement;
						_game.handleSignal(Signals.AI_ATTACK, this, { attacker : mover, target : targetMover } );
					}
				}

				startNextTurn();
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ACTION_KEYUP)
			{
				if (_isPlayerTurn)
				{
					startNextTurn();
					return true;
				}
			}
			
			return false;
		}
		
		public function startNextTurn() :void
		{
			_isPlayerTurn = !_isPlayerTurn;
			
			if (_isPlayerTurn)
			{
				_game.handleSignal(Signals.PLAYER_TURN_START, this, { } );				
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "Player's Turn" } );
			}
			else
			{
				_game.handleSignal(Signals.AI_TURN_START, this, { } );				
				_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : "Enemy's Turn" } );
			}
		}

	} // class

} // package
