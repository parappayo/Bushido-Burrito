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
		
		public function setCell(pos :Point, value :int) :void
		{
			data[pos.y * width + pos.x] = value;
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
