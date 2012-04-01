
using System;
using System.Windows.Forms;

namespace BushidoBurrito
{
	public class MainForm : Form
	{
		public MainForm()
		{
			this.Width = 800;
			this.Height = 600;
			this.Text = "Tiled Map Demo";

			TileMap = new TileMap();
			TileMap.Dock = DockStyle.Fill;
			Controls.Add(TileMap);

			TileMap.Palette.LoadFromXML("palette.xml", "test");
		}

		// child components
		public TileMap TileMap;
	}
}

