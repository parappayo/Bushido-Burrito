package sim 
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
		
		public function setWalkable(x:Number, y:Number, walkable:Boolean):void
		{
			const index:int = getIndex(x, y);
			data[index] = walkable;
		}
		
		public function isWalkable(x:Number, y:Number):Boolean
		{
			const index:int = getIndex(x, y);
			return data[index];
		}
		
		private function getIndex(x:Number, y:Number):int
		{
			const xIndex:Number = Math.round(x / Settings.WalkmeshSize);
			const yIndex:Number = Math.round(y / Settings.WalkmeshSize);
			return (xIndex + (yIndex * numCols));
		}
	}	

} // package
