
using System;
using System.Drawing;
using System.Windows.Forms;

namespace GraphEdit.UI
{
    public class StringPairListItemEditedEventArgs : EventArgs
    {
        public string OldKey;
        public string NewKey;
        public string OldValue;
        public string NewValue;
    }

    public partial class StringPairListControl : UserControl
    {
        public bool Editable = false;

        public EventHandler ItemEdited;

        private TextBox EditTextBox = new TextBox();
        private ListBox EditTarget;

        public ListBox LeftListBox
        {
            get { return this.leftListBox; }
        }

        public ListBox RightListBox
        {
            get { return this.rightListBox; }
        }

        public StringPairListControl()
        {
            InitializeComponent();

            this.EditTextBox.Visible = false;
            this.EditTextBox.Multiline = true;
            this.EditTextBox.AcceptsReturn = true;
            this.EditTextBox.Leave += EditTextBox_Leave;
            this.Controls.Add(this.EditTextBox);
            this.EditTextBox.BringToFront();
        }

        private void EditTextBox_Leave(object sender, System.EventArgs e)
        {
            HandleEditBoxFinished();
        }

        private void ShowEditBox(ListBox target, Point locationOffset)
        {
            var text = target.SelectedItem as string;
            if (string.IsNullOrEmpty(text)) { return; }

            this.EditTarget = target;

            this.EditTextBox.Visible = true;
            this.EditTextBox.Text = text;
            this.EditTextBox.Size = new Size(target.Width, 32);
            this.EditTextBox.Location = new Point(
                target.Location.X + locationOffset.X,
                target.ItemHeight * target.SelectedIndex + locationOffset.Y);
        }

        private void HandleEditBoxFinished()
        {
            if (this.EditTextBox.Text != this.EditTarget.SelectedValue as string)
            {
                var args = new StringPairListItemEditedEventArgs();
                args.OldKey = this.leftListBox.SelectedItem as string;
                args.OldValue = this.rightListBox.SelectedItem as string;

                if (this.EditTarget == this.leftListBox)
                {
                    args.NewKey = this.EditTextBox.Text;
                    args.NewValue = args.OldValue;
                }
                else
                {
                    args.NewKey = args.OldKey;
                    args.NewValue = this.EditTextBox.Text;
                }

                ItemEdited(this, args);
            }

            this.EditTextBox.Visible = false;
            this.EditTarget = null;
        }

        private void leftListBox_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            if (this.Editable)
            {
                ShowEditBox(this.leftListBox, new Point(0, 0));
            }
        }

        private void rightListBox_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            if (this.Editable)
            {
                ShowEditBox(this.rightListBox, new Point(this.leftListBox.Width + this.splitContainer.SplitterWidth, 0));
            }
        }

        private void leftListBox_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter)
            {
                if (this.EditTextBox.Visible)
                {
                    HandleEditBoxFinished();
                }
                else if (this.Editable)
                {
                    ShowEditBox(this.leftListBox, new Point(0, 0));
                }
            }
        }

        private void rightListBox_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter)
            {
                if (this.EditTextBox.Visible)
                {
                    HandleEditBoxFinished();
                }
                else if (this.Editable)
                {
                    ShowEditBox(this.rightListBox, new Point(this.leftListBox.Width + this.splitContainer.SplitterWidth, 0));
                }
            }
        }

        private void leftListBox_Click(object sender, System.EventArgs e)
        {
            if (this.EditTextBox.Visible)
            {
                HandleEditBoxFinished();
            }
        }

        private void rightListBox_Click(object sender, System.EventArgs e)
        {
            if (this.EditTextBox.Visible)
            {
                HandleEditBoxFinished();
            }
        }
    }
}
