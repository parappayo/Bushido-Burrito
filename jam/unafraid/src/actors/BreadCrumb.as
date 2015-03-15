package actors 
{
	/**
	 *  Pathfinding logic, for the ghosts to trail the player.
	 */
	public class BreadCrumb
	{
		public var worldPostion:Vector2D;
		
		public function BreadCrumb(x:Number, y:Number)
		{
			worldPostion = new Vector2D();
			worldPostion.x = x;
			worldPostion.y = y;
		}
		
	}

}