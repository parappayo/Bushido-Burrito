using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

namespace bmp2png
{
   /// <summary>
   /// Glob is used to handle command-line wildcards, such as "*.bmp".
   /// This is a quick n' dirty solution so be gentle with it. :)
   /// Big thanks to Brian Ary for providing this code on his blog:
   /// http://brianary.blogspot.com/2007/09/globbing-using-filename-wildcard.html
   /// </summary>
   public static class Glob
   {
       static public string[] GetFiles(string[] patterns)
       {
           List<string> filelist = new List<string>();
           foreach (string pattern in patterns)
               filelist.AddRange(GetFiles(pattern));
           string[] files = new string[filelist.Count];
           filelist.CopyTo(files, 0);
           return files;
       }

       static public string[] GetFiles(string patternlist)
       {
           List<string> filelist = new List<string>();
           foreach (string pattern in
               patternlist.Split(Path.GetInvalidPathChars()))
           {
               string dir = Path.GetDirectoryName(pattern);
               if (String.IsNullOrEmpty(dir)) dir =
                    Directory.GetCurrentDirectory();
               filelist.AddRange(Directory.GetFiles(
                   Path.GetFullPath(dir),
                   Path.GetFileName(pattern)));
           }
           string[] files = new string[filelist.Count];
           filelist.CopyTo(files, 0);
           return files;
       }
   }

   class Program
   {
       static void Main(string[] args)
       {
           if (args.Length == 0)
           {
               Console.WriteLine("usage: bmp2png <filename> ...");
           }

           foreach (string arg in args)
           {
               string[] files = Glob.GetFiles(arg);
               foreach (string filename in files)
               {
                   if (filename.EndsWith(".bmp", true, null))
                   {
                       string outfile = filename.Substring(0, filename.Length - 4);
                       outfile += ".png";

                       Image inputImage = Image.FromFile(filename);
                       inputImage.Save(outfile, ImageFormat.Png);
                   }
                   else
                   {
                       Console.WriteLine("warning: {0} is not a .bmp file", filename);
                   }
               }
           }
       }
   }
}