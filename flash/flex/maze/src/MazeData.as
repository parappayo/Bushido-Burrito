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
		
		public function populate() :void
		{
			generateBinaryTree();
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
