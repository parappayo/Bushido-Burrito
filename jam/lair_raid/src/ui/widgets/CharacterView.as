package ui.widgets 
{
	import feathers.core.*;
	import feathers.data.*;
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	
	import starling.display.Quad;
	import starling.text.TextField;

	import sim.Character;
	
	public class CharacterView extends FeathersControl
	{
		protected var _turnTimer :ProgressBar;
		protected var _name :TextField;
		protected var _hp :TextField;
		protected var _dps :TextField;
		
		public function CharacterView() 
		{
			// note: starting with width, height of 0, 0 causes bad stuff later
			_turnTimer = new ProgressBar();
			_turnTimer.minimum = 0;
			addChild(_turnTimer);
			
			_name = new TextField(1, 1, "", "theme_font", 16, 0x000000);
			_name.hAlign = "left";
			addChild(_name);
			
			_hp = new TextField(1, 1, "", "theme_font", 16, 0x000000);
			_hp.hAlign = "left";
			addChild(_hp);
			
			_dps = new TextField(1, 1, "", "theme_font", 16, 0x000000);
			_dps.hAlign = "left";
			addChild(_dps);
		}
		
		public function populate(chara :Character) :void
		{
			_name.text = chara.Name;
			HP = 0;
			DPS = 0;
		}
		
		public function updateData(chara :Character) :void
		{
			HP = chara.HP;
			DPS = chara.getLastTurnDPS();
			setTurnTimer(chara.TurnTimer, chara.ThisTurnLength);
		}
		
		// until I figure out a proper lib feathers way to do it
		public function refreshLayout() :void
		{
			var x :int = 0;
			const padding :int = 6;
			
			_turnTimer.width = width / 3;
			_turnTimer.height = height;
			
			_name.width = (width / 3) - padding;
			_name.height = height;
			_name.x = padding;
			x += width / 3;
			
			_hp.width = (width / 3) - padding;
			_hp.height = height;
			_hp.x = x + padding;
			x += width / 3;
			
			_dps.width = (width / 3) - padding;
			_dps.height = height;
			_dps.x = x + padding;
			x += width / 3;
		}
		
		protected function setTurnTimer(currentTime :Number, turnLengthTime :Number) :void
		{
			_turnTimer.maximum = turnLengthTime;
			_turnTimer.value = currentTime;
		}
		
		private function set DPS(dps :Number) :void
		{
			_dps.text = "DPS: " + dps.toFixed(1);
		}
		
		private function set HP(hp :int) :void
		{
			if (hp < 1)
			{
				_hp.text = "KO";
			}
			else
			{
				_hp.text = "HP: " + hp.toString();
			}
		}
		
	} // class

} // package
