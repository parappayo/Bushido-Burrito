package sim.components.animstates 
{
	import sim.actors.SpriteActor;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;
	import starling.events.Event;
	
	public class AnimStateSingle implements AnimState 
	{
		private var _loop :Boolean;
		private var _clip :MovieClip;
		private var _isDone :Boolean;
		
		public function AnimStateSingle(textureAtlas:TextureAtlas, animName:String, loop:Boolean = false, fps:int = Settings.SpriteFramerate)
		{
			_loop = loop;
			_clip = new MovieClip(textureAtlas.getTextures(animName), fps);
			_isDone = false;
		}
		
		public function enter(actor:SpriteActor):Boolean 
		{
			actor.addChild(_clip);
			Starling.juggler.add(_clip);
			_clip.addEventListener(Event.COMPLETE, handleComplete);
			_isDone = false;
			return true;
		}
		
		public function update(actor:SpriteActor, elapsed:Number):void
		{
		}
		
		public function exit(actor:SpriteActor, force:Boolean = false):Boolean 
		{
			Starling.juggler.remove(_clip);
			_clip.removeFromParent(true);
			_isDone = true;
			return true;
		}
		
		public function handleComplete():void
		{
			if (!_loop)
			{
				_clip.pause();
				_isDone = true;
			}
		}
		
		public function isDone():Boolean
		{
			return _isDone;
		}

	} // class

} // package
