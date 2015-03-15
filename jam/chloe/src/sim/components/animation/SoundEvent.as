package sim.components.animation 
{	
	public class SoundEvent 
	{
		private var _sounds:Array;
		private var _time:Number;
		private var _timer:Number;
		
		public function SoundEvent(sounds:Array, time:Number) 
		{
			_sounds = sounds;
			_time = time;
			_timer = 0;
		}
		
		public function update(elapsed:Number):void
		{
			if (_timer > _time)
			{
				SoundPlayer.playRandom(_sounds, Settings.VolumeSfx);
				_timer = 0;
			}
			else
			{
				_timer += elapsed;
			}
		}
	}
}