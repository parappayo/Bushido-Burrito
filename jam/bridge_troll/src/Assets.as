
package  
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		[Embed(source="../assets/atlases/Entities.png")]
		private static var EntitiesImg :Class;
		[Embed(source="../assets/atlases/Entities.xml", mimeType="application/octet-stream")]
		private static var EntitiesXML :Class;
		public static var EntitiesAtlas :TextureAtlas;

		[Embed(source = "../assets/fonts/pcsenior.ttf",
			fontName = "pcsenior",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]
		public static const FontVGA437 :Class;
 
		[Embed(source="../assets/textures/bridge.png")]
		private static const BackgroundImg :Class;
		public static var BackgroundTexture :Texture;
		[Embed(source="../assets/textures/bridge_foreground.png")]
		private static const ForegroundImg :Class;
		public static var ForegroundTexture :Texture;

		// ui screens
		[Embed(source="../assets/screens/dialog.png")]
		private static const LegalScreenImg :Class;
		public static var LegalScreenTexture :Texture;
		[Embed(source="../assets/screens/title.png")]
		private static const TitleScreenImg :Class;
		public static var TitleScreenTexture :Texture;
		[Embed(source="../assets/screens/dialog.png")]
		private static const GameOverScreenImg :Class;
		public static var GameOverScreenTexture :Texture;
		[Embed(source="../assets/screens/dialog.png")]
		private static const CreditsScreenImg :Class;
		public static var CreditsScreenTexture :Texture;
		[Embed(source="../assets/screens/dialog.png")]
		private static const VictoryScreenImg :Class;
		public static var VictoryScreenTexture :Texture;
		[Embed(source="../assets/screens/dialog.png")]
		private static const DialogueScreenImg :Class;
		public static var DialogueScreenTexture :Texture;
		[Embed(source="../assets/screens/dialog.png")]
		private static const LoadingScreenImg :Class;
		public static var LoadingScreenTexture :Texture;

		static public function init() :void
		{
			EntitiesAtlas = new TextureAtlas(Texture.fromBitmap(new EntitiesImg), XML(new EntitiesXML()));

			BackgroundTexture = Texture.fromBitmap(new BackgroundImg());
			ForegroundTexture = Texture.fromBitmap(new ForegroundImg());
			
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());
		}
		
	} // class

} // package

