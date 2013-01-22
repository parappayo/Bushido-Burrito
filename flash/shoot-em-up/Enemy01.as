package
{
	import org.flixel.*;

	public class Enemy01 extends FlxSprite
	{
		[Embed(source="zero_orange.png")] private var SpriteImg :Class;

		public function Enemy01(x :int, y :int, Bullets :FlxGroup)
		{
			super(x, y);
			loadGraphic(SpriteImg, true);

			var fps :int = 10;
			addAnimation("Default", [0, 1, 2, 3], fps);

			play("Default");
		}
	}
}

