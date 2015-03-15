package sim 
{
	public class WorldOrientation extends Vector2D 
	{
		public function WorldOrientation() 
		{
			super();
			x = 0;
			y = 1;
		}
		
		public function rotation() :Number
		{
			var rotation:Number = Math.acos(x);
			if (y < 0) rotation *= -1;
			return rotation;
		}
		
		public function rotate(angle :Number) :void
		{
			var s :Number = Math.sin(angle);
			var c :Number = Math.cos(angle);
			
			var newX :Number = x * c - y * s;
			var newY :Number = x * s + y * c;
			
			x = newX;
			y = newY;
		}
	}
}