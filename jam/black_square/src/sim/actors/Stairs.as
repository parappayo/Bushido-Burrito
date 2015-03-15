package sim.actors 
{
	import sim.Settings;
	import starling.display.Image;
	
	// TODO: should rename this prop to "level exit"
	public class Stairs extends Prop
	{
		/// this is the level we transition to when the stairs are taken
		public var NextLevelName :String;
		public var NextSpawnPoint :String;
		
		public function Stairs()
		{
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (playerDistance < Settings.TileW / 2)
			{
				game.handleActorSignal(Signals.LEVEL_TRANSITION, this);
			}
		}
		
	} // class

} // package
