package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	
	public class SpriteActor extends Sprite implements Actor, CameraPositionable
	{
		public var worldPosition :WorldPosition;
		public var worldInteract :WorldPosition;
		public var worldOrientation :WorldOrientation;
		public var worldOrientationTarget :WorldOrientation;
		
		public function SpriteActor() 
		{
			worldPosition = new WorldPosition();
			worldInteract = new WorldPosition();
			worldOrientation = new WorldOrientation();
			worldOrientationTarget = new WorldOrientation();
		}
		
		/// override in child class
		public function update(game :Game, elapsed :Number) :void {}
		
		/// override in child class
		public function handleSignal(game :Game, signal :int, args :Object) :void {}
		
		/// override in child class
		public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean { return false; }

		/// override in child class
		public function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void { }
		
		/// override in child class
		public function isDead() :Boolean { return false; }
		
		/// override in child class
		public function isCarrying() :Boolean { return false; }
		
		/// CameraPositionable interface
		public function getWorldPosition() :WorldPosition
		{
			return worldPosition;
		}
		public function getWorldInteract() :WorldPosition
		{
			worldInteract.setValues(worldPosition.x + width / 2, worldPosition.y + height * 0.8);
			return worldInteract;
		}
		
		/// CameraPositionable interface
		public function setStagePosition(x :int, y :int) :void
		{
			this.x = x;
			this.y = y;
		}
	}
}