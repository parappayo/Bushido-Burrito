package sim 
{
	public class BossStage extends SimStage
	{
		public var TheBoss :Boss;
		
		public function BossStage() 
		{
			
		}
		
		public override function start(game :Game) :void
		{
			super.start(game);
			
			Party = game.Recruit.Party;
			
			// TODO: should vary by tier
			spawnMobs(game, Settings.BossAdsCount);
			spawnBoss(game);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			super.update(game, elapsed);
			
			if (!_isActive) { return; }
			
			for each (var chara :Character in Party)
			{
				chara.update(game, elapsed);
				chara.fightStage(this);
			}
			
			for each (var mob :Enemy in Mobs)
			{
				mob.update(game, elapsed);
				mob.fight(this);
			}
			
			TheBoss.fight(this);
		}
		
		override public function succeeded() :Boolean
		{
			return TheBoss && TheBoss.isDead();
		}

		public function spawnBoss(game :Game) :void
		{
			TheBoss = new Boss();
			TheBoss.roll(game.DifficultyTier);
			Mobs.push(TheBoss);
		}
		
	} // class

} // package
