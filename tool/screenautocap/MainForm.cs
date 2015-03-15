using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

using System.IO;
using System.Drawing.Imaging;

namespace ScreenAutocap
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            KeybdHook.CreateHook(KeyHandler);
            LogItem("Use PrtScrn key to take a screen cap.");
        }

        void LogItem(string item)
        {
            logTextBox.Text += item + "\r\n\r\n";
        }

        /// <summary>
        /// Writes a screen capture image to file, returns the path of the file written.
        /// </summary>
        static string WriteScreenCap()
        {
            try
            {
                // generate an unused file name
                string file = Path.Combine(Environment.CurrentDirectory, "screen.png");
                int i = 0;
                while (File.Exists(file))
                {
                    string temp = string.Format("screen{0}.png", i);
                    file = Path.Combine(Environment.CurrentDirectory, temp);
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

        public void KeyHandler(IntPtr wParam, IntPtr lParam)
        {
            int key = Marshal.ReadInt32(lParam);

            KeybdHook.VK vk = (KeybdHook.VK)key;

            switch (vk)
            {
                case KeybdHook.VK.VK_SNAPSHOT:
                    string file = WriteScreenCap();
                    if (file != null)
                    {
                        LogItem(file + " written");
                    }
                    break;

                default: break;
            }
        }

    }
}
