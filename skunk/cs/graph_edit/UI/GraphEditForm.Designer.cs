namespace GraphEdit.UI
{
    partial class GraphEditForm
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.nodeListPanel = new System.Windows.Forms.Panel();
            this.addNodeButton = new System.Windows.Forms.Button();
            this.nodeListLabel = new System.Windows.Forms.Label();
            this.nodeListControl = new GraphEdit.UI.NodeListControl();
            this.nodeListPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // nodeListPanel
            // 
            this.nodeListPanel.Controls.Add(this.addNodeButton);
            this.nodeListPanel.Controls.Add(this.nodeListLabel);
            this.nodeListPanel.Controls.Add(this.nodeListControl);
            this.nodeListPanel.Dock = System.Windows.Forms.DockStyle.Right;
            this.nodeListPanel.Location = new System.Drawing.Point(540, 0);
            this.nodeListPanel.Name = "nodeListPanel";
            this.nodeListPanel.Size = new System.Drawing.Size(200, 449);
            this.nodeListPanel.TabIndex = 0;
            // 
            // addNodeButton
            // 
            this.addNodeButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.addNodeButton.Location = new System.Drawing.Point(0, 426);
            this.addNodeButton.Name = "addNodeButton";
            this.addNodeButton.Size = new System.Drawing.Size(200, 23);
            this.addNodeButton.TabIndex = 2;
            this.addNodeButton.Text = "Add Node";
            this.addNodeButton.UseVisualStyleBackColor = true;
            this.addNodeButton.Click += new System.EventHandler(this.addNodeButton_Click);
            // 
            // nodeListLabel
            // 
            this.nodeListLabel.AutoSize = true;
            this.nodeListLabel.Dock = System.Windows.Forms.DockStyle.Top;
            this.nodeListLabel.Location = new System.Drawing.Point(0, 0);
            this.nodeListLabel.Name = "nodeListLabel";
            this.nodeListLabel.Size = new System.Drawing.Size(38, 13);
            this.nodeListLabel.TabIndex = 1;
            this.nodeListLabel.Text = "Nodes";
            // 
            // nodeListControl
            // 
            this.nodeListControl.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.nodeListControl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.nodeListControl.Location = new System.Drawing.Point(0, 0);
            this.nodeListControl.Name = "nodeListControl";
            this.nodeListControl.Size = new System.Drawing.Size(200, 449);
            this.nodeListControl.TabIndex = 0;
            // 
            // GraphEditForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(740, 449);
            this.Controls.Add(this.nodeListPanel);
            this.Name = "GraphEditForm";
            this.Text = "Graph Edit";
            this.nodeListPanel.ResumeLayout(false);
            this.nodeListPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel nodeListPanel;
        private System.Windows.Forms.Label nodeListLabel;
        private NodeListControl nodeListControl;
        private System.Windows.Forms.Button addNodeButton;
    }
}
