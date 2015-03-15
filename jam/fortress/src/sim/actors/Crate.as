package sim.actors 
{
	import starling.display.Image;
	import resources.*;
	
	public class Crate extends Prop
	{
		
		public function Crate() 
		{
			var img :Image = new Image(Atlases.ElementsTextures.getTexture("crate"));
			addChild(img);
		}
		
	} // class

} // package
