
using System;
using System.Windows.Forms;

namespace GraphEdit
{
    static class GraphEditMain
    {
        [STAThread]
        static void Main()
        {
            Application.Run(new UI.GraphEditForm());
        }
    }
}
