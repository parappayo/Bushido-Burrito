using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

using Microsoft.Xna.Framework;

namespace Tango_Uniform
{
    /// <summary>
    /// This is the "model" part of the model-view-controller design.  It encapsulates everything used to model the
    /// game world, including everything needed by RenderMan to render a frame.
    /// </summary>
    public class GameWorld : Microsoft.Xna.Framework.GameComponent
    {
        MapData mapData;
        UnitData unitData;

        public GameWorld(Game game)
            : base(game)
        {
            mapData = new MapData();
            unitData = new UnitData();
        }

        public MapData MapData
        {
            get { return mapData; }
        }

        public UnitData UnitData
        {
            get { return unitData; }
        }

        override public void Update(GameTime gameTime)
        {
            // TODO: run game rules and AI routines here

            base.Update(gameTime);
        }
    }
}
