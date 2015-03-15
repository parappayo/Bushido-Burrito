package actors 
{
	import flash.geom.Point;
	public class Walkmesh 
	{
		private var data:Array;
		private var numCols:Number;
		private var cellMin:Point;
		private var cellMax:Point;
		
		public function Walkmesh(bitstring:String) 
		{
			data = new Array();
			numCols = 0;
			cellMin = new Point();
			cellMax = new Point();
			
			var char:String;
			var count:Number = 0;
			for (var i:int=0; i<bitstring.length; i++) 
			{ 
				char = bitstring.charAt(i);
				if (char == "0")
				{
					data.push(false);
				}
				else if (char == "1")
				{
					data.push(true);
				}
				else if (numCols == 0)
				{
					numCols = count;
				}
				count++;
			}
		}
		
		public function isWalkable(x:Number, y:Number):Boolean
		{
			const xIndex:Number = Math.round(x / Assets.TileW);
			const yIndex:Number = Math.round(y / Assets.TileH);
			const index:Number = xIndex + (yIndex * numCols);
			return data[index];
		}
		
	}

}