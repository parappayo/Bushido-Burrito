package components 
{
	import wyverntail.core.*;

	public class UnitStats extends Component
	{
		public var caption :String;
		public var hitPoints :int;
		public var playerSide :Boolean;
		
		// actions taken this turn
		public var hasMoved :Boolean;
		public var hasAttacked :Boolean;
		
		public function isDead() :Boolean { return hitPoints < 1; }
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			caption = prefabArgs.unitStats.caption;
			hitPoints = prefabArgs.unitStats.hitPoints;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.PLAYER_TURN_START)
			{
				hasMoved = false;
				hasAttacked = false;
			}
			return false;
		}
		
	} // class

} // package
