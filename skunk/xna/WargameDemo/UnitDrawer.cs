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
    /// UnitDrawer is a visual game component that provides the on-screen presence for a UnitData data set.
    /// </summary>
    public class UnitDrawer : Microsoft.Xna.Framework.DrawableGameComponent
    {
        RenderMan mRenderMan;
        HexTileMap mHexTileMap;
        UnitData mUnitData;

        public UnitDrawer(Game game, UnitData data)
            : base(game)
        {
            mRenderMan = ((GameMain)game).RenderMan;
            mHexTileMap = ((GameMain)game).HexTileMap;
            mUnitData = data;
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
            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            mRenderMan.PushWorldMatrix(mHexTileMap.MapSpaceToScreenSpace);
            for (int i = 0; i < mUnitData.Length; i++)
            {
                mRenderMan.RenderUnit.DrawUnit(mUnitData[i].Position, mUnitData[i].Type);
            }
            mRenderMan.PopWorldMatrix();

            base.Draw(gameTime);
        }
    }
}