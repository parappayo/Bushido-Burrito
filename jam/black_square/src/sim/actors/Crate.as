package sim.actors 
{
	import starling.display.Image;
	
	public class Crate extends Prop
	{
		
		public function Crate() 
		{
			var img :Image = new Image(Assets.ElementsTextures.getTexture("crate"));
			addChild(img);
		}
		
	} // class

} // package
