package sim.actors 
{
	import sim.WorldPosition;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import resources.Atlases;
	
	public class Effect extends SpriteActor
	{	
		private var _particles:PDParticleSystem;
		
		public function Effect(xml:Class, texture:String, posX:Number, posY:Number, duration:Number = 0) 
		{
			_particles = new PDParticleSystem(XML(new xml), Atlases.ParticlesTextures.getTexture(texture));
			_particles.emitterX = posX;
			_particles.emitterY = posY;
			Starling.juggler.add(_particles);
			addChild(_particles);
			if (duration > 0)
			{
				_particles.start(duration);
				addEventListener(Event.COMPLETE, onComplete);
			}
			else
			{
				_particles.start();
			}
		}
		
		public function stop():void
		{
			Starling.juggler.remove(_particles);
			_particles.removeFromParent(true);
		}
		
		private function onComplete(event:Event):void
		{
			var e:Effect = event.currentTarget as Effect;
			e.stop();
		}
	}
}