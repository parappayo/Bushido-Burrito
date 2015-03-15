
package  
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.text.Font;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		// levels
		[Embed(source="../assets/ogmo/sandbox.oel", mimeType="application/octet-stream")]
		public static const sandboxLevel :Class;
		[Embed(source="../assets/ogmo/level1.oel", mimeType="application/octet-stream")]
		public static const level1 :Class;
		[Embed(source="../assets/ogmo/level2.oel", mimeType="application/octet-stream")]
		public static const level2 :Class;
		[Embed(source="../assets/ogmo/level3.oel", mimeType="application/octet-stream")]
		public static const level3 :Class;
		
		// musical score tracks
		[Embed(source = "../assets/music/epic4.mp3")]
		private static var BattleMusicClass :Class;
		public static var BattleMusic :Sound;
		[Embed(source = "../assets/music/60-epic-orchestral-piece.mp3")]
		private static var BattleMusicClass2 :Class;
		public static var BattleMusic2 :Sound;
		[Embed(source = "../assets/music/majesticepicorchestralpiece.mp3")]
		private static var BattleMusicClass3 :Class;
		public static var BattleMusic3 :Sound;
		[Embed(source = "../assets/music/Unmerciful Gods.mp3")]
		private static var AmbientMusicClass :Class;
		public static var AmbientMusic :Sound;
		
		// ui screens
		[Embed(source="../assets/screens/Legal.png")]
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

		[Embed(source="../assets/atlases/tiles.png")]
		private static var TilesImg :Class;
		[Embed(source="../assets/atlases/tiles.xml", mimeType="application/octet-stream")]
		private static var TilesXML :Class;
		public static var TilesAtlas :TextureAtlas;

		[Embed(source="../assets/atlases/entities.png")]
		private static var EntitiesImg :Class;
		[Embed(source="../assets/atlases/entities.xml", mimeType="application/octet-stream")]
		private static var EntitiesXML :Class;
		public static var EntitiesAtlas :TextureAtlas;
		
		[Embed(source = "../assets/fonts/ComicNeue-Angular-Regular.ttf",
			fontName = "ComicNeue",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]
		public static const FontComicNeue :Class;
 
		public static var BodyFont :Font;

		static public function init() :void
		{
			BattleMusic = createSound(BattleMusicClass);
			BattleMusic2 = createSound(BattleMusicClass2);
			BattleMusic3 = createSound(BattleMusicClass3);
			AmbientMusic = createSound(AmbientMusicClass);
			
			LegalScreenTexture = Texture.fromBitmap(new LegalScreenImg());
			TitleScreenTexture = Texture.fromBitmap(new TitleScreenImg());
			GameOverScreenTexture = Texture.fromBitmap(new GameOverScreenImg());
			CreditsScreenTexture = Texture.fromBitmap(new CreditsScreenImg());
			VictoryScreenTexture = Texture.fromBitmap(new VictoryScreenImg());
			DialogueScreenTexture = Texture.fromBitmap(new DialogueScreenImg());
			LoadingScreenTexture = Texture.fromBitmap(new LoadingScreenImg());
			
			TilesAtlas = new TextureAtlas(Texture.fromBitmap(new TilesImg), XML(new TilesXML()));
			EntitiesAtlas = new TextureAtlas(Texture.fromBitmap(new EntitiesImg), XML(new EntitiesXML()));
			
			BodyFont = new FontComicNeue();
		}
		
		private static function createSound(soundClass :Class) :Sound
		{
			var sound :Sound = new soundClass();
			sound.play(0, 0, new SoundTransform(0));
			return sound;
		}
		
	} // class

} // package

