package ui.screens 
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class LoadingScreen extends Sprite
	{
		public function LoadingScreen()
		{	
			var box :Image = new Image(Assets.LoadingScreenTexture);
			addChild(box);
		
			var width :Number = 300;
			var height :Number = 150;
			var caption :TextField = new TextField(width, height, "Loading", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			addChild(caption);

			this.x = (Settings.ScreenWidth - width) / 2;
			this.y = (Settings.ScreenHeight - height) / 2;
		}
		
	} // class

} // package
