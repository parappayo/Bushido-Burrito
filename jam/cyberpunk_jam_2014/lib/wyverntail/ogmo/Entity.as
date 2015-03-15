//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	import flash.utils.Dictionary;
	
	public class Entity 
	{
		public var type :String;
		public var id :int;
		public var x :int;
		public var y :int;
		public var properties :Dictionary;
		
		public function Entity() 
		{
			properties = new Dictionary();
		}
		
		public function init(data :XML) :void
		{
			type = data.name().localName;
			id = data.@id;
			x = data.@x;
			y = data.@y;
			
			for each (var attribute :XML in data.attributes())
			{
				var name :String = attribute.name().localName;
				if (name == "id" || name == "x" || name == "y") { continue; }
				properties[name] = attribute.toString();
			}
		}
		
	} // class

} // package
