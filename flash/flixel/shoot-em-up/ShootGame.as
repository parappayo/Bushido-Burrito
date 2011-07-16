package
{
	import org.flixel.*;

	// note: resolution is Gunbird resolution
	[SWF(width="224", height="320", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class ShootGame extends FlxGame
	{
		public function ShootGame()
		{
			super(224, 320, PlayState, 2);
			// forceDebugger = true;
		}
	}
}

