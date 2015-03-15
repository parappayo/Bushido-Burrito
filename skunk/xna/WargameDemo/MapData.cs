using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;

#if !XBOX
using LuaInterface;
#endif

namespace Tango_Uniform
{
    public class MapData
    {
        public enum TerrainType
        {
            None,
            Grass,
            Water,
            LightUrban,
            Urban,
            HeavyUrban,
            LightForest,
            Forest,
            HeavyForest,

            Size
        }

        protected TerrainType[] terrain;
        protected int width, height;

        public int Width
        {
            get { return width; }
            set { width = value; UpdateTerrainSize(); }
        }

        public int Height
        {
            get { return height; }
            set { height = value; UpdateTerrainSize(); }
        }

        public TerrainType this[HexTilePosition pos]
        {
            get
            {
                int i = pos.Y * Width + pos.X;
                if (i > terrain.Length) { return TerrainType.None; }
                return terrain[i];
            }
        }

        public MapData()
        {
            width = 0; height = 0;
            terrain = new TerrainType[1];
            terrain[0] = TerrainType.None;
        }

        protected void UpdateTerrainSize()
        {
            if (terrain.Length < width * height)
            {
                terrain = new TerrainType[width * height];
            }
        }

#if !XBOX
        public String FindId(LuaTable data)
        {
            foreach (DictionaryEntry datum in data)
            {
                if ((string)datum.Key == "id")
                {
                    return (string)datum.Value;
                }
            }
            return null;
        }
#endif

#if !XBOX
        public void AddData(LuaTable data)
        {
            // TODO: each time this gets called, we should create a new MapData object, initialize it, and add it to a list of all map data
            if (FindId(data) == "test")
            {
                Initialize(data);
            }
        }
#endif

#if !XBOX
        public void Initialize(LuaTable data)
        {
            LuaTable terrain = null;

            foreach (DictionaryEntry datum in data)
            {
                if ((string)datum.Key == "width")
                {
                    Width = Convert.ToInt32(datum.Value);
                }
                else if ((string)datum.Key == "height")
                {
                    Height = Convert.ToInt32(datum.Value);
                }
                else if ((string)datum.Key == "terrain")
                {
                    // save until after the other properties have been set
                    terrain = (LuaTable)datum.Value;
                }

                //Console.WriteLine("\t{0} -> {1}", datum.Key, datum.Value);
            }

            if (terrain != null)
            {
                InitTerrain(terrain);
            }
        }
#endif // !XBOX

#if !XBOX
        public void InitTerrain(LuaTable data)
        {
            int i = 0;
            foreach (DictionaryEntry datum in data)
            {
                terrain[i] = (TerrainType)Convert.ToInt32(datum.Value);
                i++;
            }
        }
#endif

        /// <summary>
        /// For testing purposes only.  Populates MapData with some data.
        /// </summary>
        public void InitializeTestData()
        {
            Width = 50;
            Height = 35;

            for (int i = 0; i < width * height; i++)
            {
                terrain[i] = (TerrainType)(i%(int)TerrainType.Size);
            }
        }

        /// <summary>
        /// Given a position in map space coordinates, returns the hex space coordinates of the nearest hex,
        /// </summary>
        public HexTilePosition NearestMapHex(Vector3 pos)
        {
            HexTilePosition retval = RenderHex.NearestMapHex(pos);
            retval.X = Math.Max(retval.X, 0);
            retval.Y = Math.Max(retval.Y, 0);
            retval.X = Math.Min(retval.X, Width-1);
            retval.Y = Math.Min(retval.Y, Height-1);
            return retval;
        }
    }
}
