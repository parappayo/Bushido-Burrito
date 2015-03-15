using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

namespace ScreenAutocap
{
    class CmdProgram
    {
        static void Main(string[] args)
        {
            string dir = Environment.CurrentDirectory;

            if (args.Length > 0)
            {
                dir = args[0];
            }
            if (!Directory.Exists(dir))
            {
                Console.WriteLine("invalid argument, directory {0} does not exist", dir);
                return;
            }

            WriteScreenCap(dir);
        }

        /// <summary>
        /// Writes a screen capture image to file, returns the path of the file written.
        /// </summary>
        static string WriteScreenCap(string outputDir)
        {
            try
            {
                // generate an unused file name
                string file = Path.Combine(outputDir, "screen.png");
                int i = 0;
                while (File.Exists(file))
                {
                    string temp = string.Format("screen{0}.png", i);
                    file = Path.Combine(outputDir, temp);
                    i++;
                }

                Bitmap capture = CaptureScreen.GetDesktopImage();
                ImageFormat format = ImageFormat.Png;
                capture.Save(file, format);
                return file;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            return null;
        }
    }
}
