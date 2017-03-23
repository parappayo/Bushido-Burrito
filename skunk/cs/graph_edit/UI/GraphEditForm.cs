
using System;
using System.Windows.Forms;

namespace GraphEdit.UI
{
    public partial class GraphEditForm : Form
    {
        public string NewNodeCaption = "New Node";

        public GraphEditForm()
        {
            InitializeComponent();
        }

        private void addNodeButton_Click(object sender, EventArgs e)
        {
            var newNode = new Graph.Node();
            newNode.Properties.Add("name", NewNodeCaption);
            nodeListControl.AddNode(newNode);
        }
    }
}
