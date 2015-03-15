package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class ProjectileManager
	{
		private var sprite:Sprite;
		private var actorManager:ActorManager;
		private var projectiles:Vector.<Projectile>;
		
		public function ProjectileManager(sprite:Sprite)
		{
			this.sprite = sprite;
			actorManager = new ActorManager();
			projectiles = new Vector.<Projectile>();
		}
		
		public function clear() :void
		{
			for each (var p:Projectile in projectiles)
			{
				removeHelper(p);
			}
			projectiles.length = 0;
		}
		
		public function update(game:Game, elapsed:Number) :void
		{
			if (projectiles.length > 1000) new Assert("Too many projectiles!");
			actorManager.update(game, elapsed);
		}
		
		public function applyCamera(camera:Camera):void
		{			
			for each (var c:CameraPositionable in projectiles)
			{
				camera.apply(c);
			}			
		}
		
		public function handleSignal(game:Game, signal:int, args:Object) :void
		{
			var p:Projectile = args as Projectile;
			switch (signal)
			{
				case Signals.PROJECTILE_ADD:
					add(p);
					break;
				case Signals.PROJECTILE_REMOVE:
					remove(p);
					break;					
				default:
					break;
			}
			actorManager.handleSignal(game, signal, args);
		}
		
		private function add(p:Projectile):void
		{
			actorManager.add(p);
			projectiles.push(p);
			sprite.addChild(p);
		}
		
		private function remove(p:Projectile):void
		{
			removeHelper(p);
			
			for (var i:int = 0; i < projectiles.length; i++)
			{
				if (projectiles[i] == p)
				{
					projectiles.splice(i, 1);
					break;
				}
			}
		}
		
		private function removeHelper(p:Projectile):void
		{
			actorManager.remove(p);
			p.removeFromParent(true);		
		}
		
	} // class
	
} // package