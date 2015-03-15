package sim 
{
	/**
	 *  Not to be confused with the Flash stage, this is a state of gameplay.
	 */
	public class SimStage 
	{
		protected var _isActive :Boolean;
		protected var _timeLeft :Number;
		
		static public const StageLength :Number = 10;
		
		public var Party :Vector.<Character>;
		public var Mobs :Vector.<Enemy>;

		public function start(game :Game) :void
		{
			_timeLeft = StageLength;
			_isActive = true;
		}
		
		public function end(game :Game) :void
		{
			_timeLeft = 0;
			_isActive = false;
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			if (!_isActive) { return; }
			
			_timeLeft -= elapsed;
			if (_timeLeft < 0) { _timeLeft = 0; }
		}
		
		public function handleSignal(game :Game, signal :int) :void {}
		
		public function timeLeft() :Number
		{
			return _timeLeft;
		}
		
		public function succeeded() :Boolean
		{
			return true;
		}
		
		public function getTarget(chara :Character) :Enemy
		{
			if (!Mobs) { return null; }
			
			var i :int = Math.random() * Mobs.length;
			if (!Mobs[i].isDead())
			{
				return Mobs[i];
			}
			
			// random pick failed, let's just grab the first available
			for each (var mob :Enemy in Mobs)
			{
				if (!mob.isDead()) { return mob; }
			}
			return null;
		}
		
		public function getDeadPartyMember() :Character
		{
			// TODO: some selection criteria would be nice
			for each (var chara :Character in Party)
			{
				if (chara.isDead())
				{
					return chara;
				}
			}
			return null;
		}
		
		public function getPartyMemberWithLowestHP() :Character
		{
			if (Party.length < 1) { return null; }
			var retval :Character = Party[0];
			
			for each (var chara :Character in Party)
			{
				if (chara.HP < retval.HP)
				{
					retval = chara;
				}
			}
			
			return retval;
		}
		
		public function getRandomPartyMember() :Character
		{
			if (Party.length < 1) { return null; }
			var i :int = Math.random() * Party.length;
			return Party[i];
		}
		
		public function spawnMobs(game :Game, count :int) :void
		{
			Mobs = new Vector.<Enemy>();
			
			for (var i :int = 0; i < count; i++)
			{
				var enemy :Enemy = new Enemy();
				enemy.roll(game.DifficultyTier);
				Mobs.push(enemy);
			}
		}
		
		public function getAreaTargets(posX :Number, posY :Number, radius :Number) :Vector.<Enemy>
		{
			var retval :Vector.<Enemy> = new Vector.<Enemy>();
			var r2 :Number = radius * radius;

			for each (var mob :Enemy in Mobs)
			{
				if (mob.isDead()) { continue; }
				
				var dx :Number = mob.PositionX - posX;
				var dy :Number = mob.PositionY - posY;
				
				if ( (dx * dx) + (dy * dy) < r2)
				{
					retval.push(mob);
				}
			}
			
			return retval;
		}
		
	} // class

} // package
