package actors
{	
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class Explosion extends PDParticleSystem
	{
		public function Explosion()
		{
			super(XML(new Particles.ExplosionXML()), Assets.TA.getTexture("explosion"));
		}
		
		public function setColor(color:ColorArgb):void
		{
			this.startColor = color;
			this.endColor = color;
		}
	}
}