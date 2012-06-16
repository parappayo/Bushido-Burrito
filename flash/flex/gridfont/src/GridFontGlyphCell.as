package  
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Jason
	 */
	public class GridFontGlyphCell 
	{
		public var horizontalLine :Boolean;	// - along the top
		public var verticalLine :Boolean;	// | along the left
		public var forwardLine :Boolean;	// / through the middle
		public var backwardLine :Boolean;	// \ through the middle
		public var size :int;				// height and width of the cell
		
		public function GridFontGlyphCell() 
		{
			size = 20; // default
		}
		
		public function DrawTo(graphics :Graphics, pos_x :int, pos_y :int)
		{
			// TODO: linestyle settings should be configurable
			graphics.lineStyle(2, 0x000000);
			
			if (horizontalLine) {
				graphics.moveTo(pos_x, pos_y);
				graphics.lineTo(pos_x + size, pos_y);
			}

			if (verticalLine) {
				graphics.moveTo(pos_x, pos_y);
				graphics.lineTo(pos_x, pos_y + size);
			}

			if (forwardLine) {
				graphics.moveTo(pos_x, pos_y);
				graphics.lineTo(pos_x + size, pos_y + size);
			}
			
			if (backLine) {
				graphics.moveTo(pos_x + size, pos_y);
				graphics.lineTo(px, py + _cellSize);
			}
			
		}
	}
}
