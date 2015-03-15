package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class EffectManager
	{
		private var sprite:Sprite;
		private var actorManager:ActorManager;
		private var cameraPositionables:Vector.<CameraPositionable>;
		
		public function EffectManager(sprite:Sprite)
		{
			this.sprite = sprite;
			actorManager = new ActorManager();
			cameraPositionables = new Vector.<CameraPositionable>();
		}
		
		public function clear() :void
		{
			for each (var e:Effect in cameraPositionables)
			{
				e.stop();
			}
			actorManager.clear();
			cameraPositionables.length = 0;
		}
		
		public function update(game:Game, elapsed:Number) :void
		{
			actorManager.update(game, elapsed);
		}
		
		public function applyCamera(camera:Camera):void
		{			
			for each (var c:CameraPositionable in cameraPositionables)
			{
				camera.apply(c);
			}			
		}
		
		public function handleSignal(game:Game, signal:int, args:Object) :void
		{
			var e:Effect = args as Effect;
			switch (signal)
			{
				case Signals.EFFECT_ADD:
					add(e);
					break;
				case Signals.EFFECT_REMOVE:
					remove(e);
					break;					
				default:
					break;
			}
			actorManager.handleSignal(game, signal, args);
		}
		
		private function add(e:Effect):void
		{
			actorManager.add(e);
			cameraPositionables.push(e);
			sprite.addChild(e);
		}
		
		private function remove(e:Effect):void
		{
			e.stop();
			actorManager.remove(e);
			for (var i:int = 0; i < cameraPositionables.length; i++)
			{
				if (cameraPositionables[i] == e)
				{
					cameraPositionables.splice(i, 1);
					break;
				}
			}
			e.removeFromParent(true);
		}
	} // class
} // package