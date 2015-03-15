package sim.actors 
{
	import sim.Settings;
	import starling.display.Image;
	
	public class WeaponSMGPickup extends Prop
	{
		private var _triggered :Boolean;
		private var _img :Image;

		public function WeaponSMGPickup() 
		{
			_img = new Image(Assets.ElementsTextures.getTexture("smg"));
			addChild(_img);
			
			_triggered = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (!_triggered && playerDistance < Settings.TileW / 2)
			{
				game.getPlayer().equipSMG();

				_triggered = true;
				SoundPlayer.play(Audio.pickupWeapon, Audio.VOLUME_SFX_LOUD);
				
				removeChild(_img);
			}
		}
		
	} // class

} // package
