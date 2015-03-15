package 
{
	import flash.display.Sprite;
	import starling.core.Starling;
	
	[SWF(width=1280, height=720, frameRate=30, backgroundColor=0x000000)]
	public class Main extends Sprite
	{
		public function Main()
		{
			var star:Starling = new Starling(Game, stage);
			//star.showStats = true;
			star.start();
		}
	}
}