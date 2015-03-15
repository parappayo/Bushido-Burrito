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
    public class RPGActionButton
    {
        public RPGActionButton()
        {
        }

        public void Initialize(GraphicsDevice graphicsDevice)
        {
            Position = new Rectangle();
            TriangleListPoints = new VertexPositionColor[TriangleListSize + 2];
            TriangleListIndicies = new short[TriangleListSize * 3];

            for (int i = 0; i < TriangleListPoints.Length; i++)
            {
                TriangleListPoints[i].Color = Color.DarkSlateGray;
                TriangleListPoints[i].Color.A = (byte) 150;
            }

            BasicEffect = new BasicEffect(graphicsDevice);
            BasicEffect.VertexColorEnabled = true;
            BasicEffect.Projection = Matrix.CreateOrthographicOffCenter(0.0f, graphicsDevice.Viewport.Width, graphicsDevice.Viewport.Height, 0.0f, -1.0f, 1.0f);

            IndexBuffer = new IndexBuffer(graphicsDevice, IndexElementSize.SixteenBits, TriangleListIndicies.Length, BufferUsage.None);
            VertexBuffer = new VertexBuffer(graphicsDevice, typeof(VertexPositionColor), TriangleListPoints.Length, BufferUsage.None);
        }

        public void Draw(GameTime gameTime, SpriteBatch spriteBatch, GraphicsDevice graphicsDevice)
        {
            spriteBatch.Begin();
            spriteBatch.Draw(ButtonFace, Position, Color.White);
            spriteBatch.End();

            int numTriangles;
            CalcTriangleList(TriangleListPoints, TriangleListIndicies, out numTriangles);

            IndexBuffer.SetData<short>(TriangleListIndicies);
            graphicsDevice.Indices = IndexBuffer;

            VertexBuffer.SetData<VertexPositionColor>(TriangleListPoints, 0, TriangleListPoints.Length);
            graphicsDevice.SetVertexBuffer(VertexBuffer);

            BasicEffect.CurrentTechnique.Passes[0].Apply();

            graphicsDevice.DrawIndexedPrimitives(PrimitiveType.TriangleList, 0, 0, numTriangles * 3, 0, numTriangles);
        }

        private BasicEffect BasicEffect;
        private IndexBuffer IndexBuffer;
        private VertexBuffer VertexBuffer;

        public Rectangle Position;
        public Texture2D ButtonFace;

        /// <summary>
        /// Cooldown is displayed using a pie-wedge style mask.
        /// </summary>
        public float CooldownPercent;

        /// <summary>
        /// The ding animation typically plays when cooldown expires.
        /// </summary>
        public float DingAnimPercent;

        /// <summary>
        /// Triangle list params are used to draw the cooldown animation.
        /// It should have been a triangle fan, but XNA 4.0 removed that feature.
        /// </summary>
        private const int TriangleListSize = 5;
        private VertexPositionColor[] TriangleListPoints;
        private short[] TriangleListIndicies;

        private void CalcTriangleList(VertexPositionColor[] fanPoints, short[] fanIndicies, out int numTriangles)
        {
            int centerX = Position.X + Position.Width / 2;
            int centerY = Position.Y + Position.Height / 2;

            fanPoints[0].Position.X = centerX;
            fanPoints[0].Position.Y = centerY;
            fanIndicies[0] = 0;

            fanPoints[1].Position.X = centerX;
            fanPoints[1].Position.Y = Position.Top;
            fanIndicies[1] = 1;
            fanIndicies[2] = 2;

            if (CooldownPercent < 12.5f)
            {
                float fanSegmentFactor = CooldownPercent / 12.5f;

                fanPoints[2].Position.X = centerX + (Position.Right - centerX) * fanSegmentFactor;
                fanPoints[2].Position.Y = Position.Top;

                numTriangles = 1;
                return;
            }

            fanPoints[2].Position.X = Position.Right;
            fanPoints[2].Position.Y = Position.Top;
            fanIndicies[3] = 0;
            fanIndicies[4] = 2;
            fanIndicies[5] = 3;

            if (CooldownPercent < 25.0f + 12.5f)
            {
                float fanSegmentFactor = (CooldownPercent - 12.5f) / 25.0f;

                fanPoints[3].Position.X = Position.Right;
                fanPoints[3].Position.Y = Position.Top + Position.Height * fanSegmentFactor;

                numTriangles = 2;
                return;
            }

            fanPoints[3].Position.X = Position.Right;
            fanPoints[3].Position.Y = Position.Bottom;
            fanIndicies[6] = 0;
            fanIndicies[7] = 3;
            fanIndicies[8] = 4;

            if (CooldownPercent < 50.0f + 12.5f)
            {
                float fanSegmentFactor = (CooldownPercent - (25.0f + 12.5f)) / 25.0f;

                fanPoints[4].Position.X = Position.Left + Position.Width * (1.0f - fanSegmentFactor);
                fanPoints[4].Position.Y = Position.Bottom;

                numTriangles = 3;
                return;
            }

            fanPoints[4].Position.X = Position.Left;
            fanPoints[4].Position.Y = Position.Bottom;
            fanIndicies[9] = 0;
            fanIndicies[10] = 4;
            fanIndicies[11] = 5;

            if (CooldownPercent < 75.0f + 12.5f)
            {
                float fanSegmentFactor = (CooldownPercent - (50.0f + 12.5f)) / 25.0f;

                fanPoints[5].Position.X = Position.Left;
                fanPoints[5].Position.Y = Position.Top + Position.Height * (1.0f - fanSegmentFactor);

                numTriangles = 4;
                return;
            }

            fanPoints[5].Position.X = Position.Left;
            fanPoints[5].Position.Y = Position.Top;
            fanIndicies[12] = 0;
            fanIndicies[13] = 5;
            fanIndicies[14] = 6;

            if (CooldownPercent < 100.0f)
            {
                float fanSegmentFactor = (CooldownPercent - (75.0f + 12.5f)) / 12.5f;

                fanPoints[6].Position.X = Position.Left + (centerX - Position.Left) * fanSegmentFactor;
                fanPoints[6].Position.Y = Position.Top;

                numTriangles = 5;
                return;
            }

            fanPoints[6].Position.X = centerX;
            fanPoints[6].Position.Y = Position.Top;
            numTriangles = 5;
        }
    }
}
