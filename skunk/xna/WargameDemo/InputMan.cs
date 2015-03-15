using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;

namespace Tango_Uniform
{
    /// <summary>
    /// InputMan processes input every Update and triggers actions in both GameMain and GameWorld appropriately.
    /// </summary>
    public class InputMan : Microsoft.Xna.Framework.GameComponent
    {
        GameMain mGame;
        GameWorld mWorld;

        public InputMan(Game game, GameWorld world)
            : base(game)
        {
            mGame = (GameMain)game;
            mWorld = world;
        }

        override public void Update(GameTime gameTime)
        {
            // Allows the game to exit
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed ||
                Keyboard.GetState().IsKeyDown(Keys.Escape))
            {
                mGame.Exit();
            }

            base.Update(gameTime);
        }
    }
}
