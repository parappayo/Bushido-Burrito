package 
{
	public class Camera 
	{
		/// the top-left corner of the current view, in screen coords
		public var origin:Vector2D;
		
		public var width:Number;
		public var height:Number;
		
		public function Camera() 
		{
			origin = new Vector2D();
			
			width = 1280;
			height = 720;
			origin.x = -1280 / 4;
			origin.y = -720 / 4;
		}
		
	}

}
