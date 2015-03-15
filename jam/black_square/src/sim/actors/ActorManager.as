package sim.actors 
{
	import sim.WorldOrientation;
	import sim.WorldPosition;
	public class ActorManager implements Actor
	{
		private var knownActors :Vector.<Actor>;

		public function ActorManager() 
		{
			knownActors = new Vector.<Actor>();
		}
		
		public function clear() :void
		{
			knownActors.length = 0;
		}
		
		public function add(actor :Actor) :void
		{
			// TODO: check for duplicates in debug
			knownActors.push(actor);
		}
		
		public function remove(actor :Actor) :void
		{
			for (var i:int = 0; i < knownActors.length; i++)
			{
				if (knownActors[i] == actor)
				{
					knownActors.splice(i, 1);
					break;
				}
			}
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			for each (var a :Actor in knownActors)
			{
				a.update(game, elapsed);
			}
		}

		public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			for each (var a :Actor in knownActors)
			{
				a.handleSignal(game, signal, args);
			}
		}
		
		public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			for each (var a :Actor in knownActors)
			{
				if (a.checkCollision(game, pos, ignore))
				{
					return true;
				}
			}
			return false;
		}
		
		public function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void
		{
			for each (var a :Actor in knownActors)
			{
				a.checkExplosion(game, pos, radius);
			}
		}
		
		public function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void
		{
			for each (var a :Actor in knownActors)
			{
				a.checkPush(game, pos, dir);
			}			
		}
		
		public function isDead() :Boolean
		{
			return false;
		}
	}
}
