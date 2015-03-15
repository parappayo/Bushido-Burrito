package sim.actors 
{
	import starling.display.Image;
	
	public class Truck extends Prop
	{
		
		public function Truck() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("truck"));
			addChild(img);
		}
		
	} // class

} // package