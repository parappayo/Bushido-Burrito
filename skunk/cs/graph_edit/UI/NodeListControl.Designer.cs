namespace GraphEdit.UI
{
    partial class NodeListControl
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.nodeListBox = new System.Windows.Forms.ListBox();
            this.SuspendLayout();
            // 
            // nodeListBox
            // 
            this.nodeListBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.nodeListBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.nodeListBox.FormattingEnabled = true;
            this.nodeListBox.Location = new System.Drawing.Point(0, 0);
            this.nodeListBox.Name = "nodeListBox";
            this.nodeListBox.Size = new System.Drawing.Size(146, 146);
            this.nodeListBox.TabIndex = 0;
            this.nodeListBox.DoubleClick += new System.EventHandler(this.nodeListBox_DoubleClick);
            this.nodeListBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.nodeListBox_KeyPress);
            // 
            // NodeListControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.Controls.Add(this.nodeListBox);
            this.Name = "NodeListControl";
            this.Size = new System.Drawing.Size(146, 146);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox nodeListBox;
    }
}
