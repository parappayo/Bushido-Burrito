package sim 
{
	public class TrashMobsStage extends SimStage
	{
		public function TrashMobsStage() 
		{
			
		}
		
		public override function start(game :Game) :void
		{
			super.start(game);
			
			Party = game.Recruit.Party;
			spawnMobs(game, Settings.TrashMobCount + Math.random() * Settings.TrashMobRandomCount);
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
		}
		
		override public function succeeded() :Boolean
		{
			for each (var mob :Enemy in Mobs)
			{
				if (!mob.isDead()) { return false; }
			}
			return true;
		}
		
	} // class

} // package
