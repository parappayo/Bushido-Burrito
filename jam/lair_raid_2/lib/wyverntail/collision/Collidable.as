//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.collision 
{
	public interface Collidable 
	{
		function collides(worldX :Number, worldY :Number) :Boolean;
	}

} // package
