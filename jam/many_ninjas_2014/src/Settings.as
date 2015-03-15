
package  
{
	import feathers.layout.AnchorLayout;
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;
		
		public static const ScreenWidth :Number = 800;
		public static const ScreenHeight :Number = 720;
		public static var ScreenScaleX :Number = 1;
		public static var ScreenScaleY :Number = 1;
		
		public static const TileWidth :Number = 32;
		public static const TileHeight :Number = 32;
		
		public static const SpriteFramerate :Number = 10;
		
		public static const DefaultFont :String = "theme_font";
		public static const FontSize :int = 16;

		//public static const StartingLevel :Class = Assets.testLevel;
		
		// TODO: implement proper localization
		public static const PauseCaption :String = "Paused";
		public static const AcceptButton :String = "Enter";

		public static const SplashCaption :String = (<![CDATA[
Made with FlashDevelop, Starling, and Feathers
http://www.flashdevelop.org/
http://gamua.com/starling/
http://feathersui.com/

Block Ninja sprite by Korba
http://opengameart.org/content/block-ninja-2d-sprites

Find more Incremental Games on Reddit
http://www.reddit.com/r/incremental_games
]]> ).toString();

		public static const IntroCaption :String = (<![CDATA[
It is an age of great abundance. Food grows everywhere.

And yet hungry ninjas roam the countryside, listless and leaderless,
while feudal lords grow fat in their fortresses.
		
You set out on your ambition to found a ninja clan
and change this sorry state of affairs.
]]> ).toString();

	} // class

} // package

