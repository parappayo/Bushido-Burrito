using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Tango_Uniform
{
    public class RenderQuad
    {
        const float QuadSize = 20.0f;

        VertexPositionColorTexture[] quadVerticies;
        int[] quadVertexIndicies;

        RenderMan render;

        public RenderQuad(RenderMan render)
        {
            this.render = render;
            GenerateQuadGeometry(QuadSize);
        }

        public void DrawQuad()
        {
            BasicEffect effect = render.CurrentEffect;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                render.GraphicsDevice.DrawUserIndexedPrimitives<VertexPositionColorTexture>(
                    PrimitiveType.TriangleList,
                    quadVerticies,
                    0,  // starting index
                    4,  // number of verts
                    quadVertexIndicies,
                    0,  // index offset
                    2   // number of primitives
                );
                pass.End();
            }
            effect.End();
        }

        /// <summary>
        /// Determines what vertex color is used to draw quads.
        /// </summary>
        public Color Color
        {
            set
            {
                for (int i = 0; i < quadVerticies.Length; i++)
                {
                    quadVerticies[i].Color = value;
                }
            }

            get
            {
                // assumes all verticies have the same color
                return quadVerticies[0].Color;
            }

        }

        protected void DrawQuad(Vector3 position)
        {
            render.PushWorldMatrix(Matrix.CreateTranslation(position));
            DrawQuad();
            render.PopWorldMatrix();
        }

        protected void DrawQuad(Vector3 position, Texture2D texture)
        {
            render.PushWorldMatrix(Matrix.CreateTranslation(position));

            BasicEffect effect = render.CurrentEffect;
            effect.Texture = texture;
            effect.TextureEnabled = true;

            DrawQuad();

            effect.TextureEnabled = false;
            effect.Texture = null;

            render.PopWorldMatrix();
        }

        public void DrawQuad(Vector3 position, Color color)
        {
            Color oldColor = this.Color;
            this.Color = color;
            DrawQuad(position);
            this.Color = oldColor;
        }

        /// <summary>
        /// Generates a triangle list that forms a square shape.  The origin of the square is 0, 0.
        /// </summary>
        protected void GenerateQuadGeometry(float width)
        {
            float hw = width / 2f;

            Vector3[] verticies = new Vector3[4];

            verticies[0] = new Vector3(-hw, -hw, 0.0f);
            verticies[1] = new Vector3( hw, -hw, 0.0f);
            verticies[2] = new Vector3( hw,  hw, 0.0f);
            verticies[3] = new Vector3(-hw,  hw, 0.0f);

            Vector2[] textureCoords = new Vector2[4];

            textureCoords[0] = new Vector2(0.0f, 0.0f);
            textureCoords[1] = new Vector2(1.0f, 0.0f);
            textureCoords[2] = new Vector2(1.0f, 1.0f);
            textureCoords[3] = new Vector2(0.0f, 1.0f);

            quadVerticies = new VertexPositionColorTexture[4];

            for (int i = 0; i < quadVerticies.Length; i++)
            {
                quadVerticies[i] = new VertexPositionColorTexture(verticies[i], Color.White, textureCoords[i]);
            }

            quadVertexIndicies = new int[6];
            quadVertexIndicies[0] = 0;
            quadVertexIndicies[1] = 1;
            quadVertexIndicies[2] = 2;
            quadVertexIndicies[3] = 2;
            quadVertexIndicies[4] = 3;
            quadVertexIndicies[5] = 0;
        }

    }
}
