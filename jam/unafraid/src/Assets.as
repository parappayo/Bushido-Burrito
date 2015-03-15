package  
{
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets 
	{
		[Embed(source="../assets/Textures/SplashScreen.png")]
		private static const SplashScreenImg:Class;
		public static var SplashScreenTexture:Texture;
		
		[Embed(source="../assets/FogMask.png")]
		private static const FogMaskImg:Class;
		public static var FogMaskTexture:Texture;
		
		[Embed(source="../assets/Atlas.png")]
		private static var Atlas:Class;
		public static var TA:TextureAtlas;
		[Embed(source="../assets/Atlas.xml", mimeType="application/octet-stream")]
		private static var AtlasXML:Class;
		
		[Embed(source="../assets/Fonts/FunDead.png")]
		private static var FunDead:Class;
		[Embed(source="../assets/Fonts/FunDead.fnt", mimeType="application/octet-stream")]
		private static var FunDeadXML:Class;
		
		[Embed(source="../ogmo/levels/Level1.oel", mimeType="application/octet-stream")]
		//[Embed(source="../ogmo/levels/Sandbox.oel", mimeType="application/octet-stream")]
		public static const LevelXML:Class;
		public static const TileW:Number = 64;
		public static const TileH:Number = 64;
		
		public static function init():void
		{
			SplashScreenTexture = Texture.fromBitmap(new SplashScreenImg());
			FogMaskTexture = Texture.fromBitmap(new FogMaskImg());
			TA = new TextureAtlas(Texture.fromBitmap(new Atlas), XML(new AtlasXML()));
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new FunDead()), XML(new FunDeadXML())), "FunDead");
		}
	}
}
