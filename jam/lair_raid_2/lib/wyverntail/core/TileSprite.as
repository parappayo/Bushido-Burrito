//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core 
{
	import starling.display.Image;
	
	public class TileSprite extends Sprite
	{
		public function setTiles(data :TileData) :void
		{
			_sprite.removeChildren();
			
			for (var y :int = 0; y < data.height; ++y)
			{
				for (var x :int = 0; x < data.width; ++x)
				{
					var tex :Image = data.getTileTexture(x, y);
					if (tex)
					{
						_sprite.addChild(tex);
						
						tex.x = x * Settings.TileWidth;
						tex.y = y * Settings.TileHeight;
						tex.width = Settings.TileWidth;
						tex.height = Settings.TileHeight;
						tex.pivotX = Settings.TileWidth * 0.5;
						tex.pivotY = Settings.TileHeight * 0.5;
						
						// hacky tile gap correction
						tex.scaleX *= 1.04;
						tex.scaleY *= 1.04;
					}
				}
			}
			
			_sprite.flatten();
		}
		
	} // class

} // package
