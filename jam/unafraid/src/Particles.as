package  
{
	public class Particles 
	{
		[Embed(source="../assets/Particles/campfire.pex", mimeType="application/octet-stream")]
		public static var CampfireXML:Class;
		
		[Embed(source="../assets/Particles/explosion.pex", mimeType="application/octet-stream")]
		public static var ExplosionXML:Class;
		
		public static function init():void
		{
		}
	}
}