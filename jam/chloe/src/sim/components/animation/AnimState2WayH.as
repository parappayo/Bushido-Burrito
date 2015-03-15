package sim.components.animation 
{
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;

	public class AnimState2WayH implements AnimState 
	{
		private var _clipLeft:MovieClip;
		private var _clipRight:MovieClip;
		private var _current:MovieClip;
		private var _sound:SoundEvent;
		
		public function AnimState2WayH(textureAtlas:TextureAtlas, animName:String, sound:SoundEvent = null)
		{
			const fps:Number = Settings.SpriteFramerate;
			_clipLeft = new MovieClip(textureAtlas.getTextures(animName + "_left"), fps);
			_clipRight = new MovieClip(textureAtlas.getTextures(animName + "_right"), fps);
			_current = null;
			_sound = sound;
		}
		
		public function enter(actor:SpriteActor):Boolean 
		{
			updateAnimation(actor);
			Starling.juggler.add(_clipLeft);
			Starling.juggler.add(_clipRight);
			return true;
		}
		
		public function update(actor:SpriteActor, elapsed:Number):void
		{
			updateAnimation(actor);
			if (_sound != null)
			{
				_sound.update(elapsed);
			}
		}
		
		public function exit(actor:SpriteActor, force:Boolean = false):Boolean 
		{
			Starling.juggler.remove(_clipLeft);
			Starling.juggler.remove(_clipRight);
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
				if (actor.worldOrientationTarget.x < 0)
				{
					target = _clipLeft;
					actor.worldOrientation.setValues(-1, 0);
				}
				else if (actor.worldOrientationTarget.x > 0)
				{
					target = _clipRight;
					actor.worldOrientation.setValues(1, 0);
				}
				else if (actor.worldOrientation.x < 0)
				{
					target = _clipLeft;
					actor.worldOrientation.setValues(-1, 0);
				}
				else
				{
					target = _clipRight;
					actor.worldOrientation.setValues(1, 0);
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
			const stale:Boolean = (_current == _clipLeft && oriTarget.x >= 0 || _current == _clipRight && oriTarget.x <= 0); 
			return stale;
		}
		
		public function isDone():Boolean
		{
			// this animation type is never finished
			return false;
		}
		
	} // class
} // package
