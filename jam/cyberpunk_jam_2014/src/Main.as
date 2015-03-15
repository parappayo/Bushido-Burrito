
package 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import starling.core.Starling;
	import starling.utils.*;
	
	[SWF(width=960, height=750, frameRate=60, backgroundColor=0x000000)]
	public class Main extends Sprite 
	{
		public function Main() :void
		{
			stage.fullScreenSourceRect = new Rectangle(0, 0, Settings.ScreenWidth, Settings.ScreenHeight);
			var starling :Starling = new Starling(Game, stage, null, null, "auto", "baseline");
			starling.showStats = Settings.ShowStats;
			starling.start();
		}
		
	} // class
	
} // package

