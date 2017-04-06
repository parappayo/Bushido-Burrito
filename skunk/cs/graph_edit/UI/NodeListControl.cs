
using System;
using System.ComponentModel;
using System.Windows.Forms;
using GraphEdit.Graph;

namespace GraphEdit.UI
{
    public partial class NodeListControl : UserControl
    {
        public BindingList<Node> Nodes = new BindingList<Node>();

        public EventHandler ItemOpened;

        public NodeListControl()
        {
            InitializeComponent();

            this.nodeListBox.DataSource = this.Nodes;
            this.nodeListBox.DisplayMember = "Name";
        }

        public Node SelectedItem
        {
            get { return (Node)this.nodeListBox.SelectedItem; }
        }

        public void AddNode(Node node)
        {
            if (Nodes.Contains(node))
            {
                throw new System.ArgumentException("Cannot add duplicate node");
            }

            this.Nodes.Add(node);
        }

        private void nodeListBox_DoubleClick(object sender, EventArgs e)
        {
            if (ItemOpened != null)
            {
                ItemOpened.Invoke(this, e);
            }
        }

        private void nodeListBox_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter)
            {
                if (ItemOpened != null)
                {
                    ItemOpened.Invoke(this, e);
                }
            }
        }
    }
}
