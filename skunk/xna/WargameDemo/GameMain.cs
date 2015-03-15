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

#if !XBOX
using LuaInterface;
#endif

namespace Tango_Uniform
{
    /// <summary>
    /// This is the main type for your game
    /// </summary>
    public class GameMain : Microsoft.Xna.Framework.Game
    {
        GraphicsDeviceManager graphics;

        public GameWorld GameWorld;
        public RenderMan RenderMan;
        public InputMan InputMan;

#if !XBOX
        public Lua LuaEngine;
#endif

        HexTileMap mHexTileMap;
        /// <summary>
        /// visual display of the game terrain
        /// </summary>
        public HexTileMap HexTileMap
        {
            get { return mHexTileMap; }
        }

        UserCursor mUserCursor;
        /// <summary>
        /// on-screen pointer used to select things
        /// </summary>
        public UserCursor UserCursor
        {
            get { return mUserCursor; }
        }

        UnitDrawer mUnitDrawer;

        public GameMain()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
        }

        public GraphicsDevice GameGraphicsDevice
        {
            get { return GraphicsDevice; }
        }

        /// <summary>
        /// Allows the game to perform any initialization it needs to before starting to run.
        /// This is where it can query for any required services and load any non-graphic
        /// related content.  Calling base.Initialize will enumerate through any components
        /// and initialize them as well.
        /// </summary>
        protected override void Initialize()
        {
            RenderMan = new RenderMan(this);  // provides rendering utils

            GameWorld = new GameWorld(this);  // holds game state
            InputMan = new InputMan(this, GameWorld);  // handles user input
            // process input events before updating game state
            Components.Add(InputMan);
            Components.Add(GameWorld);

            mHexTileMap = new HexTileMap(this, GameWorld.MapData);
            mUnitDrawer = new UnitDrawer(this, GameWorld.UnitData);

            mUserCursor = new UserCursor(this);
            mUserCursor.DrawUserCursor = DrawUserCursor;
            mUserCursor.PushBoundaryEvent += new EventHandler(mUserCursor_PushBoundaryEvent);
            mUserCursor.GamePadEnabled = true;
            mUserCursor.KeyboardEnabled = true;

            // order in which components are added determines draw order
            Components.Add(mHexTileMap);
            Components.Add(mUnitDrawer);
            Components.Add(mUserCursor);

#if !XBOX
            // process Lua scripts
            LuaEngine = new Lua();
            LuaEngine.RegisterFunction("MapData", GameWorld.MapData, GameWorld.MapData.GetType().GetMethod("AddData"));
            LuaEngine.DoFile("scripts/main.lua");
#endif

            base.Initialize();
        }

        void DrawUserCursor(UserCursor cursor)
        {
            Vector3 pos = Vector3.Transform(mUserCursor.Position, mHexTileMap.ScreenSpaceToMapSpace);
            HexTilePosition selectedHex = GameWorld.MapData.NearestMapHex(pos);
            Vector3 selectedHexPos = RenderHex.HexPositionToMapPosition(selectedHex);

            // render the map highlight underneath the cursor
            RenderMan.PushWorldMatrix(mHexTileMap.MapSpaceToScreenSpace);
                GraphicsDevice.RenderState.AlphaBlendEnable = true;
                GraphicsDevice.RenderState.SourceBlend = Blend.One;
                GraphicsDevice.RenderState.DestinationBlend = Blend.DestinationColor;
                RenderMan.RenderHex.DrawHex(selectedHexPos, Color.Gray);
                GraphicsDevice.RenderState.AlphaBlendEnable = false;
                RenderMan.RenderHex.DrawHexBorder(selectedHexPos, Color.Black);
            RenderMan.PopWorldMatrix();

            RenderMan.RenderQuad.DrawQuad(cursor.Position, Color.Magenta);
        }

        void mUserCursor_PushBoundaryEvent(object sender, EventArgs e)
        {
            HexTileMap.PanMap(((UserCursor.PushBoundaryEventArgs)e).PushDirection);
        }

        /// <summary>
        /// LoadContent will be called once per game and is the place to load all of your content.
        /// </summary>
        protected override void LoadContent()
        {
            RenderMan.Textures.LoadContent(Content);
        }

        /// <summary>
        /// UnloadContent will be called once per game and is the place to unload all content.
        /// </summary>
        protected override void UnloadContent()
        {
            // Unload any non ContentManager content here
        }

        /// <summary>
        /// Allows the game to run logic such as updating the world, checking for collisions, gathering input, and
        /// playing audio.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        /// <summary>
        /// This is called when the game should draw itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Draw(GameTime gameTime)
        {
            RenderMan.StartFrame();
            base.Draw(gameTime);
        }
    }
}
