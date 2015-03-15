package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class EnemyManager
	{
		private var sprite :Sprite;
		private var actorManager :ActorManager;
		private var cameraPositionables :Vector.<CameraPositionable>;
		
		public function EnemyManager(sprite :Sprite)
		{
			this.sprite = sprite;
			
			actorManager = new ActorManager();
			cameraPositionables = new Vector.<CameraPositionable>();
		}
		
		public function clear() :void
		{
			actorManager.clear();
			cameraPositionables.length = 0;
		}
		
		public function spawn(enemyType :int) :Enemy
		{
			var newEnemy :Enemy;
			
			switch (enemyType) 
			{	
				case Enemy.TYPE_SENTRY:
					{
						newEnemy = new Sentry(100, Assets.ElementsTextures);
					}
					break;

				case Enemy.TYPE_SCOUT:
					{
						newEnemy = new Scout(100, Assets.ElementsTextures);
					}
					break;

				case Enemy.TYPE_ASSAULT:
					{
						newEnemy = new Assault(100, Assets.ElementsTextures);
					}
					break;

				case Enemy.TYPE_STALIN:
					{
						newEnemy = new Stalin(100, Assets.ElementsTextures);
					}
					break;

				case Enemy.TYPE_STALIN_ON_FOOT:
					{
						newEnemy = new StalinOnFoot(100, Assets.ElementsTextures);
					}
					break;

				case Enemy.TYPE_TURRET:
					{
						newEnemy = new Turret();
					}
					break;
					
				default:
					{
						newEnemy = new Sentry(100, Assets.ElementsTextures);
					}
					break;
			}
			
			actorManager.add(newEnemy);
			cameraPositionables.push(newEnemy);
			sprite.addChild(newEnemy);
			return newEnemy;
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			actorManager.update(game, elapsed);
		}
		
		public function applyCamera(camera :Camera) :void
		{			
			for each (var c :CameraPositionable in cameraPositionables)
			{
				camera.apply(c);
			}			
		}
		
		public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			actorManager.handleSignal(game, signal, args);
		}
		
		public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			return actorManager.checkCollision(game, pos, ignore);
		}
		
		public function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void
		{
			actorManager.checkExplosion(game, pos, radius);
		}
		
	} // class

} // package
