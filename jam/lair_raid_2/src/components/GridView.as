package components 
{
	import starling.display.Quad;
	import starling.display.QuadBatch;

	import wyverntail.core.*;

	public class GridView extends Component
	{
		private var _quadBatch :QuadBatch;
		
		public function get visible() :Boolean { return _quadBatch.visible; }
		public function set visible(value :Boolean) :void { _quadBatch.visible = value; }
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_quadBatch = new QuadBatch();
			_quadBatch.visible = false;
			_quadBatch.pivotX = Settings.TileWidth * 0.5;
			_quadBatch.pivotY = Settings.TileHeight * 0.5;
			prefabArgs.parentSprite.addChild(_quadBatch);

			for (var y :Number = 0; y < Settings.ScreenHeight; y += Settings.TileHeight)
			{
				for (var x :Number = 0; x < Settings.ScreenWidth; x += Settings.TileWidth)
				{
					// ugh
					var tileX :int = x / Settings.TileWidth;
					var tileY :int = y / Settings.TileHeight;
					
					var gridTile :Quad = new Quad(Settings.TileWidth, Settings.TileHeight, 0xffffff);
					gridTile.x = x;
					gridTile.y = y;
					gridTile.alpha = (tileX + tileY) % 2 == 0 ? 0.1 : 0.0;
					_quadBatch.addQuad(gridTile);
				}
			}
		}
		
	} // class

} // package
