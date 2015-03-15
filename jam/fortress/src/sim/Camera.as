package sim 
{
	public class Camera 
	{
		public var worldPosition :WorldPosition;
		
		public function Camera() 
		{
			worldPosition = new WorldPosition();
		}
		
		public function apply(target :CameraPositionable) :void
		{
			var targetWorldPos :WorldPosition = target.getWorldPosition();
			
			target.setStagePosition(
				targetWorldPos.x - this.worldPosition.x,
				targetWorldPos.y - this.worldPosition.y
				);
		}
		
	} // class

} // package
