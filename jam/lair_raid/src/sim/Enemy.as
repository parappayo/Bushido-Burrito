package sim 
{
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	import sim.Character;
	
	public class Enemy 
	{
		// core stats
		public var Name :String;
		public var HP :int;
		public var Might :int;
		public var Vitality :int;
		public var Focus :int;
		public function get MaxHP() :int
		{
			return Vitality * 10;
		}
		public var RewardXP :int;

		// managed by TrashMobsScreen
		public var Graphic :DisplayObject;
		public var DamageText :TextField;
		
		public var TurnTimer :Number;

		public function Enemy() 
		{
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			if (isDead())
			{
				// prevent weird condition of dying with a zero timer
				TurnTimer = 1;
				
				if (Graphic) { Graphic.visible = false; }
				if (DamageText) { DamageText.visible = false; }
				
				return;
			}
			TurnTimer -= elapsed;
			
			if (DamageText && DamageText.alpha > 0)
			{
				DamageText.alpha -= Math.min(0.8 * elapsed, DamageText.alpha);
			}
		}
		
		public function get PositionX() :int
		{
			if (Graphic) { return Graphic.x + Graphic.width / 2; }
			return 0;
		}
		
		public function get PositionY() :int
		{
			if (Graphic) { return Graphic.y + Graphic.height / 2; }
			return 0;
		}
		
		public function isDead() :Boolean
		{
			return HP < 1;
		}
		
		public function applyDamage(damage :int) :void
		{
			HP -= damage;
			
			if (Settings.GodMode)
			{
				HP = 0;
			}
			
			if (DamageText)
			{
				DamageText.text = damage.toString();
				DamageText.alpha = 1;
			}
		}
		
		public function roll(tier :int) :void
		{
			var multiplier :int = tier - MonsterDatabase.TrashMobs.length + 1;
			if (multiplier < 1) { multiplier = 1; }
			multiplier += Math.random() / 2;
			
			tier = Math.min(MonsterDatabase.TrashMobs.length-1, tier);

			Name = MonsterDatabase.TrashMobs[tier].Name;
			Might = MonsterDatabase.TrashMobs[tier].Might * multiplier;
			Vitality = MonsterDatabase.TrashMobs[tier].Vitality * multiplier;
			Focus = MonsterDatabase.TrashMobs[tier].Focus;
			RewardXP = MonsterDatabase.TrashMobs[tier].RewardXP * multiplier;
			
			HP = MaxHP;
			
			rollTurnCooldown();
		}
		
		public function rollTurnCooldown() :void
		{
			const MaxInitiative :Number = 60;
			var initiative :Number = Focus + Dice.rolld8();
			
			initiative = Math.min(initiative, MaxInitiative);
			TurnTimer = ((MaxInitiative - initiative) / MaxInitiative) * 2 * Character.TurnLength + 1;
		}
		
		public function fight(stage :SimStage) :void
		{
			if (TurnTimer > 0) { return; }
			rollTurnCooldown();

			var target :Character = stage.getRandomPartyMember();
			if (!target) { return; }
			
			// TODO: different attacks for different enemy types
			target.applyDamage(Might * 2 + Dice.rolld8());
		}
		
	} // class

} // package
