package sim 
{
	public interface CameraPositionable
	{
		function getWorldPosition() :WorldPosition;
		function setStagePosition(x :int, y :int) :void;		
	}
}
