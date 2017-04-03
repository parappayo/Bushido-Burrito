
using System;
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

            PopulateNodePropertiesListControl();

            this.nodePropertiesListControl.ItemEdited += nodePropertiesListControl_ItemEdited;
            this.nodePropertiesListControl.Editable = true;
        }

        private void PopulateNodePropertiesListControl()
        {
            this.nodePropertiesListControl.LeftListBox.DataSource = new List<string>(this.Target.Properties.Keys);
            this.nodePropertiesListControl.RightListBox.DataSource = new List<string>(this.Target.Properties.Values);
        }

        private void nodePropertiesListControl_ItemEdited(object sender, EventArgs e)
        {
            var eventArgs = e as StringPairListItemEditedEventArgs;

            if (eventArgs.NewKey != eventArgs.OldKey)
            {
                this.Target.Properties.Remove(eventArgs.OldKey);
            }

            this.Target.Properties[eventArgs.NewKey] = eventArgs.NewValue;
            PopulateNodePropertiesListControl();
        }
    }
}
