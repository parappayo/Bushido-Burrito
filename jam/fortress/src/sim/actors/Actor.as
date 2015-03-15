package sim.actors 
{
	import sim.WorldOrientation;
	import sim.WorldPosition;
	public interface Actor 
	{
		function update(game :Game, elapsed :Number) :void;
		function handleSignal(game :Game, signal :int, args :Object) :void;
		function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean;
		function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void;
		function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void;
		function isDead() :Boolean;
	}
}
