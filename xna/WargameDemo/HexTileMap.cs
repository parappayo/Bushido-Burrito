using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;
using Microsoft.Xna.Framework.Net;
using Microsoft.Xna.Framework.Storage;


namespace Tango_Uniform
{
    /// <summary>
    /// HexPosition is a Point-like struct representing the coordinates of a HexMapTile tile's
    /// position in map grid coordinates.
    /// </summary>
    public struct HexTilePosition
    {
        public int X, Y;

        public HexTilePosition(int x, int y)
        {
            X = x;
            Y = y;
        }
    }

    /// <summary>
    /// HexTileMap is a visual component representing tiles arranged in a staggered pattern, as if
    /// composed of equal-sided hexagons.
    /// </summary>
    public class HexTileMap : Microsoft.Xna.Framework.DrawableGameComponent
    {
        GameMain mGame;
        MapData mMapData;

        const float MaxMapZoom = 2.0f;
        const float MinMapZoom = 0.2f;

        Vector3 mMapViewPosition;
        /// <summary>
        /// position of the player's camera looking down at the map
        /// </summary>
        public Vector3 MapViewPosition
        {
            get { return mMapViewPosition; }
        }

        float mMapZoom;
        /// <summary>
        /// scale of the map zoom
        /// </summary>
        public float MapZoom
        {
            get { return mMapZoom; }
        }

        public HexTileMap(Game game, MapData mapData)
            : base(game)
        {
            mGame = (GameMain)game;
            mMapData = mapData;

            mMapViewPosition = new Vector3(0.0f, 0.0f, 0.0f);
            mMapZoom = 1.0f;

        }

        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        public override void Initialize()
        {
            base.Initialize();
        }

        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Update(GameTime gameTime)
        {
            float x, y, z;

            // map pan inputs
            x = GamePad.GetState(PlayerIndex.One).ThumbSticks.Right.X;
            y = GamePad.GetState(PlayerIndex.One).ThumbSticks.Right.Y;
            PanMap(new Vector2(x, y), gameTime);
            //Trace.Write(String.Format("thumbstick pan: {0}, {1}\n", x, y));

            // map zoom inputs
            z = GamePad.GetState(PlayerIndex.One).Triggers.Right;
            z -= GamePad.GetState(PlayerIndex.One).Triggers.Left;
            ZoomMap(z, gameTime);
            //Trace.Write(String.Format("trigger zoom: {0}\n", z));

            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            HexTilePosition hexPos;

            mGame.RenderMan.PushWorldMatrix(MapSpaceToScreenSpace);
            for (hexPos.X = 0; hexPos.X < mMapData.Width; hexPos.X++)
            {
                for (hexPos.Y = 0; hexPos.Y < mMapData.Height; hexPos.Y++)
                {
                    mGame.RenderMan.RenderHex.DrawHex(hexPos, mMapData[hexPos]);
                }
            }
            mGame.RenderMan.PopWorldMatrix();

            base.Draw(gameTime);
        }

        public Matrix MapSpaceToScreenSpace
        {
            get
            {
                Matrix retval = Matrix.CreateTranslation(MapViewPosition);
                retval *= Matrix.CreateScale(MapZoom);
                return retval;
            }
        }

        public Matrix ScreenSpaceToMapSpace
        {
            get
            {
                return Matrix.Invert(MapSpaceToScreenSpace);
            }
        }

        public void PanMap(Vector2 vector, GameTime time)
        {
            float scale = 0.5f * time.ElapsedGameTime.Milliseconds;
            scale *= 2.0f - (mMapZoom - MinMapZoom) / (MaxMapZoom - MinMapZoom);
            PanMap(new Vector3(-vector.X * scale, vector.Y * scale, 0.0f));
        }

        public void PanMap(Vector3 vector)
        {
            mMapViewPosition += vector;
        }

        public void ZoomMap(float zoom, GameTime time)
        {
            float scale = 0.005f * time.ElapsedGameTime.Milliseconds;
            mMapZoom += zoom * scale;
            mMapZoom = Math.Max(Math.Min(mMapZoom, MaxMapZoom), MinMapZoom);
            //Trace.Write(String.Format("map zoom: {0}\n", mapZoom));
        }
    }
}