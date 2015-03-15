package actors
{
	import starling.core.Starling;
	import starling.display.Stage;
	
	public class GhostManager 
	{
		private var ghosts :Vector.<Ghost>;
		private const textures :Array = ["ghostRed", "ghostGreen", "ghostPurple"];
		private var textureIndex : Number;
		
		/// how close the ghost needs to get to the player to kill
		private const catchDistance:Number = 30;
		
		public function GhostManager() 
		{
			ghosts = new Vector.<Ghost>();
			textureIndex = 0;
		}
		
		public function update(game:Game):void
		{	
			if (isPlayerCaught(game))
			{
				game.player.kill();
			}
		}
		
		public function spawn():Ghost
		{
			if (textureIndex == textures.length) textureIndex = 0;
			var ghost :Ghost = new Ghost(textures[textureIndex++]);
			ghosts.push(ghost);
			return ghost;
		}
		
		public function spawnAtPos(x:Number, y:Number, game:Game, actorManager:ActorManager):Ghost
		{
			var ghost :Ghost = spawn();
			ghost.worldPos.x = x;
			ghost.worldPos.y = y;
			game.addChild(ghost);
			actorManager.register(ghost);
			return ghost;
		}
		
		public function clear(actorManager:ActorManager):void
		{
			for each (var ghost:Ghost in ghosts)
			{
				actorManager.unregister(ghost);
				ghost.removeFromParent(true);
			}
			ghosts.splice(0, ghosts.length);
		}
		
		public function calculateHeartRate(game:Game):Number
		{
			// look at heart rate stats here: http://en.wikipedia.org/wiki/Heart_rate
			const normalHeartRate:Number = 50;  // beats per minute
			const addHeartRatePerGhost:Number = 15;
			
			var heartRate :Number = normalHeartRate;
			
			for each (var ghost:Ghost in ghosts)
			{
				if (ghost.isChasing())
				{
					heartRate += addHeartRatePerGhost;
				}
			}
			
			return heartRate;
		}
		
		public function areGhostsDead():Boolean
		{
			for each (var g:Ghost in ghosts)
			{
				if (!g.isDead()) { return false; }
			}
			return true;
		}
		
		public function isPlayerCaught(game:Game):Boolean
		{
			for each (var g:Ghost in ghosts)
			{
				if (g.isDead()) { continue; }
				
				if (g.worldPos.distance(game.player.worldPos) < catchDistance)
				{
					return true;
				}
			}
			return false;			
		}
	}

}
