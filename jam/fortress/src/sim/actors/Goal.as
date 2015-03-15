package sim.actors 
{
	import Settings;
	import resources.Atlases;
	import sim.components.Actions;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class Goal extends Prop
	{
		private var _canPickUp :Boolean;
		
		public function Goal() 
		{
			var img :Image = new Image(Atlases.ElementsTextures.getTexture("teddy"));
			addChild(img);
			
			// debug
			//var quad :Quad = new Quad(32, 32, 0xff0000);
			//addChild(quad);
			
			_canPickUp = true;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_canPickUp &&
				game.getPlayer().worldPosition.distance(worldPosition) < Settings.TileW)
			{
				game.getPlayer().handleSignal(game, Signals.ACTION_EXECUTE, Actions.CHEER);
			}
		}
		
	} // class

} // package
