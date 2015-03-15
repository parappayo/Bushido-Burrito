package sim.actors 
{
	import starling.display.Image;
	public class Statue extends Prop
	{
		public function Statue() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("statue"));
			addChild(img);
		}	
	} // class
} // package