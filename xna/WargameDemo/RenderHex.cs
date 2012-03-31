using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Tango_Uniform
{
    /// <summary>
    /// This utility class provides methods useful for rendering individual hex tiles.
    /// </summary>
    public class RenderHex
    {
        // the height of a hex with six equal sides is ( tan(60) / 4 ) * width
        public const float HeightRatio = 0.86602540378443864676f;

        public const float HexWidth = 80f;
        public const float HexHeight = HeightRatio * HexWidth;

        VertexPositionColorTexture[] hexPoints; // geometry of a single hex
        RenderMan render;

        public RenderHex(RenderMan render)
        {
            this.render = render;
            hexPoints = GenerateHexGeometry(HexWidth);
        }

        /// <summary>
        /// Determines what vertex color is used to draw hexes.
        /// </summary>
        public Color Color
        {
            set
            {
                for (int i = 0; i < hexPoints.Length; i++)
                {
                    hexPoints[i].Color = value;
                }
            }

            get
            {
                // assumes all verticies have the same color
                return hexPoints[0].Color;
            }
        
        }

        /// <summary>
        /// Draws a single hex tile.
        /// </summary>
        public void DrawHex()
        {
            BasicEffect effect = render.CurrentEffect;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                render.GraphicsDevice.DrawUserPrimitives<VertexPositionColorTexture>(
                    PrimitiveType.TriangleFan,
                    hexPoints,
                    0,  // starting index
                    6  // number of triangles in a hex
                );
                pass.End();
            }
            effect.End();
        }

        public void DrawHex(Vector3 position)
        {
            render.PushWorldMatrix(Matrix.CreateTranslation(position));
            DrawHex();
            render.PopWorldMatrix();
        }

        public void DrawHex(Vector3 position, Color color)
        {
            Color oldColor = this.Color;
            this.Color = color;
            DrawHex(position);
            this.Color = oldColor;
        }

        public void DrawHex(Vector3 position, Texture2D texture)
        {
            render.PushWorldMatrix(Matrix.CreateTranslation(position));

            BasicEffect effect = render.CurrentEffect;
            effect.Texture = texture;
            effect.TextureEnabled = true;

            DrawHex();

            effect.TextureEnabled = false;
            effect.Texture = null;

            render.PopWorldMatrix();
        }

        public void DrawHex(HexTilePosition pos, MapData.TerrainType terrain)
        {
            Vector3 mapPos = RenderHex.HexPositionToMapPosition(pos);

            switch (terrain)
            {
                case MapData.TerrainType.Water:
                    DrawHex(mapPos, render.Textures.Water);
                    break;

                case MapData.TerrainType.Grass:
                    DrawHex(mapPos, Color.LightGreen);
                    break;

                case MapData.TerrainType.LightForest:
                    DrawHex(mapPos, Color.LightGreen);
                    break;

                case MapData.TerrainType.Forest:
                    DrawHex(mapPos, Color.Green);
                    break;

                case MapData.TerrainType.HeavyForest:
                    DrawHex(mapPos, Color.DarkGreen);
                    break;

                case MapData.TerrainType.LightUrban:
                    DrawHex(mapPos, Color.LightGray);
                    break;

                case MapData.TerrainType.Urban:
                    DrawHex(mapPos, Color.Gray);
                    break;

                case MapData.TerrainType.HeavyUrban:
                    DrawHex(mapPos, Color.DarkGray);
                    break;

                default:
                    DrawHex(mapPos);
                    break;
            }
        }

        public void DrawHexBorder()
        {
            BasicEffect effect = render.CurrentEffect;
            effect.Begin();
            foreach (EffectPass pass in effect.CurrentTechnique.Passes)
            {
                pass.Begin();
                render.GraphicsDevice.DrawUserPrimitives<VertexPositionColorTexture>(
                    PrimitiveType.LineStrip,
                    hexPoints,
                    1, // omit first point, the hex center
                    6
                );
                pass.End();
            }
            effect.End();
        }

        public void DrawHexBorder(Vector3 position)
        {
            render.PushWorldMatrix(Matrix.CreateTranslation(position));
            DrawHexBorder();
            render.PopWorldMatrix();
        }

        public void DrawHexBorder(Vector3 position, Color color)
        {
            Color oldColor = this.Color;
            this.Color = color;
            DrawHexBorder(position);
            this.Color = oldColor;
        }

        /// <summary>
        /// Generates a triangle fan that forms a hex shape.  The origin of the triangle fan is 0, 0.
        /// </summary>
        protected VertexPositionColorTexture[] GenerateHexGeometry(float width)
        {
            float halfHeight = HexHeight / 2.0f;
            width /= 2.0f;  // makes the math easier below

            Vector3[] verticies = new Vector3[8];

            verticies[0] = new Vector3(0.0f, 0.0f, 0.0f);
            verticies[1] = new Vector3( width,     0.0f,       0.0f );
            verticies[2] = new Vector3( width/2f,  halfHeight, 0.0f );
            verticies[3] = new Vector3(-width/2f,  halfHeight, 0.0f );
            verticies[4] = new Vector3(-width,     0.0f,       0.0f );
            verticies[5] = new Vector3(-width/2f, -halfHeight, 0.0f );
            verticies[6] = new Vector3( width/2f, -halfHeight, 0.0f );
            verticies[7] = new Vector3( width,     0.0f,       0.0f );

            Vector2[] textureCoords = new Vector2[8];

            textureCoords[0] = new Vector2( 0.5f,  0.5f );
            textureCoords[1] = new Vector2( 1.0f,  0.5f );
            textureCoords[2] = new Vector2( 0.75f, 1.0f );
            textureCoords[3] = new Vector2( 0.25f, 1.0f );
            textureCoords[4] = new Vector2( 0.0f,  0.5f );
            textureCoords[5] = new Vector2( 0.25f, 0.0f );
            textureCoords[6] = new Vector2( 0.75f, 0.0f );
            textureCoords[7] = new Vector2( 1.0f,  0.5f );

            VertexPositionColorTexture[] hex = new VertexPositionColorTexture[8];

            for (int i = 0; i < verticies.Length; i++)
            {
                hex[i] = new VertexPositionColorTexture(verticies[i], Color.White, textureCoords[i]);
            }

            return hex;
        }

        public static Vector3 HexPositionToMapPosition(HexTilePosition pos)
        {
            Vector3 retval = new Vector3();
            retval.X = pos.X * HexWidth * 0.75f;
            retval.Y = pos.Y * HexHeight + (pos.X % 2) * HexHeight / 2;
            return retval;
        }

        /// <summary>
        /// Given a position in map space coordinates, returns the hex space coordinates of the nearest hex,
        /// NOT bounded by the size of the map (use MapData.NearestMapHex instead).
        /// </summary>
        public static HexTilePosition NearestMapHex(Vector3 pos)
        {
            int x = (int)(pos.X / (HexWidth * 0.75f));
            int y = (int)((pos.Y - (x % 2) * HexHeight / 2) / HexHeight);
            //Trace.Write(String.Format("selected hex = {0}, {1}\n", x, y));
            return new HexTilePosition(x, y);
        }
    }
}
