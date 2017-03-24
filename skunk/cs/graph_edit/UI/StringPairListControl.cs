
using System.Windows.Forms;

namespace GraphEdit.UI
{
    public partial class StringPairListControl : UserControl
    {
        public object LeftDataSource
        {
            get { return this.leftListBox.DataSource; }
            set { this.leftListBox.DataSource = value; }
        }

        public object RightDataSource
        {
            get { return this.rightListBox.DataSource; }
            set { this.rightListBox.DataSource = value; }
        }

        public StringPairListControl()
        {
            InitializeComponent();
        }
    }
}
