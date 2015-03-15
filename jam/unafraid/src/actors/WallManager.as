package actors 
{
	import starling.display.Image;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class WallManager extends Actor
	{
		// stores collision data
		private var walls:Vector.<Wall>;
		
		public function WallManager() 
		{
			walls = new Vector.<Wall>();
		}

		public function spawnAtPos(x:Number, y:Number):void
		{
			var wall:Wall = new Wall();
			wall.worldPosition.x = x;
			wall.worldPosition.y = y;
			walls.push(wall);
			
			var img:Image = new Image(Assets.TA.getTexture("wall"));
			img.pivotX = img.width * 0.5;
			img.pivotY = img.height * 0.5;
			img.x = x;
			img.y = y;
			addChild(img);
		}
		
		public function flattenInner():void
		{
			flatten();
		}
	}
}
