using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Tango_Uniform
{
    /// <summary>
    /// This is the Rendering Manager class.  It's purpose is to iterate over a game state (the model)
    /// and render what it sees using a GraphicsDevice passed to it by the main game engine.
    /// </summary>
    public class RenderMan
    {
        BasicEffect globalEffect; // use this one when the stack is empty

        VertexDeclaration vertexDeclaration;
        Stack<Matrix> worldMatrixStack;  // used for OpenGL style modelview
        Matrix worldMatrix;  // this is used when the stack is empty
        Matrix viewMatrix;
        Matrix projectionMatrix;

        TextureMan TextureMan;

        public RenderQuad RenderQuad;  // quad drawing utilities
        public RenderHex RenderHex;  // hex drawing utilities
        public RenderUnit RenderUnit;  // unit drawing utilities

        GameMain mGame;

        public RenderMan(GameMain game)
        {
            mGame = game;

            TextureMan = new TextureMan();  // loads texture resources

            worldMatrixStack = new Stack<Matrix>();
            InitializeRenderEffect();

            // init render utilities
            RenderQuad = new RenderQuad(this);
            RenderHex = new RenderHex(this);
            RenderUnit = new RenderUnit(this);
        }

        public void PushWorldMatrix(Matrix world)
        {
            worldMatrixStack.Push(world * WorldMatrix);
        }

        public Matrix PopWorldMatrix()
        {
            return worldMatrixStack.Pop();
        }

        public Matrix WorldMatrix
        {
            get
            {
                if (worldMatrixStack.Count > 0)
                {
                    return worldMatrixStack.Peek();
                }
                return worldMatrix;
            }
        }

        public BasicEffect CurrentEffect
        {
            get 
            {
                globalEffect.World = WorldMatrix;
                return globalEffect;
            }
        }

        public GraphicsDevice GraphicsDevice
        {
            get { return mGame.GraphicsDevice; }
        }

        public TextureMan Textures
        {
            get { return this.TextureMan; }
        }

        /// <summary>
        /// Set up the modelview matrix and other such tasks.
        /// </summary>
        protected void InitializeRenderEffect()
        {
            viewMatrix = Matrix.CreateLookAt(
                new Vector3(0.0f, 0.0f, 1.0f),
                Vector3.Zero,
                Vector3.Up
                );

            projectionMatrix = Matrix.CreateOrthographicOffCenter(
                0,
                (float)GraphicsDevice.Viewport.Width,
                (float)GraphicsDevice.Viewport.Height,
                0,
                1.0f, 10.0f);

            vertexDeclaration = new VertexDeclaration(
                GraphicsDevice,
                VertexPositionColorTexture.VertexElements
            );

            globalEffect = new BasicEffect(GraphicsDevice, null);
            globalEffect.VertexColorEnabled = true;

            worldMatrix = Matrix.CreateTranslation(
                GraphicsDevice.Viewport.Width / 2f,
                GraphicsDevice.Viewport.Height / 2f,
                0
            );
            globalEffect.World = worldMatrix;
            globalEffect.View = viewMatrix;
            globalEffect.Projection = projectionMatrix;
        }

        public void StartFrame()
        {
            GraphicsDevice.Clear(Color.Black);
            GraphicsDevice.VertexDeclaration = vertexDeclaration;
        }
    }
}
