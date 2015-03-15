package 
{
	import starling.core.Starling;
	import flash.display.Sprite;
	
	[SWF(width=1024, height=768, frameRate=60, backgroundColor=0x333333)]
	public class Main extends Sprite
	{
		public function Main()
		{
			var star:Starling = new Starling(Game, stage, null, null, "auto", "baseline");
			star.start();
		}
	}
	
} // package

