package ui.screens 
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import resources.Screens;
	
	public class LoadingScreen extends Sprite
	{
		
		public function LoadingScreen()
		{	
			var box :Image = new Image(Screens.loading_popupTexture);
			addChild(box);
		
			var width :Number = 300;
			var height :Number = 150;
			var caption :TextField = new TextField(width, height, "Loading", "fortress", 18, 0xffffff);
			addChild(caption);

			this.x = (Settings.ScreenWidth - width) / 2;
			this.y = (Settings.ScreenHeight - height) / 2;
		}
		
	} // class

} // package
