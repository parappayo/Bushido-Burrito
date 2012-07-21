package  
{
	import flash.geom.Point;
	import mx.core.UIComponent;
	
	public class MazeView extends UIComponent 
	{
		public var data :MazeData;
		
		public var playerPos :Point;
		public var playerDir :int; // dir enum
		
		// dir enum
		public static const DIR_NORTH :int = 0;
		public static const DIR_SOUTH :int = 1;
		public static const DIR_EAST :int = 2;
		public static const DIR_WEST :int = 3;
		
		public function MazeView() 
		{
			data = new MazeData(16, 16);
			
			playerPos = new Point(0, 0);
			playerDir = DIR_NORTH;
		}
		
		public function init() :void
		{
			draw();
		}
		
		public function draw() :void
		{
			graphics.lineStyle(2, 0x000000);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(stage.stageWidth, stage.stageHeight);
			
			graphics.moveTo(0, stage.stageHeight);
			graphics.lineTo(stage.stageWidth, 0);

			for (var i :int = 1; i <= 8; i++)
			{
				var zDistance :Number = 1.5 * i;
				
				var boxWidth :Number = stage.stageWidth / zDistance;
				var boxHeight :Number = stage.stageHeight / zDistance;
				var boxX :Number = (stage.stageWidth - boxWidth) / 2;
				var boxY :Number = (stage.stageHeight - boxHeight) / 2;
				
				graphics.drawRect(boxX, boxY, boxWidth, boxHeight);
			}
		}
	}
}
