package actors 
{	
	import starling.display.Sprite;
	public class Actor extends Sprite
	{
		/// location in world space, not screen space
		public var worldPos :Vector2D;
		
		public function Actor() 
		{
			worldPos = new Vector2D();
		}
		
		public function update(game:Game):void
		{
			// no default logic
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}
