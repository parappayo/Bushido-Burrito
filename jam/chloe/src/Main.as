package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import starling.core.Starling;
	
	[SWF(width=1024, height=576, frameRate=60, backgroundColor=0xD5EFEF)]
	public class Main extends Sprite
	{
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			var star:Starling = new Starling(Game, stage, null, null, "auto", "baseline");
			star.showStats = Settings.ShowStats;
			star.start();
		}
	}
	
} // package
