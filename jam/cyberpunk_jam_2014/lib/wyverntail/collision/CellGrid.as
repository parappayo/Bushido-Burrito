//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.collision 
{
	public class CellGrid implements Collidable
	{
		private var _data :Object;
		private var _gridWidth :int;
		private var _cellWidth :Number;
		private var _cellHeight :Number;
		
		public function CellGrid(gridWidth :int, cellWidth :Number, cellHeight :Number) 
		{
			_data = new Object();
			_gridWidth = gridWidth + 1; // +1 is a hack because there are newlines in the bitstring
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
		}
		
		public function addData(bitstring :String, obstacleChar :String = "1") :void
		{
			for (var i :int = 0; i < bitstring.length; i++)
			{
				var char :String = bitstring.charAt(i);
				if (char != obstacleChar) { continue; }
				
				var x :int = i % _gridWidth;
				var y :int = i / _gridWidth;
				_data[y * _gridWidth + x] = true;
			}
		}

		public function addDataChunk(bitstring :String, startCellX :int, startCellY :int, chunkWidth :int) :void
		{
			for (var i :int = 0; i < bitstring.length; i++)
			{
				var char :String = bitstring.charAt(i);
				if (char != "1") { continue; }
				
				var x :int = startCellX + (i % chunkWidth);
				var y :int = startCellY + (i / chunkWidth);
				_data[y * _gridWidth + x] = true;
			}
		}

		public function setCell(x :Number, y :Number, collides :Boolean = true) :void
		{
			_data[y * _gridWidth + x] = collides;
		}

		public function getCell(x :Number, y :Number) :Boolean
		{
			return _data[y * _gridWidth + x];
		}

		public function setCollides(worldX :Number, worldY :Number, collides :Boolean = true) :void
		{
			_data[getCellIndex(worldX, worldY)] = collides;
		}
		
		public function collides(worldX :Number, worldY :Number) :Boolean
		{
			return _data[getCellIndex(worldX, worldY)];
		}

		private function getCellIndex(worldX :Number, worldY :Number) :int
		{
			var cellX :int = worldX / _cellWidth;
			var cellY :int = worldY / _cellHeight;
			return cellY * _gridWidth + cellX;
		}

	} // class

} // package

