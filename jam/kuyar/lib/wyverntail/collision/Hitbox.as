//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.collision 
{
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import wyverntail.core.*;

	public class Hitbox extends Component implements Collidable
	{
		public var extents :Rectangle;
		public var useClipExtents :Boolean;
		
		protected var _pos :Position2D;
		protected var _clip :MovieClip;
		
		protected var _targetQuad :Quad;
		protected var _hitQuad :Quad;
		protected var _showDebug :Boolean;
		
		public function Hitbox() 
		{
			extents = new Rectangle();
			useClipExtents = false;
			_showDebug = false;
		}

		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(MovieClip) as MovieClip;
		}

		override public function update(elapsed :Number) :void
		{
			if (useClipExtents)
			{
				//extents.left = -_clip.pivotX;
				//extents.top = -_clip.pivotY;
				extents.left = -_clip.width;
				extents.top = -_clip.height;
				extents.width = _clip.width;
				extents.height = _clip.height;
			}
			
			if (_showDebug)
			{
				_targetQuad.width = hitRect.width;
				_targetQuad.height = hitRect.height;
				_targetQuad.x = hitRect.x;
				_targetQuad.y = hitRect.y;
			}
		}
		
		public function get hitRect() :Rectangle
		{
			var retval :Rectangle = extents ? extents.clone() : new Rectangle();

			if (!_pos) { return retval; }
			
			retval.x += _pos.worldX;
			retval.y += _pos.worldY;
			return retval;
		}
		
		public function get height() :Number { return extents.height; }
		public function get width() :Number { return extents.width; }
		
		public function collides(worldX :Number, worldY :Number) :Boolean
		{
			if (!_pos || !extents) { return false; }
			
			if (_hitQuad)
			{
				_hitQuad.visible = true;
				_hitQuad.x = worldX;
				_hitQuad.y = worldY;
			}
			
			return hitRect.contains(worldX, worldY);
		}
		
		public function set showDebug(value :Boolean) :void
		{
			if (_showDebug == value) { return; }
			_showDebug = value;
			
			if (_showDebug)
			{
				if (!_targetQuad)
				{
					_targetQuad = new Quad(10, 10, 0xff0000);
					_clip.addChild(_targetQuad);
				}
				if (!_hitQuad)
				{
					_hitQuad = new Quad(10, 10, 0x00ff00);
					_clip.addChild(_hitQuad);
				}
				
				_hitQuad.visible = false;
				
				_targetQuad.width = hitRect.width;
				_targetQuad.height = hitRect.height;
				_targetQuad.x = hitRect.x;
				_targetQuad.y = hitRect.y;
			}
			else
			{
				_targetQuad.removeFromParent();
				_hitQuad.removeFromParent();
			}
		}
		
	} // class

} // package
