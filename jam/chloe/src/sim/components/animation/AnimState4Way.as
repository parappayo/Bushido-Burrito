package sim.components.animation 
{
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;

	public class AnimState4Way implements AnimState 
	{	
		private var _clipUp:MovieClip;
		private var _clipDown:MovieClip;
		private var _clipLeft:MovieClip;
		private var _clipRight:MovieClip;
		private var _current:MovieClip;
		private var _sound:SoundEvent;
		
		public function AnimState4Way(textureAtlas:TextureAtlas, animName:String, sound:SoundEvent = null)
		{
			const fps:Number = Settings.SpriteFramerate;
			_clipUp = new MovieClip(textureAtlas.getTextures(animName + "_up"), fps);
			_clipDown = new MovieClip(textureAtlas.getTextures(animName + "_down"), fps);
			_clipLeft = new MovieClip(textureAtlas.getTextures(animName + "_left"), fps);
			_clipRight = new MovieClip(textureAtlas.getTextures(animName + "_right"), fps);
			_current = null;
			_sound = sound;
		}
		
		public function enter(actor:SpriteActor):Boolean 
		{
			updateAnimation(actor);
			Starling.juggler.add(_clipUp);
			Starling.juggler.add(_clipDown);
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
			Starling.juggler.remove(_clipUp);
			Starling.juggler.remove(_clipDown);
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
				else if (actor.worldOrientationTarget.y < 0)
				{
					target = _clipUp;
					actor.worldOrientation.setValues(0, -1);
				}	
				else if (actor.worldOrientationTarget.y > 0)
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
			const staleV:Boolean = (_current == _clipUp && oriTarget.y >= 0 || _current == _clipDown && oriTarget.y <= 0);
			const staleH:Boolean = (_current == _clipLeft && oriTarget.x >= 0 || _current == _clipRight && oriTarget.x <= 0); 
			return (staleV || staleH);
		}
		
		public function isDone():Boolean
		{
			// this animation type is never finished
			return false;
		}
		
	} // class
} // package
