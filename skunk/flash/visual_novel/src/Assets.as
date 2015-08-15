package  
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets 
	{
		[Embed(source="../assets/hamlet.xml", mimeType="application/octet-stream")]
		public static var HamletXML :Class;

		[Embed(source="../assets/portraits/Bernardo.png")]
		private static const BernardoImg :Class;
		public static var BernardoTexture :Texture;

		[Embed(source="../assets/portraits/Francisco.png")]
		private static const FranciscoImg :Class;
		public static var FranciscoTexture :Texture;

		static public function init() :void
		{
			BernardoTexture = Texture.fromBitmap(new BernardoImg());
			FranciscoTexture = Texture.fromBitmap(new FranciscoImg());
		}
	}

} // package
