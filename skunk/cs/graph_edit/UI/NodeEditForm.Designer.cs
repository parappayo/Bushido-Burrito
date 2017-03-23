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
            this.nodePropertyKeysListBox = new System.Windows.Forms.ListBox();
            this.nodeEdgesListBox = new System.Windows.Forms.ListBox();
            this.nodePropertyValuesListBox = new System.Windows.Forms.ListBox();
            this.SuspendLayout();
            // 
            // nodePropertyKeysListBox
            // 
            this.nodePropertyKeysListBox.FormattingEnabled = true;
            this.nodePropertyKeysListBox.Location = new System.Drawing.Point(12, 30);
            this.nodePropertyKeysListBox.Name = "nodePropertyKeysListBox";
            this.nodePropertyKeysListBox.Size = new System.Drawing.Size(230, 225);
            this.nodePropertyKeysListBox.TabIndex = 0;
            // 
            // nodeEdgesListBox
            // 
            this.nodeEdgesListBox.FormattingEnabled = true;
            this.nodeEdgesListBox.Location = new System.Drawing.Point(12, 285);
            this.nodeEdgesListBox.Name = "nodeEdgesListBox";
            this.nodeEdgesListBox.Size = new System.Drawing.Size(245, 147);
            this.nodeEdgesListBox.TabIndex = 1;
            // 
            // nodePropertyValuesListBox
            // 
            this.nodePropertyValuesListBox.FormattingEnabled = true;
            this.nodePropertyValuesListBox.Location = new System.Drawing.Point(258, 30);
            this.nodePropertyValuesListBox.Name = "nodePropertyValuesListBox";
            this.nodePropertyValuesListBox.Size = new System.Drawing.Size(230, 225);
            this.nodePropertyValuesListBox.TabIndex = 2;
            // 
            // NodeEditForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(549, 444);
            this.Controls.Add(this.nodePropertyValuesListBox);
            this.Controls.Add(this.nodeEdgesListBox);
            this.Controls.Add(this.nodePropertyKeysListBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "NodeEditForm";
            this.Text = "Node";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox nodePropertyKeysListBox;
        private System.Windows.Forms.ListBox nodeEdgesListBox;
        private System.Windows.Forms.ListBox nodePropertyValuesListBox;
    }
}