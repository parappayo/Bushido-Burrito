package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		// settings
		// TODO: make settings data-driven
		public var cellSize :Number; // as a ratio of the view dims
		public var drawDepth :Number; // in cells
		
		public function MazeView() 
		{
			data = new MazeData(16, 16);
			
			playerPos = new Point(0, 0);
			playerDir = DIR_NORTH;
			
			// default settings
			cellSize = 1.5;
			drawDepth = 4;
		}
		
		public function init() :void
		{
			// test data
			playerPos.x = 3;
			playerPos.y = 3;

			//data.setCell(new Point(2, 0), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 1), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 2), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 3), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 4), MazeData.CELL_WALL);

			//data.setCell(new Point(4, 0), MazeData.CELL_WALL);
			//data.setCell(new Point(4, 1), MazeData.CELL_WALL);
			//data.setCell(new Point(4, 2), MazeData.CELL_WALL);
			//data.setCell(new Point(4, 3), MazeData.CELL_WALL);
			//data.setCell(new Point(4, 4), MazeData.CELL_WALL);

			//data.setCell(new Point(2, 2), MazeData.CELL_WALL);
			//data.setCell(new Point(3, 2), MazeData.CELL_WALL);			
			//data.setCell(new Point(4, 3), MazeData.CELL_WALL);			
			
			draw();
		}
		
		public function draw() :void
		{
			// TODO: make linestyle a setting
			graphics.lineStyle(2, 0x000000);
			
			// player-relative cell data
			var cellData :Array = new Array();
			var pos :Point = new Point();
			for (var y :int = 0; y <= drawDepth; y++)
			{
				pos.x = -1;
				pos.y = y;	
				cellData[y * 3 + 0] = getCellFromPlayerPOV(pos);
				
				pos.x = 0;
				pos.y = y;	
				cellData[y * 3 + 1] = getCellFromPlayerPOV(pos);
				
				pos.x = 1;
				pos.y = y;	
				cellData[y * 3 + 2] = getCellFromPlayerPOV(pos);
			}

			drawCellsAtDepth(0, cellData); // recursive
		}
		
		/**
		 * Takes a depth in number of cells and draws the walls.
		 * 
		 * @param cellData contains pre-computed cell states.
		 * The cellData is in 3 column wide rows where depth*3+0 is the left side,
		 * depth*3+1 is the center, and depth*3+2 is the right side.
		 */
		public function drawCellsAtDepth(depth :int, cellData :Array) :void
		{
			var nearRect :Rectangle = new Rectangle();
			if (depth > 0)
			{
				nearRect.width = stage.stageWidth / (cellSize * depth);
				nearRect.height = stage.stageHeight / (cellSize * depth);
				nearRect.x = (stage.stageWidth - nearRect.width) / 2;
				nearRect.y = (stage.stageHeight - nearRect.height) / 2;
			}
			else
			{
				nearRect.width = stage.stageWidth;
				nearRect.height = stage.stageHeight;
				nearRect.x = 0;
				nearRect.y = 0;				
			}
			
			var farRect :Rectangle = new Rectangle();
			farRect.width = stage.stageWidth / (cellSize * (depth + 1));
			farRect.height = stage.stageHeight / (cellSize * (depth + 1));
			farRect.x = (stage.stageWidth - farRect.width) / 2;
			farRect.y = (stage.stageHeight - farRect.height) / 2;
		
			// immediate left
			if (cellData[depth * 3 + 0] == MazeData.CELL_WALL)
			{
				graphics.moveTo(nearRect.left, nearRect.top);
				graphics.lineTo(farRect.left, farRect.top);
				
				if (cellData[(depth + 1) * 3 + 0] == MazeData.CELL_WALL)
				{
					graphics.moveTo(farRect.left, farRect.bottom);
				}
				else
				{
					graphics.lineTo(farRect.left, farRect.bottom);
				}
				
				graphics.lineTo(nearRect.left, nearRect.bottom);
			}
			else if (cellData[(depth + 1) * 3 + 0] == MazeData.CELL_WALL)
			{
				graphics.moveTo(nearRect.left, farRect.top);
				graphics.lineTo(farRect.left, farRect.top);
				
				graphics.moveTo(nearRect.left, farRect.bottom);
				graphics.lineTo(farRect.left, farRect.bottom);
			}
			
			// immediate right
			if (cellData[depth * 3 + 2] == MazeData.CELL_WALL)
			{
				graphics.moveTo(nearRect.right, nearRect.top);
				graphics.lineTo(farRect.right, farRect.top);
				
				if (cellData[(depth + 1) * 3 + 2] == MazeData.CELL_WALL)
				{
					graphics.moveTo(farRect.right, farRect.bottom);
				}
				else
				{
					graphics.lineTo(farRect.right, farRect.bottom);
				}
				
				graphics.lineTo(nearRect.right, nearRect.bottom);
			}
			else if (cellData[(depth + 1) * 3 + 2] == MazeData.CELL_WALL)
			{
				graphics.moveTo(nearRect.right, farRect.top);
				graphics.lineTo(farRect.right, farRect.top);
				
				graphics.moveTo(nearRect.right, farRect.bottom);
				graphics.lineTo(farRect.right, farRect.bottom);
			}
			
			// front and center
			if (cellData[(depth + 1) * 3 + 1] == MazeData.CELL_WALL)
			{
				graphics.moveTo(farRect.left, farRect.top);
				graphics.lineTo(farRect.right, farRect.top);

				if (cellData[(depth + 1) * 3 + 2] != MazeData.CELL_WALL)
				{
					graphics.lineTo(farRect.right, farRect.bottom);
				}

				graphics.moveTo(farRect.right, farRect.bottom);
				graphics.lineTo(farRect.left, farRect.bottom);
				
				if (cellData[(depth + 1) * 3 + 0] != MazeData.CELL_WALL)
				{
					graphics.lineTo(farRect.left, farRect.top);
				}
			}
			else if (depth < drawDepth)
			{
				drawCellsAtDepth(depth + 1, cellData);
			}
		}
		
		/**
		 * Translates cell coordinates to the offset in cells from the player's point of view.
		 */
		public function getCellRelativeToPlayer(pos :Point) :int
		{
			var temp :Number;

			pos = pos.subtract(playerPos);
			
			switch (playerDir)
			{
				case DIR_NORTH:
					pos.y = -pos.y;
					break;
				
				case DIR_SOUTH:
					pos.x = -pos.x;
					break;
					
				case DIR_EAST:
					temp = -pos.x;
					pos.x = pos.y;
					pos.y = temp;
					break;
					
				case DIR_WEST:
					temp = pos.x;
					pos.x = -pos.y;
					pos.y = temp;
					break;
			}
			
			return data.getCell(pos);
		}

		/**
		 * Translates a cell offset from the player's point of view to absolute cell coordinates.
		 * 
		 * This is the inverse of getCellRelativeToPlayer().
		 */
		public function getCellFromPlayerPOV(pos :Point) :int
		{
			var temp :Number;
			
			switch (playerDir)
			{
				case DIR_NORTH:
					pos.y = -pos.y;
					break;
				
				case DIR_SOUTH:
					pos.x = -pos.x;
					break;
					
				case DIR_EAST:
					temp = -pos.x;
					pos.x = pos.y;
					pos.y = temp;
					break;
					
				case DIR_WEST:
					temp = pos.x;
					pos.x = -pos.y;
					pos.y = temp;
					break;
			}
			
			pos = pos.add(playerPos);

			return data.getCell(pos);
		}
	}
}
