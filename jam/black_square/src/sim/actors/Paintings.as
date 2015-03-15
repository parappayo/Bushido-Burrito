package sim.actors 
{
	import starling.display.Image;
	public class Paintings extends Prop
	{
		public function Paintings() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("artcrate"));
			addChild(img);
		}	
	} // class
} // package