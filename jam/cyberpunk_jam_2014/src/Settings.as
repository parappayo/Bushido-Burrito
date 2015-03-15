
package  
{
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = true;
		public static const ShowStats :Boolean = false;
		
		public static const ScreenWidth :Number = 640;
		public static const ScreenHeight :Number = 400;
		public static var ScreenScaleX :Number = 1;
		public static var ScreenScaleY :Number = 1;
		
		public static const SpriteFramerate :Number = 10;
		
		public static const DefaultFont :String = "ronda_seven";
		public static const FontSize :int = 16;
		
		public static const TileWidth :int = 32;
		public static const TileHeight :int = 32;
		
		public static const StartingLevel :Class = Assets.waterfront;

		// screen overlay
//		public static const TintColour :int = 0xffffff;
//		public static const TintAlpha :Number = 0.0;

		// TODO: implement proper localization
		public static const PauseCaption :String = "Paused";
		public static const AcceptButton :String = "Enter";
		
		public static const PlayerStartingCash :Number = 1000;
		
		public static const IntroCaption :String = (<![CDATA[
]]> ).toString();

	} // class

} // package

