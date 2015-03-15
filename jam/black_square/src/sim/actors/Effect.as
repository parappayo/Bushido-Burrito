package sim.actors 
{
	import sim.WorldPosition;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	
	public class Effect extends SpriteActor
	{	
		private var _particles:PDParticleSystem;
		private var _done:Boolean;
		
		public function Effect(xml:Class, texture:String, posX:Number, posY:Number, duration:Number = 0) 
		{
			_particles = new PDParticleSystem(XML(new xml), Assets.ElementsTextures.getTexture(texture));
			_particles.emitterX = posX;
			_particles.emitterY = posY;
			Starling.juggler.add(_particles);
			addChild(_particles);
			_done = false;
			if (duration > 0)
			{
				_particles.start(duration);
				_particles.addEventListener(Event.COMPLETE, onComplete);
			}
			else
			{
				_particles.start();
			}
		}
		
		public function isDone():Boolean
		{
			return _done;
		}
		
		public function stop():void
		{
			Starling.juggler.remove(_particles);
			_particles.removeFromParent(true);
			_done = true;
		}
		
		private function onComplete(event:Event):void
		{
			var p:PDParticleSystem = event.currentTarget as PDParticleSystem;
			var e:Effect = p.parent as Effect;
			e.stop();
		}
	}
}