
using System;
using System.Windows.Forms;
using GraphEdit.Graph;

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

        private NodeEditForm FindNodeEditForm(Node node)
        {
            foreach (Form form in Application.OpenForms)
            {
                var nodeEditForm = form as NodeEditForm;

                if (nodeEditForm != null &&
                    nodeEditForm.Target == node)
                {
                    return nodeEditForm;
                }
            }

            return null;
        }

        private void HandleNodeOpened(object sender, EventArgs e)
        {
            var selectedNode = this.nodeListControl.SelectedItem;
            var nodeEditForm = FindNodeEditForm(selectedNode);

            if (nodeEditForm != null)
            {
                nodeEditForm.Focus();
            }
            else
            {
                nodeEditForm = new NodeEditForm(selectedNode);
                nodeEditForm.Show();
            }
        }

        private void addNodeButton_Click(object sender, EventArgs e)
        {
            var newNode = new Graph.Node();
            newNode.Properties.Add("name", NewNodeCaption);
            this.nodeListControl.AddNode(newNode);
        }
    }
}
