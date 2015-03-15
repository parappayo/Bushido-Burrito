package  
{
	public class Settings 
	{
		CONFIG::release
		{
			public static const SkipUI :Boolean = false;
			public static const GodMode :Boolean = false;
			public static const ShowStats :Boolean = false;
			public static const Verbose :Boolean = false;
			public static const LoadSandbox :Boolean = false;
		}
		CONFIG::debug
		{
			public static const SkipUI :Boolean = true;
			public static const GodMode :Boolean = false;
			public static const ShowStats :Boolean = true;
			public static const Verbose :Boolean = true;
			public static const LoadSandbox :Boolean = false;
		}
		
		// for web set to false
		public static const MobileBuild :Boolean = false;
		public static const AcceptButton :String = "ENTER";
		
		// global configuration
		public static const TileW :Number = 64;
		public static const TileH :Number = 64;
		public static const ScreenWidth :Number = 1280;
		public static const ScreenHeight :Number = 720;
		public static const SpriteFramerate :int = 4; // fps
		public static const MazeWidth :int = 12; // in cells
		public static const MazeHeight :int = 10; // in cells
		public static const MaxLevelWidth :int = 360; // in tiles
		public static const MaxLevelHeight :int = 300; // in tiles
		public static const RoomWidth :int = 30;
		public static const RoomHeight :int = 30;
		
		// screen overlay
		public static const TintColour :int = 0x000000;
		public static const TintAlpha :Number = 0;
		
		// audio tuning
		public static const VolumeSfx :Number = 0.3;
		public static const VolumeSfxLoud :Number = 0.4;
		public static const VolumeMusic :Number = 0.3;
		
		// starting points
//		public static const StartingLevels :Array = [
//			"Sandbox"
//		];
		
		// objectives
		public static const MissionIntro1 :String = (<![CDATA[
		]]>).toString();

		// intro text
		public static const MissionIntros :Array = [
			MissionIntro1
		];
	}
} // package
