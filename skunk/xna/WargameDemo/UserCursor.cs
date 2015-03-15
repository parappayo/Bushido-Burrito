using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace Tango_Uniform
{
    /// <summary>
    /// UserCursor implements an on-screen pointer that the user can move around for the purpose of
    /// indicating positions or otherwise selecting things.
    /// </summary>
    public class UserCursor : Microsoft.Xna.Framework.DrawableGameComponent
    {
        protected Game mGame;

        public delegate void DrawUserCursorDelegate(UserCursor cursor);
        /// <summary>
        /// Set this to provide a custom solution for drawing the cursor on-screen.
        /// </summary>
        public DrawUserCursorDelegate DrawUserCursor { set; get; }

        /// <summary>
        /// Screen coordinates of the user cursor's position.
        /// </summary>
        public Vector3 Position
        {
            get
            {
                return mPosition;
            }
        }
        protected Vector3 mPosition;

        /// <summary>
        /// Defines limits to the range of the cursor's motion, in screen coordinates.
        /// </summary>
        public Rectangle Boundary { set; get; }

        /// <summary>
        /// Allows user to move the cursor using gamepad input with the left analog stick.
        /// Has no effect if MouseEnabled is true.
        /// Defaults to false.
        /// </summary>
        public bool GamePadEnabled { set; get; }

        /// <summary>
        /// Snaps the location of the cursor to the mouse cursor when the mouse is over the game window.
        /// PushBoundaryEvent will not occur if this is true.
        /// Overrides GamepadEnabled and KeyboardEnabled.
        /// Defaults to false.
        /// </summary>
        public bool MouseEnabled { set; get; }

        /// <summary>
        /// Allows the user to move the cursor using keyboard input with the WASD and arrow keys.
        /// Has no effect if MouseEnabled is true.
        /// Defaults to false.
        /// </summary>
        public bool KeyboardEnabled { set; get; }

        /// <summary>
        /// This event is fired when the cursor pushes up against the edge of the limits defined by Boundary.
        /// This event will not work if MouseEnabled is set to true.
        /// </summary>
        public event EventHandler PushBoundaryEvent;
        public class PushBoundaryEventArgs : EventArgs
        {
            public Vector3 PushDirection { get; set; }
        }

        public UserCursor(Game game)
            : base(game)
        {
            mGame = game;
        }

        /// <summary>
        /// Allows the game component to perform any initialization it needs to before starting
        /// to run.  This is where it can query for any required services and load content.
        /// </summary>
        public override void Initialize()
        {
            base.Initialize();

            const int BoundaryPadding = 20;
            Boundary = new Rectangle(
                -GraphicsDevice.Viewport.Width / 2 + BoundaryPadding,
                -GraphicsDevice.Viewport.Height / 2 + BoundaryPadding,
                GraphicsDevice.Viewport.Width - BoundaryPadding,
                GraphicsDevice.Viewport.Height - BoundaryPadding
            );
        }

        /// <summary>
        /// Allows the game component to update itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        public override void Update(GameTime gameTime)
        {
            if (MouseEnabled)
            {
                MouseState mouse = Mouse.GetState();
                MoveTo(mouse.X, mouse.Y);
            }
            else
            {
                float x, y;  // let's blend together different inputs

                x = 0.0f;
                y = 0.0f;

                if (GamePadEnabled)
                {
                    // TODO: need to be able to handle other players
                    GamePadState gamepad = GamePad.GetState(PlayerIndex.One);
                    x += gamepad.ThumbSticks.Left.X;
                    y += gamepad.ThumbSticks.Left.Y;
                }

                if (KeyboardEnabled)
                {
                    KeyboardState keyboard = Keyboard.GetState();
                    if (keyboard.IsKeyDown(Keys.W) || keyboard.IsKeyDown(Keys.Up))
                    {
                        y += 1.0f;
                    }
                    if (keyboard.IsKeyDown(Keys.A) || keyboard.IsKeyDown(Keys.Left))
                    {
                        x += -1.0f;
                    }
                    if (keyboard.IsKeyDown(Keys.S) || keyboard.IsKeyDown(Keys.Down))
                    {
                        y += -1.0f;
                    }
                    if (keyboard.IsKeyDown(Keys.D) || keyboard.IsKeyDown(Keys.Right))
                    {
                        x += 1.0f;
                    }
                }

                //Trace.Write(String.Format("thumbstick cursor: {0}, {1}\n", x, y));
                Move(new Vector2(x, y), gameTime);
            }

            base.Update(gameTime);
        }

        public override void Draw(GameTime gameTime)
        {
            if (DrawUserCursor != null)
            {
                DrawUserCursor(this);
            }

            base.Draw(gameTime);
        }

        /// <summary>
        /// Move the cursor in the given direction scaled by the given time interval.
        /// Calling this method will cause a PushBoundaryEvent if the specified movement would take
        /// the cursor outside of the limits specified in Boundary.
        /// </summary>
        public void Move(Vector2 direction, GameTime time)
        {
            float scale = 0.5f * time.ElapsedGameTime.Milliseconds;
            Vector3 pos = Position + new Vector3(direction.X * scale, -direction.Y * scale, 0.0f);
            //Trace.Write(String.Format("cursor screen pos: {0}, {1}\n", pos.X, pos.Y));

            // if the cursor has now moved past the screen edge, pan the map to compensate
            Vector3 oldPos = pos;
            pos.X = Math.Max(Math.Min(pos.X, Boundary.Right), Boundary.Left);
            pos.Y = Math.Max(Math.Min(pos.Y, Boundary.Bottom), Boundary.Top);
            if (pos != oldPos)
            {
                if (PushBoundaryEvent != null)
                {
                    PushBoundaryEventArgs e = new PushBoundaryEventArgs();
                    e.PushDirection = pos - oldPos;
                    PushBoundaryEvent(this, e);
                }
            }

            mPosition = pos;
        }

        /// <summary>
        /// Move the cursor to the given X, Y coordinates or the nearest boundary edge.
        /// Calling this method will not trigger a PushBoundaryEvent.
        /// </summary>
        public void MoveTo(int X, int Y)
        {
            mPosition.X = Math.Max(Math.Min(X, Boundary.Right), Boundary.Left);
            mPosition.Y = Math.Max(Math.Min(Y, Boundary.Bottom), Boundary.Top);
        }
    }
}