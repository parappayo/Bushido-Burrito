package sim 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import resources.Atlases;
	
	public class BackgroundTiles extends Sprite implements CameraPositionable
	{
		public static const TILE_FLOOR		:int = 1;
		public static const TILE_WALL		:int = 3;
		
		private var tileData :Vector.<int>;
		private var worldPosition :WorldPosition;
		private var tileImages :Sprite;
		private var quadBatch :QuadBatch;
		
		public var levelWidth :int;
		public var levelHeight :int;
		
		public static const INIT_SIZE :int = 2048 * 2048;
		
		public function BackgroundTiles()
		{
			tileData = new Vector.<int>(INIT_SIZE);
			worldPosition = new WorldPosition();
			
			tileImages = new Sprite();
			addChild(tileImages);
					
			// useful for debugging
			quadBatch = new QuadBatch();
			addChild(quadBatch);
			
			levelWidth = 1;
			levelHeight = 1;
		}
		
		public function clear() :void
		{
			for (var i :int = 0; i < tileData.length; i++)
			{
				tileData[i] = 0;
			}
			
			//worldPosition = new WorldPosition();
			
			tileImages.removeChildren();
			quadBatch.reset();
		}
		
		public function setData(data :XMLList) :void
		{
			for each (var tileXML :XML in data)
			{
				setTile(tileXML.@x, tileXML.@y, tileXML.@id);
			}
			
			refresh();
		}
		
		private function setTile(x :int, y :int, tile :int) :void
		{
			var i :int = y * levelWidth + x;
			tileData[i] = tile + 1;
		}
		
		private function refresh() :void
		{
			tileImages.removeChildren();
			quadBatch.reset();
			
			var tileImg :Image;
			var greyQuad :Quad = new Quad(Settings.TileSize, Settings.TileSize, 0x808080);
			
			for (var i :int = 0; i < tileData.length; i++)
			{
				var x :int = i % levelWidth;
				var y :int = i / levelWidth;
				
				var tile :int = tileData[i];
				
				if (tile == 0) { continue; }
				
				if (tile == TILE_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile1"));
					
					tileImg.x = x * Settings.TileSize;
					tileImg.y = y * Settings.TileSize;
					tileImages.addChild(tileImg);
				}
				else if (tile == TILE_WALL)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallunit1"));
					
					tileImg.x = x * Settings.TileSize;
					tileImg.y = y * Settings.TileSize;
					tileImages.addChild(tileImg);
				}
				else // default
				{
					// disabling this lets the multi-tile entries work :)
				}
			}
			
			tileImages.flatten();			
			flatten();
		}

		/// CameraPositionable interface
		public function getWorldPosition() :WorldPosition
		{
			return worldPosition;
		}
		
		/// CameraPositionable interface
		public function setStagePosition(x :int, y :int) :void
		{
			this.x = x;
			this.y = y;
		}		
	}

}