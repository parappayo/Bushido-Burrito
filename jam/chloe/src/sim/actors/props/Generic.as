package sim.actors.props 
{
	import sim.actors.Prop;
	import starling.display.Image;
	import resources.*;
	public class Generic extends Prop
	{
		private static var _interactCount:int = 1;
		
		public function Generic(imgName:String)
		{
			var img :Image = new Image(Atlases.PropsTextures.getTexture(imgName));
			addChild(img);
		}
		
		override public function onInteractStart():void
		{
			if (_interactCount % 2 == 0)
			{
				var curious:Array = [Audio.vo_chloe_angry_03, Audio.vo_chloe_curious_01, Audio.vo_chloe_bored_01];
				SoundPlayer.playRandom(curious, Settings.VolumeSfx - 0.1);
			}
			_interactCount++;
		}
		
		override public function onInteractStop():void 
		{
			var drops:Array = [Audio.Footstep_tile_dry_3, Audio.Footstep_tile_dry_4, Audio.Footstep_tile_dry_5];
			SoundPlayer.playRandom(drops, Settings.VolumeSfxLoud);
		}
		
		override public function canInteract():Boolean
		{
			return true;
		}
		override public function getInteractOffsetX():Number
		{
			return 10;
		}
		override public function getInteractOffsetY():Number
		{
			return -80;
		}
		override public function getInteractOffsetDrop():Number
		{
			return -40 + 2;
		}		
	} // class
} // package