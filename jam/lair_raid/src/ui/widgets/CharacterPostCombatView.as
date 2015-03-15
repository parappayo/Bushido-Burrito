package ui.widgets 
{
	import sim.Character;
	
	public class CharacterPostCombatView extends CharacterView
	{
		override public function populate(chara :Character) :void
		{
			_turnTimer.visible = false;
			_name.text = chara.Name;
			_dps.text = "";
			_hp.text = "";
		}
		
		override public function updateData(chara :Character) :void
		{
			FinalDamage = chara.CombatDamageTotal;
			FinalHealing = chara.CombatHealingTotal;
		}

		private function set FinalDamage(damage :int) :void
		{
			_dps.text = "Dmg: " + damage.toString();
		}
		
		private function set FinalHealing(healing :int) :void
		{
			_hp.text = "Heal: " + healing.toString();
		}
		
	} // class

} // package
