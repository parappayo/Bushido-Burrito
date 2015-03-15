package  
{
	import flash.media.Sound;
	import flash.media.SoundTransform;	
	import flash.media.SoundChannel;		
	
	public class Audio 
	{
		//AUDIO
		[Embed(source="../assets/Audio/unf_mus_gameplay_but_hmmm.mp3")]
		private static var splashMusicSound:Class;
		private static var splashMusic:Sound;		
		public static var splashMusicChannel:SoundChannel;
		
		[Embed(source="../assets/Audio/unf_sfx_amb_drone_loop.mp3")]
		private static var droneLoopSound:Class;
		private static var droneLoop:Sound;		
		public static var droneLoopChannel:SoundChannel;
		
		[Embed(source="../assets/Audio/unf_sfx_fireplace_loop.mp3")]
		private static var fireplaceLoopSound:Class;
		private static var fireplaceLoop:Sound;		
		public static var fireplaceLoopChannel:SoundChannel;
		
		[Embed(source="../assets/Audio/unf_sfx_fire_blast.mp3")]
		private static var fireBlastSound:Class;
		public static var fireBlast:Sound;
	
		[Embed(source="../assets/Audio/unf_sfx_dialogue_popup.mp3")]
		private static var txtPopupSound:Class;
		public static var txtPopup:Sound;				
		
		[Embed(source="../assets/Audio/unf_sfx_amb_babyA_1.mp3")]
		private static var babyA1Sound:Class;
		public static var babyA1:Sound;		
		[Embed(source="../assets/Audio/unf_sfx_amb_babyA_2.mp3")]
		private static var babyA2Sound:Class;
		public static var babyA2:Sound;	
		[Embed(source="../assets/Audio/unf_sfx_amb_babyA_3.mp3")]
		private static var babyA3Sound:Class;
		public static var babyA3:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_babyB_1.mp3")]
		private static var babyB1Sound:Class;
		public static var babyB1:Sound;	
		[Embed(source="../assets/Audio/unf_sfx_amb_babyB_2.mp3")]
		private static var babyB2Sound:Class;
		public static var babyB2:Sound;	
		[Embed(source="../assets/Audio/unf_sfx_amb_babyB_3.mp3")]
		private static var babyB3Sound:Class;
		public static var babyB3:Sound;	

		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_1.mp3")]
		private static var ghostSound1:Class;
		public static var ghost1:Sound;				
		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_2.mp3")]
		private static var ghostSound2:Class;
		public static var ghost2:Sound;			
		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_3.mp3")]
		private static var ghostSound3:Class;
		public static var ghost3:Sound;			
		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_4.mp3")]
		private static var ghostSound4:Class;
		public static var ghost4:Sound;	
		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_5.mp3")]
		private static var ghostSound5:Class;
		public static var ghost5:Sound;			
		[Embed(source="../assets/Audio/unf_sfx_amb_phantom_6.mp3")]
		private static var ghostSound6:Class;
		public static var ghost6:Sound;
		
		[Embed(source="../assets/Audio/unf_sfx_phantom_death_1.mp3")]
		private static var deathSound1:Class;
		public static var death1:Sound;				
		[Embed(source="../assets/Audio/unf_sfx_phantom_death_2.mp3")]
		private static var deathSound2:Class;
		public static var death2:Sound;			
		[Embed(source="../assets/Audio/unf_sfx_phantom_death_3.mp3")]
		private static var deathSound3:Class;
		public static var death3:Sound;			
		[Embed(source="../assets/Audio/unf_sfx_phantom_death_4.mp3")]
		private static var deathSound4:Class;
		public static var death4:Sound;	
		[Embed(source="../assets/Audio/unf_sfx_phantom_death_5.mp3")]
		private static var deathSound5:Class;
		public static var death5:Sound;
		
		[Embed(source="../assets/Audio/unf_sfx_amb_creakC_1.mp3")]
		private static var scarySound1:Class;
		public static var scary1:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_creakB_2.mp3")]
		private static var scarySound2:Class;
		public static var scary2:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_creakA_3.mp3")]
		private static var scarySound3:Class;
		public static var scary3:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_creakA_2.mp3")]
		private static var scarySound4:Class;
		public static var scary4:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_mumbles_1.mp3")]
		private static var scarySound5:Class;
		public static var scary5:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_mumbles_4.mp3")]
		private static var scarySound6:Class;
		public static var scary6:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_wind_1.mp3")]
		private static var scarySound7:Class;
		public static var scary7:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_wind_2.mp3")]
		private static var scarySound8:Class;
		public static var scary8:Sound;
		[Embed(source="../assets/Audio/unf_sfx_amb_wind_3.mp3")]
		private static var scarySound9:Class;
		public static var scary9:Sound;
		
		public static var babySoundList:Array;
		public static var ghostSoundList:Array;
		public static var deathSoundList:Array;
		public static var scarySoundList:Array;
		
		public static function init():void
		{
			splashMusic = new splashMusicSound();
			splashMusicChannel = splashMusic.play(0, 999, new SoundTransform(0.4));
			
			droneLoop = new droneLoopSound();
			droneLoopChannel = droneLoop.play(0, 999, new SoundTransform(1.3));
			
			fireplaceLoop = new fireplaceLoopSound();
			fireplaceLoopChannel = fireplaceLoop.play(0, 999, new SoundTransform(0));
			
			fireBlast = create(fireBlastSound);
			txtPopup = create(txtPopupSound);
			
			babyA1 = create(babyA1Sound);
			babyA2 = create(babyA2Sound);
			babyA3 = create(babyA3Sound);
			babyB1 = create(babyB1Sound);
			babyB2 = create(babyB2Sound);
			babyB3 = create(babyB3Sound);
			babySoundList = new Array(babyA1, babyA2, babyA3, babyB1, babyB2, babyB3);
			
			ghost1 = create(ghostSound1);
			ghost2 = create(ghostSound2);
			ghost3 = create(ghostSound3);
			ghost4 = create(ghostSound4);
			ghost5 = create(ghostSound5);
			ghost6 = create(ghostSound6);
			ghostSoundList = new Array(ghost1, ghost2, ghost3, ghost4, ghost5, ghost6);
			
			death1 = create(deathSound1);
			death2 = create(deathSound2);
			death3 = create(deathSound3);
			death4 = create(deathSound4);
			death5 = create(deathSound5);
			deathSoundList = new Array(death1, death2, death3, death4, death5);
			
			scary1 = create(scarySound1);
			scary2 = create(scarySound2);
			scary3 = create(scarySound3);
			scary4 = create(scarySound4);
			scary5 = create(scarySound5);
			scary6 = create(scarySound6);
			scary7 = create(scarySound7);
			scary8 = create(scarySound8);
			scary9 = create(scarySound9);		
			scarySoundList = new Array(scary1, scary2, scary3, scary4, scary5, scary6, scary7, scary8, scary9);			
		}
		
		private static function create(soundClass:Class):Sound
		{
			var sound:Sound = new soundClass();
			sound.play(0, 0, new SoundTransform(0));
			return sound;
		}
	}
}