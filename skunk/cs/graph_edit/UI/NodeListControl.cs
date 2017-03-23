
using System.Collections.Generic;
using System.Windows.Forms;
using GraphEdit.Graph;

namespace GraphEdit.UI
{
    public partial class NodeListControl : UserControl
    {
        public List<Node> Nodes = new List<Node>();

        public NodeListControl()
        {
            InitializeComponent();
        }

        public void AddNode(Node node)
        {
            if (Nodes.Contains(node))
            {
                throw new System.ArgumentException("Cannot add duplicate node");
            }

            Nodes.Add(node);

            if (!string.IsNullOrEmpty(node.Name))
            {
                this.nodeListBox.Items.Add(node.Name);
            }
            else
            {
                this.nodeListBox.Items.Add(node);
            }
        }
    }
}
