package sim 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	
	public class BackgroundTiles extends Sprite implements CameraPositionable
	{
		public static const TILE_BRICK_FLOOR		:int = 1;
		public static const TILE_COBBLE_FLOOR		:int = 2;
		public static const TILE_ROUGH_FLOOR		:int = 3;
		public static const TILE_SLICK_FLOOR		:int = 4;
		public static const TILE_SLICK2_FLOOR		:int = 5;
		public static const TILE_STAIRS_DOWN		:int = 6;
		public static const TILE_STAIRS_UP			:int = 7;
		public static const TILE_WALL1				:int = 9;
		public static const TILE_WALL2				:int = 11;
		public static const TILE_WALL3				:int = 13;
		public static const TILE_CRATE_WALL			:int = 15;
		public static const TILE_BUTTON_PANEL		:int = 16;
		public static const TILE_ZELDA_BLOCK		:int = 25;
		
		private var tileData :Vector.<int>;
		private var worldPosition :WorldPosition;
		private var tileImages :Sprite;
		private var quadBatch :QuadBatch;
		
		public var levelWidth :int;
		public var levelHeight :int;
		
		public static const INIT_SIZE :int = 128 * 128;
		
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
			
			flatten();
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
			var greyQuad :Quad = new Quad(Settings.TileW, Settings.TileH, 0x808080);
			//var brickFloorImg :Image = new Image(Assets.TilesTextures.getTexture("groundtile1"));
			
			for (var i :int = 0; i < tileData.length; i++)
			{
				var x :int = i % levelWidth;
				var y :int = i / levelWidth;
				
				var tile :int = tileData[i];
				
				if (tile == 0) { continue; }
				
				tileImg = null;
				
				if (tile == TILE_BRICK_FLOOR)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("groundtile1"));
				}
				else if (tile == TILE_COBBLE_FLOOR)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("groundtile2"));
				}
				else if (tile == TILE_ROUGH_FLOOR)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("groundtile3"));
				}
				else if (tile == TILE_SLICK_FLOOR)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("groundtile4"));
				}
				else if (tile == TILE_SLICK2_FLOOR)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("groundtile5"));
				}
				else if (tile == TILE_STAIRS_DOWN)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("stairs_down"));
				}
				else if (tile == TILE_STAIRS_UP)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("stairs_up"));
				}
				else if (tile == TILE_WALL1)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("walltile1"));
				}
				else if (tile == TILE_WALL2)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("walltile2"));
				}
				else if (tile == TILE_WALL3)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("walltile3"));
				}
				else if (tile == TILE_CRATE_WALL)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("wallunit1"));
				}
				else if (tile == TILE_BUTTON_PANEL)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("wallunit2"));
				}
				else if (tile == TILE_ZELDA_BLOCK)
				{
					tileImg = new Image(Assets.TilesTextures.getTexture("wallunit3"));					
				}
				
				if (tileImg)
				{
					tileImg.x = x * Settings.TileW;
					tileImg.y = y * Settings.TileH;
					tileImg.scaleX = 1.01;
					tileImg.scaleY = 1.01;
					tileImages.addChild(tileImg);					
				}
				
				else // default
				{
					// disabling this lets the multi-tile entries work :)
					//greyQuad.x = x * Settings.TileW;
					//greyQuad.y = y * Settings.TileH;
					//quadBatch.addQuad(greyQuad);
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