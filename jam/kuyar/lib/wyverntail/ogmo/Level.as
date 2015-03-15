//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class Level 
	{
		public var width :int;
		public var height :int;
		public var properties :Dictionary;
		public var layers :Dictionary;
		
		private var _layerDefinitions :Dictionary;
		
		public function Level() 
		{
			properties = new Dictionary();
			layers = new Dictionary();
			_layerDefinitions = new Dictionary();
		}
		
		// expects type to be one of the consts defined in Layer.as
		public function defineLayer(name :String, type :int) :void
		{
			_layerDefinitions[name] = type;
		}
		
		public function init(data :Class) :void
		{
			// TODO: also take in the project XML here and read settings from that
			
			var rawData :ByteArray = new data();
			var dataString :String = rawData.readUTFBytes(rawData.length);
			var dataXML :XML = new XML(dataString);
			
			initFromXML(dataXML);
		}
		
		public function initFromXML(data :XML) :void
		{
			if (data.name().localName != "level")
			{
				throw new Error("unexpected XML format for level data");
			}
			
			width = data.@width;
			height = data.@height;
			
			for each (var attribute :XML in data.attributes())
			{
				var name :String = attribute.name().localName;
				if (name == "id" || name == "x" || name == "y") { continue; }
				properties[name] = attribute;
			}
			
			for each (var child :XML in data.children())
			{
				var layerName :String = child.name().localName;
				if (_layerDefinitions.hasOwnProperty(layerName))
				{
					addLayer(child, layerName, _layerDefinitions[layerName]);
				}
				else
				{
					throw new Error("level has undefined layer data");
				}
			}
		}
		
		private function addLayer(data :XML, name :String, type :int) :void
		{
			var layer :Layer;
			
			switch (type)
			{
				case Layer.LAYER_TYPE_GRID:			{ layer = new GridLayer(); } break;
				case Layer.LAYER_TYPE_TILES:		{ layer = new TileLayer(width, height); } break;
				case Layer.LAYER_TYPE_ENTITIES:		{ layer = new EntityLayer(); } break;
			}
			
			layer.init(data);
			layers[name] = layer;
		}
		
	} // class

} // package
