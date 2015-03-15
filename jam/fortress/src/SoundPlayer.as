package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import resources.Audio;
	
	public class SoundPlayer 
	{
		public static var _musicChannel:SoundChannel;
		public static var _blockGummiAttack:Boolean;
		public static var _blockGummiAttackTimer:Number;		
		public static var _blockGummiDeath:Boolean;
		public static var _blockGummiDeathTimer:Number;
		
		public static function init():void
		{
			_musicChannel = null;
			_blockGummiAttack = false;
			_blockGummiAttackTimer = 0;
			_blockGummiDeath = false;
			_blockGummiDeathTimer = 0;
		}
		
		public static function update(elapsed:Number):void
		{
			if (_blockGummiAttack)
			{
				_blockGummiAttackTimer += elapsed;
				if (_blockGummiAttackTimer > 0.5)
				{
					_blockGummiAttack = false;
					_blockGummiAttackTimer = 0;
				}
			}			
			if (_blockGummiDeath)
			{
				_blockGummiDeathTimer += elapsed;
				if (_blockGummiDeathTimer > 0.5)
				{
					_blockGummiDeath = false;
					_blockGummiDeathTimer = 0;
				}
			}
		}
		
		public static function playMusic():void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
			_musicChannel = playLooping(Audio.Song_Pillow_Theme, Settings.VolumeMusic);
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