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
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_cellgrid = prefabArgs.cellgrid;
			
			_cellgrid.setCollides(_pos.worldX, _pos.worldY);
		}
		
	} // class

} // package
