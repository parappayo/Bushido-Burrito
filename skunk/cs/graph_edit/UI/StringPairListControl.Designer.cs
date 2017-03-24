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
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.leftListBox = new System.Windows.Forms.ListBox();
            this.rightListBox = new System.Windows.Forms.ListBox();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.leftListBox);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.rightListBox);
            this.splitContainer1.Size = new System.Drawing.Size(412, 361);
            this.splitContainer1.SplitterDistance = 178;
            this.splitContainer1.TabIndex = 0;
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
            // 
            // StringPairListControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainer1);
            this.Name = "StringPairListControl";
            this.Size = new System.Drawing.Size(412, 361);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.ListBox leftListBox;
        private System.Windows.Forms.ListBox rightListBox;
    }
}
