package sim 
{
	import wyverntail.core.Component;
	
	public class TimeOfDay extends Component
	{
		// cyberpunk 2014 rules: time of day starts at 48 hours and counts back,
		// 2 sec real time = 1 minute game time
		private var _minutesLeft :Number;
		private var _elapsed :Number;
		
		public function get minutesLeft() :Number { return _minutesLeft; }
		
		public function TimeOfDay() 
		{
			
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_minutesLeft = 60 * 48;
			_elapsed = 0;
		}
		
		
		override public function update(elapsed :Number) :void
		{
			_elapsed += elapsed;
			while (_elapsed > 2.0)
			{
				_elapsed -= 2.0;
				_minutesLeft -= 1.0;
			}
		}
		
	} // class

} // package
