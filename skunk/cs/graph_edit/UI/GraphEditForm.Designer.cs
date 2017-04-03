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
            this.spacingBottomPanel = new System.Windows.Forms.Panel();
            this.addNodeButton = new System.Windows.Forms.Button();
            this.nodeListControl = new GraphEdit.UI.NodeListControl();
            this.spacingTopPanel = new System.Windows.Forms.Panel();
            this.nodeListLabel = new System.Windows.Forms.Label();
            this.nodeListPanel.SuspendLayout();
            this.spacingBottomPanel.SuspendLayout();
            this.spacingTopPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // nodeListPanel
            // 
            this.nodeListPanel.Controls.Add(this.spacingBottomPanel);
            this.nodeListPanel.Controls.Add(this.nodeListControl);
            this.nodeListPanel.Controls.Add(this.spacingTopPanel);
            this.nodeListPanel.Dock = System.Windows.Forms.DockStyle.Right;
            this.nodeListPanel.Location = new System.Drawing.Point(465, 0);
            this.nodeListPanel.Name = "nodeListPanel";
            this.nodeListPanel.Size = new System.Drawing.Size(275, 449);
            this.nodeListPanel.TabIndex = 0;
            // 
            // spacingBottomPanel
            // 
            this.spacingBottomPanel.Controls.Add(this.addNodeButton);
            this.spacingBottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.spacingBottomPanel.Location = new System.Drawing.Point(0, 417);
            this.spacingBottomPanel.Name = "spacingBottomPanel";
            this.spacingBottomPanel.Size = new System.Drawing.Size(275, 32);
            this.spacingBottomPanel.TabIndex = 4;
            // 
            // addNodeButton
            // 
            this.addNodeButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.addNodeButton.Location = new System.Drawing.Point(0, 0);
            this.addNodeButton.Name = "addNodeButton";
            this.addNodeButton.Size = new System.Drawing.Size(275, 32);
            this.addNodeButton.TabIndex = 2;
            this.addNodeButton.Text = "Add Node";
            this.addNodeButton.UseVisualStyleBackColor = true;
            this.addNodeButton.Click += new System.EventHandler(this.addNodeButton_Click);
            // 
            // nodeListControl
            // 
            this.nodeListControl.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.nodeListControl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.nodeListControl.Location = new System.Drawing.Point(0, 25);
            this.nodeListControl.Name = "nodeListControl";
            this.nodeListControl.Size = new System.Drawing.Size(275, 424);
            this.nodeListControl.TabIndex = 0;
            // 
            // spacingTopPanel
            // 
            this.spacingTopPanel.Controls.Add(this.nodeListLabel);
            this.spacingTopPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.spacingTopPanel.Location = new System.Drawing.Point(0, 0);
            this.spacingTopPanel.Name = "spacingTopPanel";
            this.spacingTopPanel.Size = new System.Drawing.Size(275, 25);
            this.spacingTopPanel.TabIndex = 3;
            // 
            // nodeListLabel
            // 
            this.nodeListLabel.AutoSize = true;
            this.nodeListLabel.Location = new System.Drawing.Point(3, 9);
            this.nodeListLabel.Name = "nodeListLabel";
            this.nodeListLabel.Size = new System.Drawing.Size(38, 13);
            this.nodeListLabel.TabIndex = 1;
            this.nodeListLabel.Text = "Nodes";
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
            this.spacingBottomPanel.ResumeLayout(false);
            this.spacingTopPanel.ResumeLayout(false);
            this.spacingTopPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel nodeListPanel;
        private System.Windows.Forms.Label nodeListLabel;
        private NodeListControl nodeListControl;
        private System.Windows.Forms.Button addNodeButton;
        private System.Windows.Forms.Panel spacingBottomPanel;
        private System.Windows.Forms.Panel spacingTopPanel;
    }
}
