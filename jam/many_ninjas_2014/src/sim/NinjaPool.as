package sim 
{
	import wyverntail.core.*;
	import entities.Ninja;

	/**
	 *  Manages the number of ninjas
	 */
	public class NinjaPool extends Component
	{
		public var SpawnRate :Number = 0; // ninjas per second
		
		public static const NUM_NINJA_RANKS :int = 12;
		public static const SpawnedNinjas :int = 240;
		
		private var _game :Game;
		private var _ninjaCount :Vector.<Number>;
		private var _spawnTimer :Number = 0.0;
		private var _clanLeaderTimer :Number = 0.0;
		private var _totalNinjas :Number = -1; // cached value
		
		private var _spawnedNinjas :Vector.<Ninja>;
		
		private var _RicePool :RicePool;
		private var _CastlePool :CastlePool;

		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			var i :int;
			
			_game = prefabArgs.game;
			
			_RicePool = getComponent(RicePool) as RicePool;
			_CastlePool = getComponent(CastlePool) as CastlePool;

			_ninjaCount = new Vector.<Number>();
			for (i = 0; i < NUM_NINJA_RANKS; i++)
			{
				_ninjaCount.push(0);
			}
			
			_spawnedNinjas = new Vector.<Ninja>();
			for (i = 0; i < SpawnedNinjas; i++)
			{
				var ninja :Ninja = _game.spawnNinja().getComponent(Ninja) as Ninja;
				ninja.enabled = false;
				_spawnedNinjas.push(ninja);
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			_spawnTimer += elapsed;
			
			if (_RicePool.CookingInProgress) { return; }

			if (TrainingInProgress)
			{
				_trainingTimer += elapsed;
				if (_trainingTimer >= RaidTime)
				{
					_TrainingInProgress = false;
				}
				return;
			}

			if (RaidInProgress)
			{
				_raidTimer += elapsed;
				if (_raidTimer >= RaidTime)
				{
					_RaidInProgress = false;
				}
				return;
			}
			
			if (_spawnTimer > SpawnRate)
			{
				_ninjaCount[0] += SpawnRate > 0 ? _spawnTimer / SpawnRate : 0;
				_totalNinjas = -1; // force recount
				
				_spawnTimer = _spawnTimer % SpawnRate;
			}
			
			if (ClanLeaderUpgradeLevel > 0)
			{
				_clanLeaderTimer += elapsed;
				if (_clanLeaderTimer > ClanLeaderPeriod)
				{
					_clanLeaderTimer = _clanLeaderTimer % ClanLeaderPeriod;
					
					clanLeaderAction();
				}
			}

			refreshSpawnedNinjas();
		}
		
		public static function ninjaTextureName(rank :int, animation :String) :String
		{
			rank += 1;
			if (rank < 10)
			{
				return "rank0" + rank.toString() + "_" + animation;
			}
			return "rank" + rank.toString() + "_" + animation;
		}
		
		public function ninjaCountAtRank(rank :int) :Number
		{
			return Math.floor(_ninjaCount[rank]);
		}
		
		public function addNinjas(count :Number) :void
		{
			_ninjaCount[0] += count;
			_totalNinjas = -1; // force re-count
		}
		
		public function applyDamage(damage :Number) :void
		{
			for (var rank :int = 0; rank < NUM_NINJA_RANKS; rank++)
			{
				var ninjaCount :Number = _ninjaCount[rank];
				var powerAtRank :Number = ninjaCount * Math.pow(10, rank);
				var casualties :Number = 0;
				if (powerAtRank > 0)
				{
					casualties = Math.floor(Math.min(ninjaCount, (damage / powerAtRank) * ninjaCount) * 0.8);
				}
				
				applyCasualtiesToRank(rank, casualties);
				
				damage -= powerAtRank;
				if (damage <= 0) { break; }
			}
		}
		
		public function applyCasualtiesToRank(rank :int, casualties :Number) :void
		{
			_ninjaCount[rank] -= casualties;
			_totalNinjas = -1; // force re-count

			// promote ninjas
			if (rank < NUM_NINJA_RANKS - 1)
			{
				_ninjaCount[rank + 1] += Math.ceil(casualties / 5);
			}
		}
		
		public function trainNinjas() :void
		{
			if (TrainingFactor == 0) { return; }
			
			_trainingTimer = 0;
			_TrainingInProgress = true;

			for (var rank :int = 0; rank < NUM_NINJA_RANKS-1; rank++)
			{
				var promotions :Number = Math.floor(_ninjaCount[rank] * TrainingFactor);
				_ninjaCount[rank] -= promotions;
				_ninjaCount[rank + 1] += promotions;
			}
		}
		
		public function get TotalNinjas() :Number
		{
			if (_totalNinjas >= 0) { return _totalNinjas; }
			var retval :Number = 0;
			for (var rank :int = 0; rank < NUM_NINJA_RANKS; rank++)
			{
				retval += Math.floor(_ninjaCount[rank]);
			}
			_totalNinjas = retval;
			return retval;
		}
		
		public function get TotalPower() :Number
		{
			var retval :Number = 0;
			for (var rank :int = 0; rank < NUM_NINJA_RANKS; rank++)
			{
				retval += _ninjaCount[rank] * Math.pow(10, rank);
			}
			return retval;
		}
		
		public function raidCastle() :Boolean
		{
			_raidTimer = 0;
			_RaidInProgress = true;

			var ninjasBefore :Number = TotalNinjas;
			var riceBefore :Number = _RicePool.BagsOfRice;

			var success :Boolean = TotalPower > _CastlePool.CurrentCastlePower;
			
			applyDamage(_CastlePool.CurrentCastlePower);
			refreshSpawnedNinjas();

			if (success)
			{
				_RicePool.BagsOfRice += TotalPower;
				_CastlePool.conquerCurrentCastle();
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Raid succeeded, " + Utils.formatNumber(_RicePool.BagsOfRice - riceBefore) + " bags of rice plundered" } );
			}
			else
			{
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Raid failed, " + Utils.formatNumber(ninjasBefore - TotalNinjas) + " ninjas lost" } );
			}
			return success;
		}
		
		private function refreshSpawnedNinjas() :void
		{
			var i :Number;
			var numActivated :int = 0;
			
			for (var rank :int = NUM_NINJA_RANKS-1; rank >= 0; rank--)
			{
				// no more than 20 of any colour
				var ninjaCount :Number = Math.min(ninjaCountAtRank(rank), 20);
				
				for (i = 0; i < ninjaCount; i++)
				{
					_spawnedNinjas[numActivated].enabled = true;
					_spawnedNinjas[numActivated].Rank = rank;
					numActivated++;
				}
			}			
			
			for (i = numActivated; i < SpawnedNinjas; i++)
			{
				_spawnedNinjas[i].enabled = false;
			}
		}
		
		public var ClanLeaderUpgradeLevel :int = 0;
		public static const MaxClanLeaderUpgradeLevel :int = 31;
		public function get ClanLeaderPeriod() :Number // how often to auto-raid
		{
			return clanLeaderPeriod(ClanLeaderUpgradeLevel);
		}
		public function clanLeaderPeriod(level :int) :Number
		{
			if (level < 1)
			{
				return 3600 * 3650; // once per decade
			}
			return Math.max(2, MaxClanLeaderUpgradeLevel * 5 - (5 * level));
		}
		public function clanLeaderCost(level :int) :Number
		{
			return Math.pow(50, level);
		}
		
		public const RaidTime :Number = 3; // seconds
		private var _raidTimer :Number = 0;
		private var _RaidInProgress :Boolean = false;
		public function get RaidInProgress() :Boolean
		{
			return _RaidInProgress;
		}
		public function get RaidProgress() :Number
		{
			return _raidTimer / RaidTime;
		}
		
		public var TrainingUpgradeLevel :int = 0;
		public static const MaxTrainingUpgradeLevel :int = 25;
		public function get TrainingFactor() :Number
		{
			return trainingFactor(TrainingUpgradeLevel);
		}
		public function trainingFactor(level :int) :Number
		{
			return 0.01 * level;
		}
		public function trainingCost(level :int) :Number
		{
			return Math.pow(30, level);
		}
		
		public const TrainingTime :Number = 3; // seconds
		private var _trainingTimer :Number = 0;
		private var _TrainingInProgress :Boolean = false;
		public function get TrainingInProgress() :Boolean
		{
			return _TrainingInProgress;
		}
		public function get TrainingProgress() :Number
		{
			return _trainingTimer / TrainingTime;
		}
		
		private function clanLeaderAction() :void
		{
			var relativeStrength :Number = TotalPower / _CastlePool.CurrentCastlePower;
			
			if (relativeStrength > 0.8)
			{
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Ninja leader decided to raid a castle" } );
				raidCastle();
			}
			else if (relativeStrength > 0.5 && TrainingFactor > 0 && Math.random() > 0.5)
			{
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Ninja leader decided to conduct training exercises" } );
				trainNinjas();
			}
			else if (_RicePool.BagsOfRice < TotalNinjas * 0.5 || _RicePool.BagsOfRice < 1)
			{
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Ninja leader decided to harvest some rice" } );
				_RicePool.harvestRice();
			}
			else
			{
				_game.handleSignal(Signals.SHOW_HUD_MESSAGE, this,
					{ caption : "Ninja leader decided to cook the rice" } );
				_RicePool.cookAllRice();
			}
		}
		
	} // class

} // package
