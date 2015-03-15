//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	public class GridLayer extends Layer
	{
		public var bitstring :String;
		
		public function GridLayer() 
		{
			
		}
		
		override public function init(data :XML) :void
		{
			bitstring = data[0];
		}
		
	} // class

} // package
