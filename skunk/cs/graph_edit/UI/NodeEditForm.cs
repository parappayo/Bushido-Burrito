
using System.Collections.Generic;
using System.Windows.Forms;
using GraphEdit.Graph;

namespace GraphEdit.UI
{
    public partial class NodeEditForm : Form
    {
        public Node Target;

        public NodeEditForm(Node target)
        {
            InitializeComponent();

            this.Target = target;

            this.nodePropertyKeysListBox.DataSource = new List<string>(this.Target.Properties.Keys);
            this.nodePropertyValuesListBox.DataSource = new List<string>(this.Target.Properties.Values);
        }
    }
}
