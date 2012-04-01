
using System;
using System.Drawing;
using System.Windows.Forms;

namespace BushidoBurrito
{
	public class TileMap : Panel
	{
		public TileMap()
		{
			this.DoubleBuffered = true;

			Palette = new TilePalette();
		}

		public TilePalette Palette;

		protected override void OnPaint(PaintEventArgs e)
		{
			base.OnPaint(e);
			Graphics g = e.Graphics;

			for (int i = 0; i < Palette.TileCount(); i++)
			{
				Image tile = Palette.GetTile(i);
				int x = (i % 16) * 40;
				int y = (i / 16) * 40;
				Point p = new Point(x, y);
				g.DrawImage(tile, p);
			}
		}
	}
}

