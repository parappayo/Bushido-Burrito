package sim 
{
	public class Vector2D 
	{
		public var x :Number;
		public var y :Number;
		
		public function Vector2D() 
		{
			x = 0;
			y = 0;
		}
		
		public function copy(source :Vector2D):void
		{
			x = source.x;
			y = source.y;
		}
		
		public function setValues(x :Number, y :Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function length() :Number
		{
			return Math.sqrt( (x * x) + (y * y) );
		}
		
		public function distance(target :Vector2D) :Number
		{
			var x:Number = target.x - this.x;
			var y:Number = target.y - this.y;
			return Math.sqrt( (x * x) + (y * y) );			
		}
		
		public function boxCollide(target :Vector2D,
									width :Number = 32,
									height :Number = 32) :Boolean
		{
			return !(target.x < this.x - width) &&
				!(target.x > this.x) &&
				!(target.y < this.y - height) &&
				!(target.y > this.y);
		}
		
		public function dot(target :Vector2D) :Number
		{
			return (x*target.x + y*target.y)
		}
		
		public function normalize() :void
		{
			var len :Number = length();
			if (len > 0)
			{
				x /= len;
				y /= len;
			}
		}
		
		public function add(v :Vector2D) :void
		{
			x += v.x;
			y += v.y;
		}
		
		public function multiplyScalar(s :Number) :void
		{
			x *= s;
			y *= s;
		}
		
		public function lerp(target :Vector2D, factor :Number) :void
		{
			if (factor > 1) { factor = 1; }
			if (factor < 0) { factor = 0; }
			
			x = (x * (1 - factor)) + (target.x * factor);
			y = (y * (1 - factor)) + (target.y * factor);
		}
	}

} // package
