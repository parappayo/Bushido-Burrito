package sim 
{
	import flash.geom.Point;
	
	public class Walkmesh 
	{
		private var data:Object;
		private var dataEnemies:Object;
		private var _mapWidth:int;
		private var _roomWidth:int;
		
		public function Walkmesh(mapWidth:int, roomWidth:int) 
		{
			data = new Object();
			dataEnemies = new Object();
			_mapWidth = mapWidth;
			_roomWidth = roomWidth;
		}
		
		public function addData(bitstring:String, cellX:int, cellY:int) :void
		{
			for (var i:int=0; i<bitstring.length; i++)
			{
				var char :String = bitstring.charAt(i);
				
				if (char != "1") { continue; }
				
				var x :int = cellX + (i % _roomWidth);
				var y :int = cellY + (i / _roomWidth);
				var j :int = y * _mapWidth + x;

				data[j] = true;
				dataEnemies[j] = false;
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
		
		public function setEnemyPresence(x:Number, y:Number, enemy:Boolean):void
		{
			const index:int = getIndex(x, y);
			dataEnemies[index] = enemy;
		}
		
		public function hasEnemyPresence(x:Number, y:Number):Boolean
		{
			const index:int = getIndex(x, y);
			return dataEnemies[index];
		}
		
		private function getIndex(x:Number, y:Number):int
		{
			const tileX :Number = Math.round(x / Settings.TileW);
			const tileY :Number = Math.round(y / Settings.TileH);
			return tileY * _mapWidth + tileX;
		}
	}	

} // package
