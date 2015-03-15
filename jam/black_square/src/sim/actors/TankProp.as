package sim.actors 
{
	import starling.display.Image;
	
	public class TankProp extends Prop
	{
		
		public function TankProp() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("tank_prop"));
			addChild(img);
		}
		
	} // class

} // package
