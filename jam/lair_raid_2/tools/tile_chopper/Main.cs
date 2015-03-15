using System;
using System.Drawing;

namespace tile_chopper
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Bitmap bitmap = new Bitmap(args[0]);

			int tileWidth = 16;
			int tileHeight = 16;
			
			for (int y = 0; y < bitmap.Height / tileHeight; ++y)
			{
				for (int x = 0; x < bitmap.Width / tileWidth; ++x)
				{
					Rectangle r = new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
					Console.WriteLine(r);
					Bitmap tileBmp = bitmap.Clone(r, bitmap.PixelFormat);
					
					int i = y * (bitmap.Width / tileWidth) + x;
					string filename = string.Format("tile{0}.png", i.ToString("000"));
					Console.WriteLine(filename);
					tileBmp.Save(filename);
				}
			}
		}
	}
}
