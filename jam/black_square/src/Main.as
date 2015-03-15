package 
{
	import flash.geom.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import starling.core.Starling;
	import starling.utils.*;
	import sim.Settings;
	
	// authored to GameBoy x5 resolution (800, 720)
	[SWF(width=800, height=720, frameRate=60, backgroundColor=0x000000)]
	public class Main extends Sprite
	{
		public function Main()
		{
			var star:Starling;
			
			if (Settings.MobileBuild)
			{
				stage.displayState = "fullScreen";
			
				var viewport :Rectangle = RectangleUtil.fit(
					new Rectangle(0, 0, Settings.ScreenWidth, Settings.ScreenHeight),
					new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
					ScaleMode.SHOW_ALL);

				star = new Starling(Game, stage, viewport);
				star.stage.stageWidth = Settings.ScreenWidth;
				star.stage.stageHeight = Settings.ScreenHeight;
			}
			else
			{
				stage.fullScreenSourceRect = new Rectangle(0, 0, Settings.ScreenWidth, Settings.ScreenHeight);				
				star = new Starling(Game, stage, null, null, "auto", "baseline");
			}
			
			star.showStats = Settings.ShowStats;
			star.start();
			addEventListener(Event.DEACTIVATE, deactivate);
		}
		
		private function deactivate(e:Event):void
		{
			SoundPlayer.stopMusic();
		}
	}
	
} // package
