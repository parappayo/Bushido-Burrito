
package  
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		// ui screens
		[Embed(source="../assets/Textures/Screens/Legal.png")]
		private static const LegalScreenImg :Class;
		public static var LegalScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Title.png")]
		private static const TitleScreenImg :Class;
		public static var TitleScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/GameOver.png")]
		private static const GameOverScreenImg :Class;
		public static var GameOverScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Credits.png")]
		private static const CreditsScreenImg :Class;
		public static var CreditsScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Victory.png")]
		private static const VictoryScreenImg :Class;
		public static var VictoryScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Dialog.png")]
		private static const DialogueScreenImg :Class;
		public static var DialogueScreenTexture :Texture;
		[Embed(source="../assets/Textures/Screens/Loading.png")]
		private static const LoadingScreenImg :Class;
		public static var LoadingScreenTexture :Texture;
		
		// texture atlas
		[Embed(source="../assets/atlases/sprites.png")]
		private static var SpritesPNG :Class;
		[Embed(source="../assets/atlases/sprites.xml", mimeType="application/octet-stream")]
		private static var SpritesXML :Class;
		public static var Sprites :TextureAtlas;

		static public function init() :void
		{
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());
			
			Sprites = new TextureAtlas(Texture.fromBitmap(new SpritesPNG), XML(new SpritesXML()));
		}
		
	} // class

} // package

