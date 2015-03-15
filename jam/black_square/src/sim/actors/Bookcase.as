package sim.actors 
{
	import starling.display.Image;
	public class Bookcase extends Prop
	{
		public function Bookcase() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("bookshelf"));
			addChild(img);
		}	
	} // class
} // package