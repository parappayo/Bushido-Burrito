//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.collision 
{
	import wyverntail.core.*;
	
	///
	///  Add this to your Entity to make it have a CellGrid collision
	///  presence. It will auto-set the given CellGrid to include its
	///  own position.
	///
	public class CellCollider extends Component
	{
		private var _pos :Position2D;
		private var _cellgrid :CellGrid;
		
		private var _oldWorldX :Number;
		private var _oldWorldY :Number;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_cellgrid = prefabArgs.cellgrid;
			
			_oldWorldX = _pos.worldX;
			_oldWorldY = _pos.worldY;
			_cellgrid.setCollides(_pos.worldX, _pos.worldY);
		}
		
		override public function update(elapsed :Number) :void
		{
			if (_pos.distanceSquared2f(_oldWorldX, _oldWorldY) > 0.01)
			{
				_cellgrid.setCollides(_oldWorldX, _oldWorldY, false);
				_oldWorldX = _pos.worldX;
				_oldWorldY = _pos.worldY;
				_cellgrid.setCollides(_pos.worldX, _pos.worldY);
			}
		}
		
		public function clear() :void
		{
			_cellgrid.setCollides(_oldWorldX, _oldWorldY, false);
		}
		
	} // class

} // package
