package entities 
{
	import wyverntail.collision.Collidable;
	
	/**
	 *  Custom player collision logic for LD31 project
	 */
	public class PlayerCollider implements Collidable
	{
		public function collides(worldX :Number, worldY :Number) :Boolean
		{
			return worldY > 480 || worldY < 320 || worldX < 50 || worldX > Settings.ScreenWidth - 50;
		}
	} // class

} // package
