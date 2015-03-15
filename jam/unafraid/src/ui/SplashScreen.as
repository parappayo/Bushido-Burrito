package ui 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class SplashScreen extends Sprite
	{
		
		public function SplashScreen() 
		{
			var splashImg:Image = new Image(Assets.SplashScreenTexture);
			
			addChild(splashImg);
		}
		
	}

}
