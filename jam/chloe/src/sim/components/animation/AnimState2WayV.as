package sim.components.animation 
{
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;

	public class AnimState2WayV implements AnimState 
	{	
		private var _clipUp:MovieClip;
		private var _clipDown:MovieClip;
		private var _current:MovieClip;
		
		public function AnimState2WayV(textureAtlas:TextureAtlas, animName:String, fps:int = Settings.SpriteFramerate)
		{
			_clipUp = new MovieClip(textureAtlas.getTextures(animName + "_up"), fps);
			_clipDown = new MovieClip(textureAtlas.getTextures(animName + "_down"), fps);
			_current = null;
		}
		
		public function enter(actor:SpriteActor):Boolean 
		{
			updateAnimation(actor);
			Starling.juggler.add(_clipUp);
			Starling.juggler.add(_clipDown);
			return true;
		}
		
		public function update(actor:SpriteActor, elapsed:Number):void
		{
			updateAnimation(actor);
		}
		
		public function exit(actor:SpriteActor, force:Boolean = false):Boolean 
		{
			Starling.juggler.remove(_clipUp);
			Starling.juggler.remove(_clipDown);
			if (_current != null)
			{
				_current.removeFromParent(true);
				_current = null;
			}
			return true;
		}
		
		private function updateAnimation(actor:SpriteActor):void
		{
			// check what the target animation should be
			var target:MovieClip = _current;
			if (staleOrientation(actor))
			{
				if (actor.worldOrientationTarget.y < 0)
				{
					target = _clipUp;
					actor.worldOrientation.setValues(0, -1);
				}	
				else if (actor.worldOrientationTarget.y > 0)
				{
					target = _clipDown;
					actor.worldOrientation.setValues(0, 1);
				}
				else if (actor.worldOrientation.y < 0)
				{
					target = _clipUp;
					actor.worldOrientation.setValues(0, -1);
				}
				else
				{
					target = _clipDown;
					actor.worldOrientation.setValues(0, 1);
				}
			}
			
			// switch the active animation
			if (_current != target)
			{
				if (_current != null)
				{
					_current.removeFromParent(true);
				}
				if (target != null)
				{
					actor.addChild(target);
				}
				_current = target;
			}
		}
		
		private function staleOrientation(actor:SpriteActor):Boolean
		{
			if (_current == null) return true;
			const oriTarget:WorldOrientation = actor.worldOrientationTarget;
			const stale:Boolean = (_current == _clipUp && oriTarget.y >= 0 || _current == _clipDown && oriTarget.y <= 0);
			return stale;
		}
		
		public function isDone():Boolean
		{
			// this animation type is never finished
			return false;
		}
		
	} // class
} // package
