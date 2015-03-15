package sim.actors 
{
	import sim.Settings;
	import sim.components.Actions;
	import starling.display.Image;
	
	public class BlackSquare extends Prop
	{
		private var _canPickUp :Boolean;
		
		public function BlackSquare() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("blacksquare"));
			addChild(img);
			
			_canPickUp = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_canPickUp &&
				game.getPlayer().worldPosition.distance(worldPosition) < Settings.TileW * 4)
			{
				game.getPlayer().handleSignal(game, Signals.ACTION_EXECUTE, Actions.CHEER);
			}
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			if (signal == Signals.STALIN_DIED)
			{
				_canPickUp = true;
			}
		}
		
	} // class

} // package
