//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	import starling.display.Sprite;
	import wyverntail.core.Factory;
	import wyverntail.core.Scene;

	public class EntityLayer extends Layer
	{
		public var entities :Vector.<Entity>;
		
		public function EntityLayer()
		{
			entities = new Vector.<Entity>();
			_type = Layer.LAYER_TYPE_ENTITIES;
		}
		
		public override function init(data :XML) :void
		{
			_name = data.name().localName;
			
			for each (var child :XML in data.children())
			{
				var e :Entity = new Entity();
				e.init(child);
				entities.push(e);
			}
		}
		
		public function spawn(scene :Scene, factory :Factory) :void
		{
			for each (var e :Entity in entities)
			{
				var spawnArgs :Object = { worldX : e.x, worldY : e.y };
				
				for (var i :Object in e.properties)
				{
					spawnArgs[i] = e.properties[i];
				}

				factory.spawn(scene, e.type, spawnArgs);
			}
		}
		
	} // class

} // package
