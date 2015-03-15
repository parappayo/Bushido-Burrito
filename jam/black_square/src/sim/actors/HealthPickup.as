package sim.actors 
{
	import sim.Settings;
	import starling.display.Image;
	
	public class HealthPickup extends Prop
	{
		private var _triggered :Boolean;
		private var _img :Image;
		
		public function HealthPickup()
		{
			_img = new Image(Assets.ElementsTextures.getTexture("firstaid"));
			addChild(_img);
			
			_triggered = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (!_triggered && playerDistance < Settings.TileW / 2 &&
				!game.getPlayer().isFullHealth())
			{
				game.getPlayer().heal();

				_triggered = true;
				SoundPlayer.play(Audio.pickupHealth, Audio.VOLUME_SFX_LOUD);
				
				removeChild(_img);
			}
		}
		
	} // class

} // package

