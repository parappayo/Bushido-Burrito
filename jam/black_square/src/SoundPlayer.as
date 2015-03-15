package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundPlayer 
	{
		public static var _musicChannel:SoundChannel;
		
		public static function init():void
		{
			_musicChannel = null;
		}
		
		public static function playMusic():void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
			_musicChannel = playLooping(Audio.mx1Music, Audio.VOLUME_MUSIC);
		}
		
		public static function stopMusic():void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
		}
		
		public static function play(sound:Sound, volume:Number):SoundChannel
		{
			return sound.play(0, 0, new SoundTransform(volume));
		}
		
		public static function playLooping(sound:Sound, volume:Number):SoundChannel
		{
			return sound.play(0, 999, new SoundTransform(volume));
		}
		
		public static function playRandom(sounds:Array, volume:Number):SoundChannel
		{
			const index:uint = Math.min(Math.random() * (sounds.length), (sounds.length - 1));
			const volumeDir:Number = (Math.random() > 0.5) ? 1 : -1;
			volume += volumeDir * Math.random() * volume * 0.1;
			var sound:Sound = sounds[index] as Sound;
			if (sound == null) new Assert("Invalid entry in sounds array. Make sure all values are of type 'Sound'");
			return play(sound, volume);
		}
	}
}