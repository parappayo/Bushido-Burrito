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
            this.propertiesListBox = new System.Windows.Forms.ListBox();
            this.edgesListBox = new System.Windows.Forms.ListBox();
            this.SuspendLayout();
            // 
            // propertiesListBox
            // 
            this.propertiesListBox.FormattingEnabled = true;
            this.propertiesListBox.Location = new System.Drawing.Point(12, 30);
            this.propertiesListBox.MultiColumn = true;
            this.propertiesListBox.Name = "propertiesListBox";
            this.propertiesListBox.Size = new System.Drawing.Size(230, 225);
            this.propertiesListBox.TabIndex = 0;
            // 
            // edgesListBox
            // 
            this.edgesListBox.FormattingEnabled = true;
            this.edgesListBox.Location = new System.Drawing.Point(266, 30);
            this.edgesListBox.Name = "edgesListBox";
            this.edgesListBox.Size = new System.Drawing.Size(245, 225);
            this.edgesListBox.TabIndex = 1;
            // 
            // NodeEditForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(549, 444);
            this.Controls.Add(this.edgesListBox);
            this.Controls.Add(this.propertiesListBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "NodeEditForm";
            this.Text = "Node";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox propertiesListBox;
        private System.Windows.Forms.ListBox edgesListBox;
    }
}