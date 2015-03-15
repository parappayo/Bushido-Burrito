//
//	Wyvern Tail Project
//  Copyright 2014 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.ogmo 
{
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import wyverntail.core.TileData;
	
	public class TileLayer extends Layer implements TileData
	{
		public var tilesAtlas :TextureAtlas;

		// in tiles
		private var _width :int;
		private var _height :int;
		public function get width() :int { return _width; }
		public function get height() :int { return _height; }
		
		private var _tileData :Vector.<int>;

		public function TileLayer(levelWidth :int, levelHeight :int) 
		{
			_width = levelWidth / Settings.TileWidth;
			_height = levelHeight / Settings.TileHeight;
			
			_tileData = new Vector.<int>(_width * _height);			
		}
		
		override public function init(data :XML) :void
		{
			for each (var tileXML :XML in data.children())
			{
				setTile(int(tileXML.@x), int(tileXML.@y), tileXML.@id);
			}
		}

		private function setTile(x :int, y :int, tile :int) :void
		{
			var i :int = y * _width + x;
			_tileData[i] = tile;
		}

		public function getTileTexture(x :int, y :int) :Image
		{
			var i :int = y * _width + x;
			var textureName :String = "tile";
			
			if (_tileData[i] < 10)
			{
				textureName += "00" + _tileData[i];
			}
			else if (_tileData[i] < 100)
			{
				textureName += "0" + _tileData[i];
			}
			else
			{
				textureName += _tileData[i];
			}
			
			var tex :Texture = tilesAtlas.getTexture(textureName);
			if (!tex)
			{
				trace("unknown texture: " + textureName);
				return null;
			}
			return new Image(tex);
		}
		
	} // class

} // package
