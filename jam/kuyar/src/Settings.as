
package  
{
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;
		
		public static const ScreenWidth :Number = 800;
		public static const ScreenHeight :Number = 720;
		
		public static const SpriteFramerate :Number = 10;
		
		public static const DefaultFont :String = "ronda_seven";
		public static const FontSize :int = 16;
		
		public static const TileWidth :int = 32;
		public static const TileHeight :int = 32;
		
		public static const StartingLevel :Class = Assets.crapton;

		// screen overlay
		public static const TintColour :int = 0x9edc28;
		public static const TintAlpha :Number = 0.2;

		// TODO: implement proper localization
		public static const PauseCaption :String = "Paused";
		public static const AcceptButton :String = "Enter";
		
		public static const IntroCaption :String = (<![CDATA[
Exhausted after your long journey, you stumble into town.

Press [Enter] to continue
]]> ).toString();

	} // class

} // package

