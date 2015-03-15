package
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets 
	{
		[Embed(source="../assets/monsters/monsters.png")]
		private static var MonstersPNG :Class;
		[Embed(source="../assets/monsters/monsters.xml", mimeType="application/octet-stream")]
		private static var MonstersXML :Class;
		
		public static var Monsters :TextureAtlas;
		
		static public function init() :void
		{
			Monsters = new TextureAtlas(Texture.fromBitmap(new MonstersPNG), XML(new MonstersXML()));
		}
		
	} // class

} // package
