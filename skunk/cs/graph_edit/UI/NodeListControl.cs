
using System.ComponentModel;
using System.Windows.Forms;
using GraphEdit.Graph;

namespace GraphEdit.UI
{
    public partial class NodeListControl : UserControl
    {
        public BindingList<Node> Nodes = new BindingList<Node>();

        public NodeListControl()
        {
            InitializeComponent();

            this.nodeListBox.DataSource = this.Nodes;
            this.nodeListBox.DisplayMember = "Name";
        }

        public void AddNode(Node node)
        {
            if (Nodes.Contains(node))
            {
                throw new System.ArgumentException("Cannot add duplicate node");
            }

            this.Nodes.Add(node);
        }
    }
}
