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
        }
    }
}
