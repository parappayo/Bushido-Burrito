package actors 
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.display.BlendMode;
	
	/**
	 *  Not really an actor? Meh. :)
	 */
	public class Fog extends Sprite
	{
		private var canvas:Image;
		private var renderTexture:RenderTexture;
		private var darkQuad:Quad;
		private var mask:Image;
		
		public function Fog()
		{
			renderTexture = new RenderTexture(1290, 730);
			canvas = new Image(renderTexture);
			canvas.x = -5;
			canvas.y = -5;
			addChild(canvas);
			
			mask = new Image(Assets.FogMaskTexture);
			mask.pivotX = mask.width / 2;
			mask.pivotY = mask.height / 2;
			mask.blendMode = BlendMode.ERASE;
			
			darkQuad = new Quad(1290, 730, 0x000000);
			renderTexture.draw(darkQuad);
		}
		
		public function startFrame():void
		{
			renderTexture.clear();
			renderTexture.draw(darkQuad);
		}
		
		public function applyMask(x:Number, y:Number, scale:Number):void
		{
			mask.x = x;
			mask.y = y;
			mask.scaleX = scale;
			mask.scaleY = scale;
			renderTexture.draw(mask);
		}
	}

}