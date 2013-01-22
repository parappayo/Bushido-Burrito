package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		public var enemies :FlxGroup;
		public var enemyBullets :FlxGroup;

		override public function create() :void
		{
			enemies = new FlxGroup();
			add(enemies);
			enemyBullets = new FlxGroup();
			add(enemyBullets);

			var enemy :Enemy01 = new Enemy01(10, 10, enemyBullets);
			enemies.add(enemy);
		}

		override public function update() :void
		{
			super.update();
		}
	}
}

