package sim 
{
	import sim.actors.Projectile;
	public class Memory 
	{	
		private static const PROJECTILE_HERO:String = "hero_bullet";
		private static const PROJECTILE_ENEMY:String = "enemy_bullet";
		private static const PROJECTILE_TANK:String = "tank_bullet";
		
		private static var _projectilesHero:Pool;
		private static var _projectilesEnemy:Pool;
		private static var _projectilesTank:Pool;
		
		public static function init():void
		{
			_projectilesHero = new Pool(Projectile, 100);
			initProjectilePool(_projectilesHero, PROJECTILE_HERO);
			_projectilesEnemy = new Pool(Projectile, 100);
			initProjectilePool(_projectilesEnemy, PROJECTILE_ENEMY);
			_projectilesTank = new Pool(Projectile, 20);
			initProjectilePool(_projectilesTank, PROJECTILE_TANK);
		}
		
		public static function newProjectile(type:String):Projectile
		{
			var p:Projectile = null;
			var pool:Pool = findProjectilePool(type);
			if (pool != null)
			{
				p = pool.acquire() as Projectile;
			}
			return p;
		}
		
		public static function deleteProjectile(p:Projectile):void
		{
			var pool:Pool = findProjectilePool(p.GetType());
			if (pool != null)
			{
				pool.release(p);
			}
		}
		
		private static function initProjectilePool(pool:Pool, type:String):void
		{
			var items:Array = pool.getItems();
			for (var i:int = 0; i < items.length; ++i)
			{
				var p:Projectile = items[i] as Projectile;
				p.init(type, 0, null);
			}
		}
		
		private static function findProjectilePool(type:String):Pool
		{
			var pool:Pool = null;
			switch(type)
			{
				case PROJECTILE_HERO:
					pool = _projectilesHero;
					break;
				case PROJECTILE_ENEMY:
					pool = _projectilesEnemy;
					break;
				case PROJECTILE_TANK:
					pool = _projectilesTank;
					break;
				default:
					new Assert("No pool assigned to this projectile type!");
			}
			return pool;
		}
	}
}