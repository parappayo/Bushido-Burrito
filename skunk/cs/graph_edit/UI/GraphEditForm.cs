
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

            this.nodeListControl.ItemOpened += this.HandleNodeOpened;
        }

        private void HandleNodeOpened(object sender, EventArgs e)
        {
            NodeEditForm nodeEditForm = new NodeEditForm(this.nodeListControl.SelectedItem);
            nodeEditForm.Show();
        }

        private void addNodeButton_Click(object sender, EventArgs e)
        {
            var newNode = new Graph.Node();
            newNode.Properties.Add("name", NewNodeCaption);
            this.nodeListControl.AddNode(newNode);
        }
    }
}
