
package  
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		// levels
		[Embed(source="../assets/ogmo/sandbox.oel", mimeType="application/octet-stream")]
		public static const sandboxLevel :Class;
		[Embed(source="../assets/ogmo/waterfront.oel", mimeType="application/octet-stream")]
		public static const waterfront :Class;
		[Embed(source="../assets/ogmo/gastown.oel", mimeType="application/octet-stream")]
		public static const gastown :Class;
		
		// ui screens
		[Embed(source="../assets/screens/cyberjam_splash.png")]
		private static const LegalScreenImg :Class;
		public static var LegalScreenTexture :Texture;
		[Embed(source="../assets/screens/Title.png")]
		private static const TitleScreenImg :Class;
		public static var TitleScreenTexture :Texture;
		[Embed(source="../assets/screens/GameOver.png")]
		private static const GameOverScreenImg :Class;
		public static var GameOverScreenTexture :Texture;
		[Embed(source="../assets/screens/Credits.png")]
		private static const CreditsScreenImg :Class;
		public static var CreditsScreenTexture :Texture;
		[Embed(source="../assets/screens/Victory.png")]
		private static const VictoryScreenImg :Class;
		public static var VictoryScreenTexture :Texture;
		[Embed(source="../assets/screens/Dialog.png")]
		private static const DialogueScreenImg :Class;
		public static var DialogueScreenTexture :Texture;
		[Embed(source="../assets/screens/Loading.png")]
		private static const LoadingScreenImg :Class;
		public static var LoadingScreenTexture :Texture;
		
		[Embed(source="../assets/atlases/Tiles.png")]
		private static var TilesImg :Class;
		[Embed(source="../assets/atlases/Tiles.xml", mimeType="application/octet-stream")]
		private static var TilesXML :Class;
		public static var TilesAtlas :TextureAtlas;

		[Embed(source="../assets/atlases/Entities.png")]
		private static var EntitiesImg :Class;
		[Embed(source="../assets/atlases/Entities.xml", mimeType="application/octet-stream")]
		private static var EntitiesXML :Class;
		public static var EntitiesAtlas :TextureAtlas;

		[Embed(source="../assets/Fonts/pf_ronda_seven.png")]
		private static var RondaSevenPNG:Class;
		[Embed(source="../assets/Fonts/pf_ronda_seven.fnt", mimeType="application/octet-stream")]
		private static var RondaSevenFNT:Class;

		static public function init() :void
		{
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());
			
			TilesAtlas = new TextureAtlas(Texture.fromBitmap(new TilesImg), XML(new TilesXML()));
			EntitiesAtlas = new TextureAtlas(Texture.fromBitmap(new EntitiesImg), XML(new EntitiesXML()));
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new RondaSevenPNG()), XML(new RondaSevenFNT())), "ronda_seven");
		}
		
	} // class

} // package

