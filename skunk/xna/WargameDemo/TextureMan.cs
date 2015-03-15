using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace Tango_Uniform
{
    /// <summary>
    /// Manages the texture content in a basic way.
    /// </summary>
    public class TextureMan
    {
        Texture2D water;

        public Texture2D Water { get { return water; } }

        /// <summary>
        /// This should only ever be called from GameMain.LoadContent
        /// </summary>
        public void LoadContent(ContentManager Content)
        {
            water = Content.Load<Texture2D>("water");
        }
    }
}
