
using System;
using System.IO;
using System.Xml;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections;
using System.Collections.Generic;

namespace BushidoBurrito
{
	public class TilePalette
	{
		public TilePalette()
		{
			Tiles = new ArrayList();
		}

		public int TileCount()
		{
			return Tiles.Count;
		}

		public Bitmap GetTile(int i)
		{
			return (Bitmap) Tiles[i];
		}

		public void LoadFromXML(string xmlFilename, string paletteID)
		{
			XmlDocument doc = new XmlDocument();
			doc.Load(xmlFilename);
			XmlNodeList nodes = doc.GetElementsByTagName("TilePalette");

			XmlNode nodeMatch = null;
			foreach (XmlNode node in nodes)
			{
				if (node.Attributes["id"].Value == paletteID)
				{
					nodeMatch = node;
					break;
				}
			}

			if (nodeMatch == null)
			{
				// TODO: throw exception here
				return;
			}

			string filename = nodeMatch.Attributes["source"].Value;
			SourceImage = Image.FromFile(filename);

			TileWidth = int.Parse(nodeMatch.Attributes["tile_width"].Value);
			TileHeight = int.Parse(nodeMatch.Attributes["tile_height"].Value);

			RefreshTiles();
		}

		///
		///  if SourceImage, TileWidth, or TileHeight changes, this function
		///  should be called to recalculate the list of tiles (Tiles).
		///
		private void RefreshTiles()
		{
			int x = 0;
			int y = 0;
			Rectangle rect = new Rectangle();
			Bitmap bmp = new Bitmap(SourceImage);

			Tiles.Clear();

			while (y < bmp.Height)
			{
				x = 0;
				while (x < bmp.Width)
				{
					rect.X = x;
					rect.Y = y;
					rect.Width = TileWidth;
					rect.Height = TileHeight;

					Tiles.Add(bmp.Clone(rect, bmp.PixelFormat));

					x += TileWidth;
				}

				y += TileHeight;
			}
		}

		private Image SourceImage;
		private int TileWidth;
		private int TileHeight;
		private ArrayList Tiles;
	}
}

