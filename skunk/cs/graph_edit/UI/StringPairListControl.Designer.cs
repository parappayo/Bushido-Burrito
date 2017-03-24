namespace GraphEdit.UI
{
    partial class StringPairListControl
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
            this.splitContainer = new System.Windows.Forms.SplitContainer();
            this.leftListBox = new System.Windows.Forms.ListBox();
            this.rightListBox = new System.Windows.Forms.ListBox();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).BeginInit();
            this.splitContainer.Panel1.SuspendLayout();
            this.splitContainer.Panel2.SuspendLayout();
            this.splitContainer.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer
            // 
            this.splitContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer.Location = new System.Drawing.Point(0, 0);
            this.splitContainer.Name = "splitContainer";
            // 
            // splitContainer.Panel1
            // 
            this.splitContainer.Panel1.Controls.Add(this.leftListBox);
            // 
            // splitContainer.Panel2
            // 
            this.splitContainer.Panel2.Controls.Add(this.rightListBox);
            this.splitContainer.Size = new System.Drawing.Size(412, 361);
            this.splitContainer.SplitterDistance = 178;
            this.splitContainer.TabIndex = 0;
            // 
            // leftListBox
            // 
            this.leftListBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.leftListBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.leftListBox.FormattingEnabled = true;
            this.leftListBox.Location = new System.Drawing.Point(0, 0);
            this.leftListBox.Name = "leftListBox";
            this.leftListBox.Size = new System.Drawing.Size(178, 361);
            this.leftListBox.TabIndex = 0;
            this.leftListBox.Click += new System.EventHandler(this.leftListBox_Click);
            this.leftListBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.leftListBox_KeyPress);
            this.leftListBox.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.leftListBox_MouseDoubleClick);
            // 
            // rightListBox
            // 
            this.rightListBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rightListBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rightListBox.FormattingEnabled = true;
            this.rightListBox.Location = new System.Drawing.Point(0, 0);
            this.rightListBox.Name = "rightListBox";
            this.rightListBox.Size = new System.Drawing.Size(230, 361);
            this.rightListBox.TabIndex = 0;
            this.rightListBox.Click += new System.EventHandler(this.rightListBox_Click);
            this.rightListBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.rightListBox_KeyPress);
            this.rightListBox.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.rightListBox_MouseDoubleClick);
            // 
            // StringPairListControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainer);
            this.Name = "StringPairListControl";
            this.Size = new System.Drawing.Size(412, 361);
            this.splitContainer.Panel1.ResumeLayout(false);
            this.splitContainer.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).EndInit();
            this.splitContainer.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer;
        private System.Windows.Forms.ListBox leftListBox;
        private System.Windows.Forms.ListBox rightListBox;
    }
}
