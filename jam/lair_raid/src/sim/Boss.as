package sim 
{
	public class Boss extends Enemy
	{
		
		public function Boss() 
		{
			
		}
		
		override public function roll(tier :int) :void
		{
			var multiplier :int = tier - MonsterDatabase.TrashMobs.length + 1;
			if (multiplier < 1) { multiplier = 1; }
			tier = Math.min(MonsterDatabase.Bosses.length-1, tier);

			Name = MonsterDatabase.Bosses[tier].Name;
			Might = MonsterDatabase.Bosses[tier].Might * multiplier;
			Vitality = MonsterDatabase.Bosses[tier].Vitality * multiplier;
			Focus = MonsterDatabase.Bosses[tier].Focus;
			RewardXP = MonsterDatabase.Bosses[tier].RewardXP * multiplier;
			
			HP = MaxHP;
		}
		
	} // class

} // package
