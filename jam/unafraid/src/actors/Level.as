package actors 
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class Level 
	{
		public var playerPos:Point
		public var fireplacePos:Point;
		public var ghostsPos:Array;
		public var wallsPos:Array;
		public var walkmesh:Walkmesh;
		
		public function Level(xml:Class) 
		{
			var rawData:ByteArray = new xml();
			var dataString:String = rawData.readUTFBytes(rawData.length);
			var levelData:XML = new XML(dataString);
			
			loadElements(levelData);
			loadTiles(levelData);
			loadWalkmesh(levelData);
		}
		
		private function loadElements(levelData:XML):void
		{
			var dataList:XMLList;
			var dataElement:XML;
			
			// Player
			dataList = levelData.Objects.Hero;
			for each(dataElement in dataList)
			{
				playerPos = new Point(dataElement.@x, dataElement.@y);
			}
			
			// Fireplace
			dataList = levelData.Objects.Shrine;
			for each(dataElement in dataList)
			{
				fireplacePos = new Point(dataElement.@x, dataElement.@y);
			}
			
			// Ghosts
			ghostsPos = new Array();
			dataList = levelData.Objects.Ghost;
			for each(dataElement in dataList)
			{
				ghostsPos.push(new Point(dataElement.@x, dataElement.@y));
			}
		}
		
		private function loadTiles(levelData:XML):void
		{
			var dataList:XMLList;
			var dataElement:XML;
			
			// Walls
			wallsPos = new Array();
			dataList = levelData.TilesWall.tile;
			for each(dataElement in dataList)
			{
				wallsPos.push(new Point(dataElement.@x * Assets.TileW, dataElement.@y * Assets.TileH));
			}
		}
		
		private function loadWalkmesh(levelData:XML):void
		{
			var bitstring:String = levelData.Walkmesh[0];
			walkmesh = new Walkmesh(bitstring);
		}
	}

}