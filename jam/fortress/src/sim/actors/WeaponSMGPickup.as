package sim.actors 
{
	import starling.display.Image;
	import resources.*;
	
	public class WeaponSMGPickup extends Prop
	{
		private var _triggered :Boolean;
		private var _img :Image;

		public function WeaponSMGPickup() 
		{
			_img = new Image(Atlases.ElementsTextures.getTexture("smg"));
			addChild(_img);
			
			_triggered = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (!_triggered && playerDistance < Settings.TileW / 2)
			{
				_triggered = true;
				
				removeChild(_img);
			}
		}
		
	} // class

} // package
