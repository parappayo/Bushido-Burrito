package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	
	public class SpriteActor extends Sprite implements Actor, CameraPositionable
	{
		public var worldPosition :WorldPosition;
		public var worldOrientation :WorldOrientation;
		public var worldOrientationTarget :WorldOrientation;
		public var worldOrientationAim :WorldOrientation;
		
		public function SpriteActor() 
		{
			worldPosition = new WorldPosition();
			worldOrientation = new WorldOrientation();
			worldOrientationTarget = new WorldOrientation();
			worldOrientationAim = new WorldOrientation();
			touchable = false;
		}
		
		/// override in child class
		public function lock() :void {}
		
		/// override in child class
		public function unlock() :void {}
		
		/// override in child class
		public function update(game :Game, elapsed :Number) :void {}
		
		/// override in child class
		public function handleSignal(game :Game, signal :int, args :Object) :void {}
		
		/// override in child class
		public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean { return false; }

		/// override in child class
		public function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void { }
		
		/// override in child class
		public function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void { }
		
		/// override in child class
		public function isDead() :Boolean { return false; }
		
		/// override in child class
		public function isStrafing() :Boolean { return false; }		
		
		/// CameraPositionable interface
		public function getWorldPosition() :WorldPosition
		{
			return worldPosition;
		}
		
		/// CameraPositionable interface
		public function setStagePosition(x :int, y :int) :void
		{
			this.x = x;
			this.y = y;
		}
	}
}
