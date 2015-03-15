package components 
{
	import starling.events.*;
	import utils.Dice;
	import wyverntail.core.*;

	public class Attackable extends Component
	{
		private var _game :Game;
		private var _pos :Position2D;
		private var _unitStats :UnitStats;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_pos = getComponent(Position2D) as Position2D;
			_unitStats = getComponent(UnitStats) as UnitStats;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_unitStats.isDead())
			{
				enabled = false;
				return false;
			}
			
			const attackRange :Number = Settings.TileWidth * 1.1;
			var dmgRoll :Number;
			var attackerStats :UnitStats;
			
			switch (signal)
			{
				case Signals.PLAYER_CHARGE_ATTACK:
					{
						if (_unitStats.playerSide) { return false; }
				
						if (_pos.distanceSquared2f(args.posX, args.posY) < attackRange * attackRange)
						{
							dmgRoll = Dice.rolld8();
							_unitStats.hitPoints -= dmgRoll;
							
							if (_unitStats.isDead())
							{
								_entity.handleSignal(Signals.UNIT_DEFEATED, this, { } );
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " is defeated" } );
							}
							else
							{
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " gets charged for " + dmgRoll + " damage" } );
							}
							return true; // no other targets can be attacked
						}
					}
					break;
				
				case Signals.AI_CHARGE_ATTACK:
					{
						if (!_unitStats.playerSide) { return false; }				
						
						if (_pos.distanceSquared2f(args.posX, args.posY) < attackRange * attackRange)
						{
							dmgRoll = Dice.rolld8();
							_unitStats.hitPoints -= dmgRoll;

							if (_unitStats.isDead())
							{
								_entity.handleSignal(Signals.UNIT_DEFEATED, this, { } );
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " is defeated" } );
							}
							else
							{
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " gets charged for " + dmgRoll + " damage" } );
							}
							return true; // no other targets can be attacked
						}
					}
					break;

				case Signals.SELECTED_STATE_CHANGED:
					{
						if (_unitStats.playerSide) { return false; }
						
						// on a de-select of a player unit, see if we are clicked and if so treat it as an attack
						var senderSelectable :Selectable = sender as Selectable;
						if (!senderSelectable) { return false; }
						if (senderSelectable.selected) { return false; }
						
						attackerStats = senderSelectable.getComponent(UnitStats) as UnitStats;
						if (attackerStats.hasAttacked) { return false; }
						
						var mySelectable :Selectable = getComponent(Selectable) as Selectable;

						if (args == null) { return false; }
						var event :TouchEvent = args.touchEvent;
						if (event == null) { return false; }
						var touch :Touch = event.getTouch(mySelectable.stage, TouchPhase.BEGAN);
						if (touch == null) { return false; }
						
						if (!mySelectable.collides(touch.globalX, touch.globalY)) { return false; }
					
						_game.handleSignal(Signals.PLAYER_ATTACK, this, { attacker : senderSelectable, target : this } );
					}
					break;
						
				case Signals.PLAYER_ATTACK:
				case Signals.AI_ATTACK:
					{
						// check if we're the one being attacked
						var target :Component = args.target as Component;
						if (target == null || !target.isSibling(this)) { return false; }
						
						// check factions
						if (signal == Signals.PLAYER_ATTACK)
						{
							if (_unitStats.playerSide) { return false; }
						}
						else // signal == Signals.AI_ATTACK
						{
							if (!_unitStats.playerSide) { return false; }
						}
						
						// check range
						var attackerPos :Position2D = args.attacker.getComponent(Position2D) as Position2D;
						if (_pos.distanceSquared2f(attackerPos.worldX, attackerPos.worldY) < attackRange * attackRange * 4)
						{
							dmgRoll = Dice.roll3d8();
							_unitStats.hitPoints -= dmgRoll;

							if (_unitStats.isDead())
							{
								_entity.handleSignal(Signals.UNIT_DEFEATED, this, { } );
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " is defeated" } );
							}
							else
							{
								_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : _unitStats.caption + " gets attacked for " + dmgRoll + " damage" } );
							}
							
							attackerStats = args.attacker.getComponent(UnitStats) as UnitStats;
							attackerStats.hasAttacked = true;
							
							// no other targets can be attacked by the same message
							return true;
						}
					}
					break;
			}
			
			return false;
		}
		
	} // class

} // package
