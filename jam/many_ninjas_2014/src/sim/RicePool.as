package sim 
{
	import wyverntail.core.*;

	/**
	 *  Manages the rice
	 * 
	 *  A Better Tomorrow 2 - If you have any dignity, apologize to the rice right now!!
	 */
	public class RicePool extends Component
	{
		private var _game :Game;

		private var _RiceFieldsOwned :Number;
		public function get RiceFieldsOwned() :Number { return _RiceFieldsOwned; }
		public function set RiceFieldsOwned(value :Number) :void
		{
			_RiceFieldsOwned = value;
			//_NinjaPool.SpawnRate = Number(RiceFieldsOwned) / 10.0;
		}
		
		private var _BagsOfRice :Number = 0;
		public function get BagsOfRice() :Number { return _BagsOfRice; }
		public function set BagsOfRice(value :Number) :void
		{
			_BagsOfRice = value;
		}
		
		public var NinjaHarvestUpgradeLevel :int = 0;
		public static const MaxNinjaHarvestUpgradeLevel :int = 25;
		public function get NinjaHarvestFactor() :Number
		{
			return ninjaHarvestFactor(NinjaHarvestUpgradeLevel);
		}
		public function ninjaHarvestFactor(level :int) :Number
		{
			return 0.005 * level;
		}
		public function ninjaHarvestCost(level :int) :Number
		{
			return Math.pow(25, level);
		}

		public var AutoHarvestUpgradeLevel :int = 0;
		public static const MaxAutoHarvestUpgradeLevel :int = 21;
		public function get AutoHarvestPeriod() :Number
		{
			return autoHarvestPeriod(AutoHarvestUpgradeLevel);
		}
		public function autoHarvestPeriod(level :int) :Number
		{
			if (level < 1)
			{
				return 3600 * 3650; // once per decade
			}
			return Math.max(0.25, MaxAutoHarvestUpgradeLevel * 0.5 - (0.5 * level));
		}
		public function autoHarvestCost(level :int) :Number
		{
			return Math.pow(15, level);
		}
		
		public static const CookTime :Number = 3.0; // seconds
		
		private var _cookingTimer :Number = 0.0;
		private var _autoHarvestTimer :Number = 0.0;
		
		private var _NinjaPool :NinjaPool;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_NinjaPool = getComponent(NinjaPool) as NinjaPool;
			RiceFieldsOwned = 1;
		}
		
		override public function update(elapsed :Number) :void
		{
			var ninjaHarvestFactor :Number = 0.0;
			
			if (CookingInProgress)
			{
				_cookingTimer += elapsed;
				if (_cookingTimer >= CookTime)
				{
					_CookingInProgress = false;
				}
			}
			else if (AutoHarvestUpgradeLevel > 0)
			{
				_autoHarvestTimer += elapsed;
				if (_autoHarvestTimer >= AutoHarvestPeriod)
				{
					var riceAdded :Number = harvestRice();
					_autoHarvestTimer -= AutoHarvestPeriod;
					
					//_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this, { caption : "Auto harvest collected " + Utils.formatNumber(riceAdded) + " sacks of rice" } );
				}
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.CASTLE_CONQUERED)
			{
				RiceFieldsOwned += Math.floor(args.castlePower / 10);
			}
			
			return false;
		}
		
		public function harvestRice() :Number
		{
			var riceAdded :Number = RiceFieldsOwned + _NinjaPool.TotalNinjas * NinjaHarvestFactor;
			BagsOfRice += riceAdded;
			return riceAdded;
		}
		
		public function cookAllRice() :void
		{
			_cookingTimer = 0;
			_CookingInProgress = true;

			_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this, { caption : "The smell of cooking rice attracts " + Utils.formatNumber(BagsOfRice) + " hungry ninjas" } );
			
			_NinjaPool.addNinjas(BagsOfRice);
			BagsOfRice = 0;
		}
		
		private var _CookingInProgress :Boolean = false;
		public function get CookingInProgress() :Boolean
		{
			return _CookingInProgress;
		}
		public function get CookingProgress() :Number
		{
			return _cookingTimer / CookTime;
		}

	} // class

} // package
