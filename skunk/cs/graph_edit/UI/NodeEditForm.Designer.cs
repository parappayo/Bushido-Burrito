namespace GraphEdit.UI
{
    partial class NodeEditForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.nodeEdgesListBox = new System.Windows.Forms.ListBox();
            this.nodePropertiesListControl = new GraphEdit.UI.StringPairListControl();
            this.SuspendLayout();
            // 
            // nodeEdgesListBox
            // 
            this.nodeEdgesListBox.FormattingEnabled = true;
            this.nodeEdgesListBox.Location = new System.Drawing.Point(12, 285);
            this.nodeEdgesListBox.Name = "nodeEdgesListBox";
            this.nodeEdgesListBox.Size = new System.Drawing.Size(245, 147);
            this.nodeEdgesListBox.TabIndex = 1;
            // 
            // nodePropertiesListControl
            // 
            this.nodePropertiesListControl.LeftDataSource = null;
            this.nodePropertiesListControl.Location = new System.Drawing.Point(12, 12);
            this.nodePropertiesListControl.Name = "nodePropertiesListControl";
            this.nodePropertiesListControl.RightDataSource = null;
            this.nodePropertiesListControl.Size = new System.Drawing.Size(510, 254);
            this.nodePropertiesListControl.TabIndex = 2;
            // 
            // NodeEditForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(549, 444);
            this.Controls.Add(this.nodePropertiesListControl);
            this.Controls.Add(this.nodeEdgesListBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "NodeEditForm";
            this.Text = "Node";
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.ListBox nodeEdgesListBox;
        private StringPairListControl nodePropertiesListControl;
    }
}