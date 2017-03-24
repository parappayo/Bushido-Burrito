
using System.Drawing;
using System.Windows.Forms;

namespace GraphEdit.UI
{
    public partial class StringPairListControl : UserControl
    {
        public bool Editable = false;

        private TextBox EditTextBox = new TextBox();

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

            this.EditTextBox.Visible = false;
            this.Controls.Add(this.EditTextBox);
            this.EditTextBox.BringToFront();
        }

        private void ShowEditBox(ListBox target, Point locationOffset)
        {
            string text = target.SelectedValue as string;
            if (string.IsNullOrEmpty(text)) { return; }

            this.EditTextBox.Visible = true;
            this.EditTextBox.Text = text;
            this.EditTextBox.Size = new Size(target.Width, 32);
            this.EditTextBox.Location = new Point(
                target.Location.X + locationOffset.X,
                target.ItemHeight * target.SelectedIndex + locationOffset.Y);
        }

        private void leftListBox_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            ShowEditBox(this.leftListBox, new Point(0, 0));
        }

        private void rightListBox_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            ShowEditBox(this.rightListBox, new Point(this.leftListBox.Width + this.splitContainer1.SplitterWidth, 0));
        }
    }
}
