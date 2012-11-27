package 
{
	import flash.geom.Point;
	public class MazeData
	{
		private var height :int;
		private var width :int;
		private var data :Array; // Array<cell enum>
		
		// cell enum
		public static const CELL_EMPTY :int = 0;
		public static const CELL_WALL :int = 1;
		
		// cardinal directions
		public static const DIR_NORTH :int = 0;
		public static const DIR_EAST :int = 1;
		public static const DIR_SOUTH :int = 2;
		public static const DIR_WEST :int = 3;
		
		public function MazeData(height :int, width :int)
		{
			this.height = height;
			this.width = width;
			
			this.data = new Array();
			for (var i :int = 0; i < height * width; i++)
			{
				this.data[i] = CELL_EMPTY;
			}
		}
		
		public function getCell(pos :Point) :int
		{
			return data[pos.y * width + pos.x];
		}
		
		public function getCellXY(x :int, y :int) :int
		{
			return data[y * width + x];
		}

		public function setCell(pos :Point, value :int) :void
		{
			data[pos.y * width + pos.x] = value;
		}
		
		public function isWall(x :int, y :int) :Boolean
		{
			if (x < 0 || y < 0 || x >= width || y >= height)
			{
				return false;
			}
			return data[y * width + x] == CELL_WALL;
		}
		
		/**
		 * Tries to find an open spot in the maze, returns false on fail.
		 */
		public function findOpenCell(result :Point) :Boolean
		{
			if (!result) { result = new Point(); }
			
			for (var y :int = 0; y < height; y++)
			{
				for (var x :int = 0; x < width; x++)
				{
					if (!isWall(x, y))
					{
						result.x = x;
						result.y = y;
						return true;
					}
				}
			}
			return false;
		}
		
		public function populate() :void
		{
			generateDepthFirst(width/2, height/2, new Array());
		}
		
		/**
		 * Used by generate functions to determine if a cell is elligible to
		 * be made empty.
		 * @param fromDirection should be one of the DIR_ constants.
		 *        It represents the direction that the carver is entering
		 *        the target cell from. This affects the carving rules.
		 */
		private function canCarve(x :int, y :int, fromDirection :int) :Boolean
		{
			if (fromDirection == DIR_NORTH)
			{
				return isWall(x - 1, y) &&
					isWall(x + 1, y) &&
					isWall(x - 1, y + 1) &&
					isWall(x, y + 1) &&
					isWall(x + 1, y + 1);
			}
			if (fromDirection == DIR_SOUTH)
			{
				return isWall(x - 1, y) &&
					isWall(x + 1, y) &&
					isWall(x - 1, y - 1) &&
					isWall(x, y - 1) &&
					isWall(x + 1, y - 1);
			}
			if (fromDirection == DIR_EAST)
			{
				return isWall(x, y - 1) &&
					isWall(x, y + 1) &&
					isWall(x - 1, y - 1) &&
					isWall(x - 1, y) &&
					isWall(x - 1, y + 1);
			}
			if (fromDirection == DIR_WEST)
			{
				return isWall(x, y - 1) &&
					isWall(x, y + 1) &&
					isWall(x + 1, y - 1) &&
					isWall(x + 1, y) &&
					isWall(x + 1, y + 1);
			}
			return false;
		}
		
		private function getNeighbours(x :int, y :int, visited :Array) :Array
		{
			var neighbours :Array = new Array();
			var i :int;
			
			if (x > 1)
			{
				i = y * width + x - 1;
				if (!visited[i])
				{
					neighbours.push( { x:(x - 1), y:y, i:i, dir:DIR_EAST } );
				}
			}
			if (x < width - 1)
			{
				i = y * width + x + 1;
				if (!visited[i])
				{
					neighbours.push( { x:(x + 1), y:y, i:i, dir:DIR_WEST } );
				}
			}
			if (y > 1)
			{
				i = (y - 1) * width + x;
				if (!visited[i])
				{
					neighbours.push( { x:x, y:(y - 1), i:i, dir:DIR_SOUTH } );
				}
			}
			if (y < height - 1)
			{
				i = (y + 1) * width + x;
				if (!visited[i])
				{
					neighbours.push( { x:x, y:(y + 1), i:i, dir:DIR_NORTH } );
				}
			}
			
			return neighbours;
		}
		
		public function generateDepthFirst(x :int, y :int, visited :Array) :void
		{
			var i :int;
			if (visited.length == 0)
			{
				for (i = 0; i < width * height; i++)
				{
					visited[i] = false;
					data[i] = CELL_WALL;
				}
			}
			
			i = y * width + x;
			data[i] = CELL_EMPTY;
			visited[i] = true;
			
			var neighbours :Array = getNeighbours(x, y, visited);
			while (neighbours.length > 0)
			{
				var rand :int = Math.floor(Math.random() * neighbours.length);
				var n :Object = neighbours.splice(rand, 1)[0];
				
				x = n.x;
				y = n.y;
				i = n.i;
				var fromDir :int = n.dir;
				
				if (canCarve(x, y, fromDir))
				{
					generateDepthFirst(x, y, visited);
				}
				else
				{
					visited[i] = true;
				}
			}
		}
		
		/**
		 * Populate the maze using Prim's Algorithm.
		 */
		// TODO: finish implementing Prim's
		/*
		public function generatePrims() :void
		{
			var walls :Array = new Array();
			var visited :Array = new Array();
			var i, x, y :int;
			
			for (i = 0; i < width * height; i++)
			{
				visited[i] = false;
				data[i] = CELL_WALL;
			}
			
			x = (width / 2);
			y = (height / 2);
			data[y * width + x] = CELL_EMPTY;
			
			var neighbours :Array = getNeighbours(x, y, visited);
			while (neighbours.length > 0)
			{
				i = Math.floor(Math.random() * neighbours.length);
				
			}
		}
		*/
		
		/**
		 * A simple random maze using binary tree carving.
		 */
		public function generateBinaryTree() :void
		{
			var i :int, x :int, y :int;
			
			for (i = 0; i < width * height; i++)
			{
				data[i] = CELL_WALL;
			}

			for (y = 1; y < height - 2; y += 2)
			{
				for (x = 1; x < width - 2; x += 2)
				{
					data[y * width + x] = CELL_EMPTY;
					
					// force a border path around the periphery,
					// otherwise maze is not guaranteed to be connected
					if (x <= 1 || x >= width - 3)
					{
						data[(y + 1) * width + x] = CELL_EMPTY;						
					}
					if (y <= 1 || y >= height - 3)
					{
						data[y * width + (x + 1)] = CELL_EMPTY;						
					}
					
					if (Math.random() < 0.5)
					{
						data[(y + 1) * width + x] = CELL_EMPTY;
					}
					else
					{
						data[y * width + (x + 1)] = CELL_EMPTY;
					}
				}
			}
		}
		
		public function toString() :String
		{
			var retval :String = "";
			
			for (var y :int = 0; y < height; y++)
			{
				for (var x :int = 0; x < width; x++)
				{
					var cell :int = data[y * width + x];
					if (cell == CELL_WALL)
					{
						retval += "#";
					}
					else
					{
						retval += ".";
					}
				}
				retval += "\n";
			}
			
			return retval;
		}
	}
	
}
