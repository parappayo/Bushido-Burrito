//------------------------------------------------------------------------------
//
//  filehomer
//
//  For license details see the LICENSE file.
//
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace FileHomer
{
	static class Program
	{
		[STAThread]
		static void Main()
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new MainForm());
		}
	}
}

