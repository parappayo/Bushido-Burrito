
package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundPlayer 
	{
		public static var _musicChannel :SoundChannel;
		public static var _currentMusicTrack :Sound;
		
		public static function playMusic(track :Sound) :void
		{
			if (_currentMusicTrack == track) { return; }
			_currentMusicTrack = track;
			
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
			_musicChannel = track.play(0, 20000, new SoundTransform(Settings.MusicVolume));
		}
		
		public static function stopMusic() :void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
		}
		
	} // class
	
} // package
