package sim.components 
{
	import flash.geom.Point;
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	
	public class Input implements Component 
	{
		private var _locked :Boolean;
		
		public function Input() 
		{
			reset();
		}
		
		public function reset() :void
		{
			_locked = false;
		}
		
		public function lock() :void
		{
			_locked = true;
		}
		
		public function unlock() :void
		{
			_locked = false;
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number) :void
		{
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || _locked || actor.isDead()) { return; }
			
			switch (signal) 
			{
				case Signals.AIM_RELEASE:
					{
						if (game.getPlayer().hasDisc())
						{
							var target :Point = args as Point;
							var throwDirection :WorldOrientation = new WorldOrientation();
							throwDirection.x = target.x - (spriteActor.x + spriteActor.width * 0.5);
							throwDirection.y = target.y - (spriteActor.y + spriteActor.height * 0.5);
							throwDirection.normalize();
							spriteActor.worldOrientationAim = throwDirection;
							actor.handleSignal(game, Signals.ACTION_EXECUTE, Actions.THROW);
						}
					}
					break;
			}
		}
	}
}