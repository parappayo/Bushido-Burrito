
package  
{
	import flash.desktop.NotificationType;
	public class Settings 
	{
		// set to false for release builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;
		
		public static const ScreenWidth :Number = 1280;
		public static const ScreenHeight :Number = 720;
		public static var ScreenScaleX :Number = 1;
		public static var ScreenScaleY :Number = 1;
		
		public static const TileWidth :Number = 32;
		public static const TileHeight :Number = 32;
		
		public static const SpriteFramerate :Number = 10;
		
		public static const MusicVolume :Number = 1.0;
		
		public static const DefaultFont :String = "ComicNeue";
		public static const FontSize :int = 22;

		//public static const StartingLevel :Class = Assets.sandboxLevel;
		public static const StartingLevel :Class = Assets.level1;
		
		// TODO: implement proper localization
		public static const PauseCaption :String = "Paused";
		public static const AcceptButton :String = "Enter";

		public static const TitleCaption :String = "Lair Raid 2: Battle in the Deep Dark";

		public static const HelpCaption :String = (<![CDATA[
Controls
Click dwarves to select, click again to move or to attack
Spacebar: End turn
G: Toggle grid
]]> ).toString();
		
		public static const IntroCaption :String = (<![CDATA[
After a century of peace, the evil necromancer Zraxrymar Niblick the Third emerges from the depths leading an army of cultist warriors.

He offers the following message for the inhabitants of the Majestic Mountains:
	
"Make peace with your creator! Your blood will power my conquest of the world!"

Zraxrymar will not negotiate terms.

You must command the dwarven defenders to repel his attack.
]]> ).toString();

		public static const EpilogueCaption :String = (<![CDATA[
The dwarves under your command stand victorious as the last of Zraxrymar's cultists crumples to the stone floor.

If only the mad fool's ambition had not overwhelmed him, this senseless bloodshed could have been avoided.

Tonight we raise a flagon of ale, and drink to the hope of another peaceful century under the Majestic Mountains.
]]> ).toString();

		public static const CreditsCaption :String = (<![CDATA[
Game by Jason Estey for Ludum Dare 29
http://www.ludumdare.com/compo/ludum-dare-29/

Artwork by Buch used under Creative Commons license terms
http://blog-buch.rhcloud.com
http://opengameart.org/content/dungeon-tileset
	
Musical score by Steven O'Brien used under Creative Commons license terms
https://soundcloud.com/stevenobrien/solemn-choral-piece-no-2-2010
https://soundcloud.com/stevenobrien/epic-theme-no-4
https://soundcloud.com/stevenobrien/epic-orchestral-piece
https://soundcloud.com/stevenobrien/majestic-epic-orchestral-piece
]]> ).toString();

	} // class

} // package

