//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	import flash.geom.Point;

	public class Position2D extends Component
	{
		protected var _position :Point;
		protected var _parent :Position2D;

		// if set, these define a valid range of values, inclusive
		// TODO: should be a Rectangle instead
		protected var _max :Point;
		protected var _min :Point;

		public function Position2D()
		{
			_position = new Point();
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			if (spawnArgs && spawnArgs.worldX) { worldX = spawnArgs.worldX; }
			if (spawnArgs && spawnArgs.worldY) { worldY = spawnArgs.worldY; }
		}
		
		public function get parent() :Position2D { return _parent; }
		public function set parent(value :Position2D) :void { _parent = value; }

		public function get worldX() :Number
		{
			return _position.x + (_parent == null ? 0 : _parent.worldX);
		}

		public function get worldY() :Number
		{
			return _position.y + (_parent == null ? 0 : _parent.worldY);
		}

		public function set worldX(value :Number) :void
		{
			localX = value - (_parent == null ? 0 : _parent.worldX);
		}

		public function set worldY(value :Number) :void
		{
			localY = value - (_parent == null ? 0 : _parent.worldY);
		}

		public function get localX() :Number { return _position.x; }
		public function get localY() :Number { return _position.y; }
		
		public function set localX(value :Number) :void
		{
			_position.x = value;
			
			if (_max)
			{
				_position.x = Math.min(_position.x, _max.x);
			}
			if (_min)
			{
				_position.x = Math.max(_position.x, _min.x);
			}
		}
		
		public function set localY(value :Number) :void
		{
			_position.y = value;

			if (_max)
			{
				_position.y = Math.min(_position.y, _max.y);
			}
			if (_min)
			{
				_position.y = Math.max(_position.y, _min.y);
			}
		}

		public function cloneLocalPosition() :Point { return _position.clone(); }
		
		public function setLimits(p1 :Point, p2 :Point) :void
		{
			if (!_max) { _max = new Point(); }
			if (!_min) { _min = new Point(); }
			
			_max.x = Math.max(p1.x, p2.x);
			_max.y = Math.max(p1.y, p2.y);
			_min.x = Math.min(p1.x, p2.x);
			_min.y = Math.min(p1.y, p2.y);
		}
		
		public function clearLimits() :void
		{
			_max = null;
			_min = null;
		}

		public function distanceSquared(pos :Position2D) :Number
		{
			return distanceSquared2f(pos.worldX, pos.worldY);
		}

		public function distanceSquared2f(worldX :Number, worldY :Number) :Number
		{
			const dx :Number = worldX - this.worldX;
			const dy :Number = worldY - this.worldY;
			return dx * dx + dy * dy;
		}

	} // class

} // package

