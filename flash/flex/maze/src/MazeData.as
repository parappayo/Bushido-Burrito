package 
{
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
		
		public function getCell(x :int, y :int) :int
		{
			return data[y * width + x];
		}
		
		public function setCell(x :int, y :int, value :int) :void
		{
			data[y * width + x] = value;
		}
	}
	
}
