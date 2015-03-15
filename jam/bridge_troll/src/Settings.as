
package  
{
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import wyverntail.collision.CellCollider;
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;

		public static const AntiAliasing :Number = 0;

		public static const ScreenWidth :Number = 1280;
		public static const ScreenHeight :Number = 800;
		public static var ScreenScaleX :Number = 1;
		public static var ScreenScaleY :Number = 1;
		
		public static const TileWidth :Number = 32;
		public static const TileHeight :Number = 32;
		
		public static const SpriteFramerate :Number = 4;
		
		public static const DefaultFont :String = "pcsenior";
		public static const FontSize :int = 32;
		
		public static const PunchDistance :Number = 200;

		public static const PauseCaption :String = (<![CDATA[
Paused
Hint: Use the prompt below to type keyboard commands.
]]> ).toString();

		public static const AcceptButton :String = "Enter";

		public static const IntroCaption :String = (<![CDATA[
Unable to find work, you have decided to take up a career as a bridge troll.

Instructions:
Move with arrow keys
Type commands in "verb" "noun" form
]]> ).toString();

		public static const VictoryCaption :String = (<![CDATA[
All at once you realize that working as a bridge troll is no way to go through life.
You embrace one of the passerbys in a showering of brotherly affection before going on your way.
]]> ).toString();

		public static const CreditsCaption :String = (<![CDATA[
Thanks for playing!

Game by Jason Estey for LD31
http://ludumdare.com/

Font is "pcsenior" by codeman38
http://www.zone38.net/font/

Game Engine is Wyvern-Tail
https://code.google.com/
]]> ).toString();

	} // class

} // package

