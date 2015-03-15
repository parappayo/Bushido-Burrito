package  
{
	public class Vector2D 
	{
		public var x:Number;
		public var y:Number;
		
		public function Vector2D() 
		{
			x = 0;
			y = 0;
		}
		
		public function copy(source:Vector2D):void
		{
			x = source.x;
			y = source.y;
		}
		
		public function length():Number
		{
			return Math.sqrt( (x * x) + (y * y) );
		}
		
		public function distance(target:Vector2D):Number
		{
			var x:Number = target.x - this.x;
			var y:Number = target.y - this.y;
			return Math.sqrt( (x * x) + (y * y) );			
		}
		
		public function normalize():void
		{
			var len :Number = length();
			if (len > 0)
			{
				x /= len;
				y /= len;
			}
		}
		
		public function add(v:Vector2D):void
		{
			x += v.x;
			y += v.y;
		}
		
		public function multiplyScalar(s:Number):void
		{
			x *= s;
			y *= s;
		}
		
		public function blend(target:Vector2D, ratio:Number):void
		{
			if (ratio > 1) { ratio = 1; }
			if (ratio < 0) { ratio = 0; }
			
			x = (x * (1 - ratio)) + (target.x * ratio);
			y = (y * (1 - ratio)) + (target.y * ratio);
		}
	}

}