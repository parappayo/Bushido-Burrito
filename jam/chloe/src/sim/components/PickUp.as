package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.Prop;
	import sim.actors.SpriteActor;
	import sim.components.action.Actions;
	public class PickUp implements Component 
	{
		private var _radius:Number;
		private var _prop:Prop;
		
		public function PickUp(radius:Number) 
		{
			_radius = radius;
			reset();
		}
		
		public function reset():void
		{
			_prop = null;
		}
		
		public function hasProp():Boolean
		{
			return (_prop != null);
		}
		
		public function update(game:Game, actor:Actor, elapsed:Number):void 
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || spriteActor.isDead()) return;
			
			if (_prop != null)
			{
				var x:Number = 0;
				if (spriteActor.worldOrientationTarget.x < 0)
				{
					x = spriteActor.getWorldInteract().x - _prop.getInteractOffsetX() - _prop.width;
				}
				else if (spriteActor.worldOrientationTarget.x > 0)
				{
					x = spriteActor.getWorldInteract().x + _prop.getInteractOffsetX();
				}
				else if (spriteActor.worldOrientation.x < 0)
				{
					x = spriteActor.getWorldInteract().x - _prop.getInteractOffsetX() - _prop.width;
				}
				else
				{
					x = spriteActor.getWorldInteract().x + _prop.getInteractOffsetX();
				}
				var y:Number = spriteActor.getWorldInteract().y + _prop.getInteractOffsetY();
				_prop.worldPosition.setValues(x, y);
			}
		}
		
		public function handleSignal(game:Game, actor:Actor, signal:int, args:Object):void 
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || spriteActor.isDead()) return;
			
			switch (signal) 
			{
				case Signals.INTERACT_EVENT:
					interact(game, actor);
					break;
				default:
					break;
			}
		}
		
		private function interact(game:Game, actor:Actor):void
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || spriteActor.isDead()) return;	
			
			// pick up
			if (_prop == null)
			{
				var prop:Prop = game.checkClosestProp(spriteActor.getWorldInteract(), _radius);
				if (prop != null)
				{
					spriteActor.handleSignal(game, Signals.ACTION_EXECUTE, Actions.GRAB);
					_prop = prop;
					_prop.onInteractStart();
				}
			}
			// let go
			else
			{
				spriteActor.handleSignal(game, Signals.ACTION_EXECUTE, Actions.GRAB);
				_prop.worldPosition.y -= _prop.getInteractOffsetDrop();
				_prop.onInteractStop();
				_prop = null;
			}
		}
	}
}