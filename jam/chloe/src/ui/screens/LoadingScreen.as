package ui.screens 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class LoadingScreen extends Sprite
	{
		
		public function LoadingScreen()
		{
			var width :Number = 300;
			var height :Number = 150;
			
			var quad :Quad = new Quad(width, height, 0x8c8c8c);
			addChild(quad);
			
			var caption :TextField = new TextField(width, height, "Loading", "default", 24, 0xffffff);
			addChild(caption);

			this.x = (Settings.ScreenWidth - width) / 2;
			this.y = (Settings.ScreenHeight - height) / 2;
		}
		
	} // class

} // package
