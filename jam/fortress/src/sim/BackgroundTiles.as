package sim 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import resources.*;
	
	public class BackgroundTiles extends Sprite implements CameraPositionable
	{
		public static const TILE_COBBLE2_FLOOR		:int = 1;
		public static const TILE_STONE1_FLOOR		:int = 2;
		public static const TILE_STONE2_FLOOR		:int = 3;
		public static const TILE_BRICK_FLOOR		:int = 4;
		public static const TILE_COBBLE_FLOOR		:int = 5;
		public static const TILE_ROUGH_FLOOR		:int = 6;
		public static const TILE_SLICK_FLOOR		:int = 7;
		public static const TILE_SLICK2_FLOOR		:int = 8;
		public static const TILE_SMOOTH_TILE_FLOOR	:int = 9;
		public static const TILE_WALLBRICK_BOTTOM_CORNERLEFT	:int = 10;
		public static const TILE_WALLBRICK_BOTTOM_CORNERRIGHT	:int = 11;
		public static const TILE_WALLBRICK_BOTTOM_MID			:int = 12;
		public static const TILE_FIREPLACE			:int = 13;
		public static const TILE_WALLBRICK_LEFT_CORNER		:int = 14;
		public static const TILE_WALLBRICK_LEFT_MID			:int = 15;
		public static const TILE_WALLBRICK_LEFT_TOPLEFT		:int = 16;
		public static const TILE_WALLBRICK_RIGHT_CORNER		:int = 17;
		public static const TILE_WALLBRICK_RIGHT_MID		:int = 18;
		public static const TILE_WALLBRICK_RIGHT_TOPLEFT	:int = 19;
		public static const TILE_WALL1				:int = 20;
		public static const TILE_WALL2				:int = 21;
		public static const TILE_WALL3				:int = 22;
		public static const TILE_WALL4				:int = 23;
		public static const TILE_WALL5				:int = 24;
		public static const TILE_WALL6				:int = 25;
		public static const TILE_CRATE_WALL			:int = 26;
		public static const TILE_BUTTON_PANEL		:int = 27;
		public static const TILE_ZELDA_BLOCK		:int = 28;
//		public static const TILE_STAIRS_DOWN		:int = 0;
//		public static const TILE_STAIRS_UP			:int = 0;
		
		private var tileData :Vector.<int>;
		private var worldPosition :WorldPosition;
		private var tileImages :Sprite;
		private var quadBatch :QuadBatch;
		
		public var levelWidth :int;
		public var levelHeight :int;
		
		public static const INIT_SIZE :int = Settings.MaxLevelWidth * Settings.MaxLevelHeight;
		
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
			touchable = false;
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
		
		/// changes won't be reflected until refresh() is called
		public function setData(data :XMLList, cellX :int, cellY :int) :void
		{
			for each (var tileXML :XML in data)
			{
				setTile(int(tileXML.@x) + cellX, int(tileXML.@y) + cellY, tileXML.@id);
			}
		}
		
		private function setTile(x :int, y :int, tile :int) :void
		{
			var i :int = y * levelWidth + x;
			tileData[i] = tile + 1;
		}
		
		public function refresh() :void
		{
			tileImages.removeChildren();
			quadBatch.reset();
			
			var tileImg :Image;
			var greyQuad :Quad = new Quad(Settings.TileW, Settings.TileH, 0x808080);
			
			for (var i :int = 0; i < tileData.length; i++)
			{
				var x :int = i % levelWidth;
				var y :int = i / levelWidth;
				
				var tile :int = tileData[i];
				
				if (tile == 0) { continue; }
				
				tileImg = null;
				
				if (tile == TILE_BRICK_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile1"));
				}
				else if (tile == TILE_COBBLE_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile2"));
				}
				else if (tile == TILE_COBBLE2_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("floor_bricks"));
				}
				else if (tile == TILE_ROUGH_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile3"));
				}
				else if (tile == TILE_SLICK_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile4"));
				}
				else if (tile == TILE_SLICK2_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("groundtile5"));
				}
				else if (tile == TILE_SMOOTH_TILE_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("smooth_tile"));
				}
//				else if (tile == TILE_STAIRS_DOWN)
//				{
//					tileImg = new Image(Atlases.TilesTextures.getTexture("stairs_down"));
//				}
//				else if (tile == TILE_STAIRS_UP)
//				{
//					tileImg = new Image(Atlases.TilesTextures.getTexture("stairs_up"));
//				}
				else if (tile == TILE_WALL1)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_top_left"));
				}
				else if (tile == TILE_WALL2)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_top_mid"));
				}
				else if (tile == TILE_WALL3)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_top_right"));
				}
				else if (tile == TILE_CRATE_WALL)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallunit1"));
				}
				else if (tile == TILE_BUTTON_PANEL)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallunit2"));
				}
				else if (tile == TILE_ZELDA_BLOCK)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallunit3"));
				}
				else if (tile == TILE_STONE1_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("floortile1"));
				}
				else if (tile == TILE_STONE2_FLOOR)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("floortile2"));
				}
				else if (tile == TILE_WALLBRICK_BOTTOM_CORNERLEFT)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_bottom_cornerleft"));
				}
				else if (tile == TILE_WALLBRICK_BOTTOM_CORNERRIGHT)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_bottom_cornerright"));
				}
				else if (tile == TILE_WALLBRICK_BOTTOM_MID)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_bottom_mid"));
				}
				else if (tile == TILE_WALLBRICK_LEFT_CORNER)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_left_corner"));
				}
				else if (tile == TILE_WALLBRICK_LEFT_MID)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_left_mid"));
				}
				else if (tile == TILE_WALLBRICK_LEFT_TOPLEFT)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_left_topleft"));
				}
				else if (tile == TILE_WALLBRICK_RIGHT_CORNER)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_right_corner"));
				}
				else if (tile == TILE_WALLBRICK_RIGHT_MID)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_right_mid"));
				}
				else if (tile == TILE_WALLBRICK_RIGHT_TOPLEFT)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_right_topleft"));
				}
				else if (tile == TILE_FIREPLACE)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("wallbrick_door"));
				}
				else if (tile == TILE_WALL4)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("walltile1"));
				}
				else if (tile == TILE_WALL5)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("walltile2"));
				}
				else if (tile == TILE_WALL6)
				{
					tileImg = new Image(Atlases.TilesTextures.getTexture("walltile3"));
				}
				
				if (tileImg)
				{
					tileImg.x = x * Settings.TileW;
					tileImg.y = y * Settings.TileH;
					tileImg.width = Settings.TileW;
					tileImg.height = Settings.TileH;
					tileImg.scaleX *= 1;
					tileImg.scaleY *= 1;
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
