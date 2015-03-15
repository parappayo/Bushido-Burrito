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
	
	public interface TileData 
	{
		// in tiles
		function get width() :int;
		function get height() :int;
		
		function getTileTexture(x :int, y :int) :Image;
	}
	
} // package
