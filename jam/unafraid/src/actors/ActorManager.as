package actors 
{
	public class ActorManager 
	{
		private var knownActors:Vector.<Actor>
		
		public function ActorManager() 
		{
			knownActors = new Vector.<Actor>();
		}
		
		public function update(game:Game):void
		{
			for each (var a:Actor in knownActors)
			{
				a.update(game);
				a.setPosition(a.worldPos.x - game.mainCamera.origin.x, a.worldPos.y - game.mainCamera.origin.y);
			}
		}
		
		public function register(actor:Actor):void
		{
			knownActors.push(actor);
		}
		
		public function unregister(actor:Actor):void
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
		
	}

}
