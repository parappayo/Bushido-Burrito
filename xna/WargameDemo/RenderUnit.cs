using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Tango_Uniform
{
    /// <summary>
    /// Utilities for drawing in-game units (infantry, armor, etc.)
    /// </summary>
    public class RenderUnit
    {
        VertexPositionColorTexture[] backingVerticies;
        int[] backingVertexIndicies;

        RenderMan render;

        public RenderUnit(RenderMan renderMan)
        {
            render = renderMan;

            GenerateUnitBackingGeometry();
        }

        private void DrawUnitBacking()
        {
            BasicEffect effect = render.CurrentEffect;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                render.GraphicsDevice.DrawUserIndexedPrimitives<VertexPositionColorTexture>(
                    PrimitiveType.TriangleList,
                    backingVerticies,
                    0,  // starting index
                    4,  // number of verts
                    backingVertexIndicies,
                    0,  // index offset
                    2   // number of primitives
                );
                pass.End();
            }
            effect.End();
        }

        /// <summary>
        /// Generates a triangle list that forms a rect shape.
        /// </summary>
        protected void GenerateUnitBackingGeometry()
        {
            const float halfWidth = 25;
            const float halfHeight = 20;

            Vector3[] verticies = new Vector3[4];

            verticies[0] = new Vector3(-halfWidth, -halfHeight, 0.0f);
            verticies[1] = new Vector3(halfWidth, -halfHeight, 0.0f);
            verticies[2] = new Vector3(halfWidth, halfHeight, 0.0f);
            verticies[3] = new Vector3(-halfWidth, halfHeight, 0.0f);

            Vector2[] textureCoords = new Vector2[4];

            textureCoords[0] = new Vector2(0.0f, 0.0f);
            textureCoords[1] = new Vector2(1.0f, 0.0f);
            textureCoords[2] = new Vector2(1.0f, 1.0f);
            textureCoords[3] = new Vector2(0.0f, 1.0f);

            backingVerticies = new VertexPositionColorTexture[4];

            for (int i = 0; i < backingVerticies.Length; i++)
            {
                backingVerticies[i] = new VertexPositionColorTexture(verticies[i], Color.White, textureCoords[i]);
            }

            backingVertexIndicies = new int[6];
            backingVertexIndicies[0] = 0;
            backingVertexIndicies[1] = 1;
            backingVertexIndicies[2] = 2;
            backingVertexIndicies[3] = 2;
            backingVertexIndicies[4] = 3;
            backingVertexIndicies[5] = 0;
        }

        public Color Color
        {
            set
            {
                for (int i = 0; i < backingVerticies.Length; i++)
                {
                    backingVerticies[i].Color = value;
                }
            }

            get
            {
                // assumes all verticies have the same color
                return backingVerticies[0].Color;
            }
        }

        public void DrawUnit(HexTilePosition pos, UnitType type)
        {
            Vector3 mapPos = RenderHex.HexPositionToMapPosition(pos);
            render.PushWorldMatrix(Matrix.CreateTranslation(mapPos));

            switch (type)
            {
                case UnitType.Unknown:
                    DrawUnknown();
                    break;

                case UnitType.Infantry:
                    DrawInfantry();
                    break;

                case UnitType.Armor:
                    DrawArmor();
                    break;

                case UnitType.Artillery:
                    DrawArtillery();
                    break;

                default:
                    DrawInvalid();
                    break;
            }

            render.PopWorldMatrix();
        }

        protected void DrawUnknown()
        {
            Color = Color.DarkOliveGreen;
            DrawUnitBacking();
            // TODO: put a big question mark over the unit backing
        }

        protected void DrawInfantry()
        {
        }

        protected void DrawArmor()
        {

        }

        protected void DrawArtillery()
        {

        }

        protected void DrawInvalid()
        {

        }
    }
}
