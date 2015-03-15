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


namespace RPGActionBarDemo
{
    /// <summary>
    /// This is a game component that implements IUpdateable.
    /// </summary>
    public class RPGActionButtonController : Microsoft.Xna.Framework.DrawableGameComponent
    {
        public RPGActionButtonController(Game game)
            : base(game)
        {
            State = eState.INIT;
        }

        public override void Initialize()
        {
            base.Initialize();

            ActionButton = new RPGActionButton();
            ActionButton.Initialize(GraphicsDevice);

            CooldownElapsed = new TimeSpan();
            CooldownLength = new TimeSpan();

            State = eState.READY;
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            switch (State)
            {
                case eState.READY:
                    {
                        if (Keyboard.GetState().IsKeyDown(ShortcutKey))
                        {
                            Activate();
                        }
                    }
                    break;

                case eState.COOLDOWN:
                    {
                        CooldownElapsed = CooldownElapsed.Add(gameTime.ElapsedGameTime);
                        ActionButton.CooldownPercent = (float)(CooldownElapsed.TotalMilliseconds / CooldownLength.TotalMilliseconds) * 100.0f;
                        ActionButton.CooldownPercent = Math.Min(ActionButton.CooldownPercent, 100.0f);

                        if (CooldownElapsed >= CooldownLength)
                        {
                            ActionButton.CooldownPercent = 0.0f;
                            State = eState.DING_ANIM;
                        }
                    }
                    break;

                case eState.DING_ANIM:
                    {
                        // TODO: implement me
                        State = eState.READY;
                    }
                    break;
            }
        }

        public override void Draw(GameTime gameTime)
        {
            ActionButton.Draw(gameTime, SpriteBatch, GraphicsDevice);

            base.Draw(gameTime);
        }

        public void SetPosition(Rectangle pos)
        {
            ActionButton.Position = pos;
        }

        public void SetPosition(int x, int y, int width, int height)
        {
            ActionButton.Position.X = x;
            ActionButton.Position.Y = y;
            ActionButton.Position.Width = width;
            ActionButton.Position.Height = height;
        }

        public void SetButtonFace(Texture2D tex)
        {
            ActionButton.ButtonFace = tex;
        }

        public void Activate()
        {
            // TODO: should be a callback here so listeners can tell we've been triggered

            StartCooldown();
        }

        public void StartCooldown()
        {
            if (State == eState.INIT) { return; }

            State = eState.COOLDOWN;
            CooldownElapsed = TimeSpan.Zero;
        }

        private RPGActionButton ActionButton;
        public SpriteBatch SpriteBatch;

        public TimeSpan CooldownLength;
        private TimeSpan CooldownElapsed;
        public Keys ShortcutKey;

        enum eState
        {
            INIT,       // in this state until Initialize is called
            READY,      // idle state
            COOLDOWN,   // cannot be triggered
            DING_ANIM,  // animation shows player that the button is ready once again
        }
        private eState State;
    }
}
