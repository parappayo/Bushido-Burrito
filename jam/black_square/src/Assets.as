package  
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 *  Embedded assets go here.
	 */
	public class Assets 
	{
		// OGMO
		[Embed(source="../assets/ogmo/levels/sandbox.oel", mimeType="application/octet-stream")]
		public static const sandbox :Class;
		[Embed(source="../assets/ogmo/levels/Area01_Courtyard.oel", mimeType="application/octet-stream")]
		public static const Area01_Courtyard :Class;
		[Embed(source="../assets/ogmo/levels/Area02_Basement1.oel", mimeType="application/octet-stream")]
		public static const Area02_Basement1 :Class;
		[Embed(source="../assets/ogmo/levels/Area03_Basement2.oel", mimeType="application/octet-stream")]
		public static const Area03_Basement2 :Class;
		[Embed(source="../assets/ogmo/levels/Area04_Armory.oel", mimeType="application/octet-stream")]
		public static const Area04_Armory :Class;
		[Embed(source="../assets/ogmo/levels/Area05_Corridor.oel", mimeType="application/octet-stream")]
		public static const Area05_Corridor :Class;
		[Embed(source="../assets/ogmo/levels/Area06_Barracks.oel", mimeType="application/octet-stream")]
		public static const Area06_Barracks :Class;
		[Embed(source="../assets/ogmo/levels/Area07_Vault.oel", mimeType="application/octet-stream")]
		public static const Area07_Vault :Class;
		[Embed(source="../assets/ogmo/levels/Area08_Garage.oel", mimeType="application/octet-stream")]
		public static const Area08_Garage :Class;
		[Embed(source="../assets/ogmo/levels/Area09_Breakroom.oel", mimeType="application/octet-stream")]
		public static const Area09_Breakroom :Class;
		/*[Embed(source="../assets/ogmo/levels/Mission02_Area01_Hilbert.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area01_Hilbert :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area02_Maze.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area02_Maze :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area03_Barracks.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area03_Barracks :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area04_Bricks.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area04_Bricks :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area05_Rooms.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area05_Rooms :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area06_Puzzle.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area06_Puzzle :Class;
		[Embed(source="../assets/ogmo/levels/Mission02_Area07_Vault.oel", mimeType="application/octet-stream")]
		public static const Mission02_Area07_Vault :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area01.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area01 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area02.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area02 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area03.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area03 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area04.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area04 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area05.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area05 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area06.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area06 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area07.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area07 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area08.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area08 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area09.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area09 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area10.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area10 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area11.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area11 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area12.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area12 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area13.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area13 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area14.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area14 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area15.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area15 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area16.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area16 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area17.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area17 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area18.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area18 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area19.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area19 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area20.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area20 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area21.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area21 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area22.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area22 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area23.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area23 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area24.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area24 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area25.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area25 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area26.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area26 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area27.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area27 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area28.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area28 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area29.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area29 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area30.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area30 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area31.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area31 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area32.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area32 :Class;
		[Embed(source="../assets/ogmo/levels/Mission03_Area33.oel", mimeType="application/octet-stream")]
		public static const Mission03_Area33 :Class;*/
		
		// Font
		[Embed(source="../assets/Fonts/blacksquare.png")]
		private static var BlackSquareFont:Class;
		[Embed(source="../assets/Fonts/blacksquare.fnt", mimeType="application/octet-stream")]
		private static var BlackSquareFontXML:Class;
		
		// Elements
		[Embed(source="../assets/Atlases/Elements.png")]
		private static var Elements :Class;
		public static var ElementsTextures :TextureAtlas;
		[Embed(source="../assets/Atlases/Elements.xml", mimeType="application/octet-stream")]
		private static var ElementsXML :Class;
		
		// Tiles
		[Embed(source="../assets/Atlases/Tiles.png")]
		private static var Tiles :Class;
		public static var TilesTextures :TextureAtlas;
		[Embed(source="../assets/Atlases/Tiles.xml", mimeType="application/octet-stream")]
		private static var TilesXML :Class;
		
		// UI
		[Embed(source="../assets/Atlases/UI.png")]
		private static var UiPNG :Class;
		public static var UiTextures :TextureAtlas;
		[Embed(source="../assets/Atlases/UI.xml", mimeType="application/octet-stream")]
		private static var UiXML :Class;
		
		// Screens
		[Embed(source="../assets/Textures/Screens/Legal.png")]
		private static const LegalScreenImg :Class;
		public static var LegalScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Title.png")]
		private static const TitleScreenImg :Class;
		public static var TitleScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/GameOver.png")]
		private static const GameOverScreenImg :Class;
		public static var GameOverScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Gameovercredits.png")]
		private static const CreditsScreenImg :Class;
		public static var CreditsScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Victory.png")]
		private static const VictoryScreenImg :Class;
		public static var VictoryScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/dialogue_popup.png")]
		private static const DialogueScreenImg :Class;
		public static var DialogueScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/loading_popup.png")]
		private static const LoadingScreenImg :Class;
		public static var LoadingScreenTexture :Texture;		
		
		public static function init() :void
		{
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new BlackSquareFont()), XML(new BlackSquareFontXML())), "blacksquare");
			ElementsTextures = new TextureAtlas(Texture.fromBitmap(new Elements), XML(new ElementsXML()));
			TilesTextures = new TextureAtlas(Texture.fromBitmap(new Tiles), XML(new TilesXML()));
			UiTextures = new TextureAtlas(Texture.fromBitmap(new UiPNG), XML(new UiXML()));
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());
			Audio.init();
		}

	} // class

} // package
