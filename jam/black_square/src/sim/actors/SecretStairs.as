package sim.actors 
{
	import sim.Settings;
	import starling.display.Image;
	
	// TODO: should rename this prop to "secret level exit"
	public class SecretStairs extends Prop
	{
		/// this is the level we transition to when the stairs are taken
		public var NextLevelName :String;
		public var NextSpawnPoint :String;
		
		private var _img :Image;
		private var _IsActive :Boolean;
		
		public function SecretStairs()
		{
			_img = new Image(Assets.TilesTextures.getTexture("stairs_down"));
			_IsActive = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (!_IsActive) { return; }
			
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (playerDistance < Settings.TileW / 2)
			{
				game.handleActorSignal(Signals.LEVEL_TRANSITION, this);
			}
		}

		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			if (signal == Signals.SECRET_PUSH_BLOCK_USED ||
				signal == Signals.STALIN_DIED)
			{
				_IsActive = true;
				addChild(_img); // show
			}
		}		
		
	} // class

} // package
