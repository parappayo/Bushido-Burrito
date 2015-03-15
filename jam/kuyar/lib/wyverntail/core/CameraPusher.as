//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core 
{
	import flash.geom.Rectangle;
	
	public class CameraPusher extends Component
	{
		private var _pos :Position2D;
		private var _camera :Camera;
		private var _deadzone :Rectangle
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_camera = prefabArgs.camera.getComponent(Camera) as Camera;
			_deadzone = prefabArgs.cameraPusherDeadzone;
			
			_camera.worldX = _pos.worldX;
			_camera.worldY = _pos.worldY;
		}
		
		override public function update(elapsed :Number) :void
		{
			var dx :Number = _pos.worldX - _camera.worldX;
			var dy :Number = _pos.worldY - _camera.worldY;
			
			if (dx < _deadzone.left)
			{
				_camera.worldX = _pos.worldX + _deadzone.right;
			}
			else if (dx > _deadzone.right)
			{
				_camera.worldX = _pos.worldX + _deadzone.left;
			}
			
			if (dy < _deadzone.top)
			{
				_camera.worldY = _pos.worldY + _deadzone.bottom;
			}
			else if (dy > _deadzone.bottom)
			{
				_camera.worldY = _pos.worldY + _deadzone.top;
			}
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.CENTER_CAMERA)
			{
				_camera.worldX = _pos.worldX;
				_camera.worldY = _pos.worldY;
			}
			return false;
		}
		
	} // class

} // package
