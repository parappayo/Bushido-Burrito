//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core 
{
	import starling.display.DisplayObject;
	
	public class Camera extends Component
	{
		private var _pos :Position2D;
		private var _target :DisplayObject;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			
			_target = spawnArgs.target;
		}
		
		override public function update(elapsed :Number) :void
		{
			_target.x = (-_pos.worldX + Settings.ScreenWidth * 0.5) * Settings.ScreenScaleX;
			_target.y = (-_pos.worldY + Settings.ScreenHeight * 0.5) * Settings.ScreenScaleY;
		}
		
		public function get worldX() :Number { return _pos.worldX; }
		public function get worldY() :Number { return _pos.worldY; }
		public function set worldX(value :Number) :void { _pos.worldX = value; }
		public function set worldY(value :Number) :void { _pos.worldY = value; }

	} // class

} // package
