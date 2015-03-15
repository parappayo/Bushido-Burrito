package sim 
{
	public class WorldPosition extends Vector2D
	{
		public function WorldPosition() 
		{
			super();
		}
		
		public function CheckLOS(game :Game, pos :WorldPosition) :Boolean
		{
			var testPos :WorldPosition = new WorldPosition();
			
			var incremenetPixels :Number = Settings.TileW / 2;
			var numIncrements :Number = distance(pos) / incremenetPixels;
			var incremenetSize :Number = 1 / numIncrements;
			
			for (var i :Number = 0; i < 1; i += incremenetSize)
			{
				testPos.copy(this);
				testPos.lerp(pos, i)
				
				if (!game.getWalkmesh().isWalkable(testPos.x, testPos. y))
				{
					return false;
				}
			}
			
			return true;
		}
		
	} // class
	
} // package
