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
			data.setCell(new Point(2, 1), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 3), MazeData.CELL_WALL);
			//data.setCell(new Point(2, 4), MazeData.CELL_WALL);
			//trace(data.toString());
			
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
			
			var farRect :Rectangle = new Rectangle();
			farRect.width = stage.stageWidth / cellSize;
			farRect.height = stage.stageHeight / cellSize;
			farRect.x = (stage.stageWidth - farRect.width) / 2;
			farRect.y = (stage.stageHeight - farRect.height) / 2;

			// cell immediately to the left
			if (cellData[0] == MazeData.CELL_WALL)
			{
				// draw the wall
				graphics.moveTo(0, 0);
				graphics.lineTo(farRect.left, farRect.top);
				graphics.lineTo(farRect.left, farRect.bottom);
				graphics.lineTo(0, stage.stageHeight);
			}
			else
			{
				// draw the floor
				graphics.moveTo(0, stage.stageHeight);
				graphics.lineTo(farRect.left, farRect.bottom);
				graphics.lineTo(0, farRect.bottom);
			}
			
			// cell immediately to the right
			if (cellData[2] == MazeData.CELL_WALL)
			{
				// draw the wall
				graphics.moveTo(stage.stageWidth, 0);
				graphics.lineTo(farRect.right, farRect.top);
				graphics.lineTo(farRect.right, farRect.bottom);
				graphics.lineTo(stage.stageWidth, stage.stageHeight);
			}
			else
			{
				// draw the floor
				graphics.moveTo(stage.stageWidth, stage.stageHeight);
				graphics.lineTo(farRect.right, farRect.bottom);
				graphics.lineTo(stage.stageWidth, farRect.bottom);
			}			

			// all other cells
			for (var i :int = 1; i <= drawDepth; i++)
			{
				drawCellsAtDepth(i, cellData);
			}
		}
		
		/**
		 * Takes a depth in number of cells and draws the walls.
		 * 
		 * @param cellData contains pre-computed cell states.
		 */
		public function drawCellsAtDepth(depth :int, cellData :Array) :void
		{
			var nearestRect :Rectangle = new Rectangle();
			if (depth > 0)
			{
				nearestRect.width = stage.stageWidth / (cellSize * (depth - 1));
				nearestRect.height = stage.stageHeight / (cellSize * (depth - 1));
				nearestRect.x = (stage.stageWidth - nearestRect.width) / 2;
				nearestRect.y = (stage.stageHeight - nearestRect.height) / 2;
			}
			else
			{
				nearestRect.width = stage.stageWidth;
				nearestRect.height = stage.stageHeight;
				nearestRect.x = 0;
				nearestRect.y = 0;
			}
			
			var nearRect :Rectangle = new Rectangle();
			nearRect.width = stage.stageWidth / (cellSize * depth);
			nearRect.height = stage.stageHeight / (cellSize * depth);
			nearRect.x = (stage.stageWidth - nearRect.width) / 2;
			nearRect.y = (stage.stageHeight - nearRect.height) / 2;
			
			var farRect :Rectangle = new Rectangle();
			farRect.width = stage.stageWidth / (cellSize * (depth + 1));
			farRect.height = stage.stageHeight / (cellSize * (depth + 1));
			farRect.x = (stage.stageWidth - farRect.width) / 2;
			farRect.y = (stage.stageHeight - farRect.height) / 2;
			
			// cell in front
			if (cellData[depth * 3 + 1] == MazeData.CELL_WALL)
			{
				// draw the wall
				graphics.drawRect(nearRect.x, nearRect.y, nearRect.width, nearRect.height);
			}
			else
			{
				// draw the floor
				graphics.moveTo(nearRect.left, nearRect.bottom);
				graphics.lineTo(nearRect.right, nearRect.bottom);
				graphics.lineTo(farRect.right, farRect.bottom);
				graphics.lineTo(farRect.left, farRect.bottom);
				graphics.lineTo(nearRect.left, nearRect.bottom);
			}
			
			// cell in front and left
			if (cellData[depth * 3] == MazeData.CELL_WALL)
			{
				var occluded :Boolean = false;

				// front wall
				for (var i :int = depth-1; i >= 0; i--)
				{
					// TODO: fix this, totally wrong
					occluded = occluded || (cellData[i * 3] == MazeData.CELL_WALL);
				}
				if (!occluded)
				{
					graphics.moveTo(nearestRect.left, nearRect.top);
					graphics.lineTo(nearRect.left, nearRect.top);
					graphics.lineTo(nearRect.left, nearRect.bottom);
					graphics.lineTo(nearestRect.left, nearRect.bottom);
				}
				
				// side wall
				for (var i :int = depth; i >= 0; i--)
				{
					// TODO: fix this, totally wrong
					occluded = occluded || (cellData[i * 3 + 1] == MazeData.CELL_WALL);
				}
				if (!occluded)
				{
					graphics.moveTo(nearRect.left, nearRect.top);
					graphics.lineTo(farRect.left, farRect.top);
					graphics.lineTo(farRect.left, farRect.bottom);
					graphics.lineTo(nearRect.left, nearRect.bottom);
					graphics.lineTo(nearRect.left, nearRect.top);
				}
			}
			else // draw the floor
			{
				// front wall
				for (var i :int = depth-1; i >= 0; i--)
				{
					// TODO: fix this, totally wrong
					occluded = occluded || (cellData[i * 3] == MazeData.CELL_WALL);
				}
				if (!occluded)
				{
					graphics.moveTo(nearRect.left, nearRect.bottom);
					graphics.lineTo(nearestRect.left, nearRect.bottom);
					
					graphics.moveTo(nearRect.left, farRect.bottom);
					graphics.lineTo(nearestRect.left, farRect.bottom);
				}
				
				// side wall
				for (var i :int = depth; i >= 0; i--)
				{
					// TODO: fix this, totally wrong
					occluded = occluded || (cellData[i * 3 + 1] == MazeData.CELL_WALL);
				}
				if (!occluded)
				{
					graphics.moveTo(nearRect.left, nearRect.bottom);
					graphics.lineTo(farRect.left, farRect.bottom);
					graphics.lineTo(nearRect.left, farRect.bottom);
				}
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
			
			trace("pos = (" + pos.x + ", " + pos.y + ")");

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

			trace("-> (" + pos.x + ", " + pos.y + ")");

			return data.getCell(pos);
		}
	}
}
