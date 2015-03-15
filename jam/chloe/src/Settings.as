package  
{
	public class Settings 
	{
		// for ship builds, set to false
		public static const SkipUi:Boolean = true;
		public static const GodMode:Boolean = false;
		public static const ShowStats:Boolean = false;
		public static const PlayMusic:Boolean = false;
		
		public static const WalkmeshSize:Number = 32;
		public static const TileSize:Number = 64;
		
		public static const ScreenWidth:Number = 1024;
		public static const ScreenHeight:Number = 576;
		public static const SpriteFramerate:int = 12; // fps
		
		public static const TintColour:int = 0x000000;
		public static const TintAlpha:Number = 0;
		
		public static const VolumeMusic:Number = 0; // 0.2
		public static const VolumeSfx:Number = 0.3;
		public static const VolumeSfxLoud:Number = 0.8;
		
		public static const StartingLevel:String = "Sandbox";
		public static const IntroCaption:String = (<![CDATA[Press [Enter] to begin.]]>).toString();
	}
} // package
