using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace FileHomer
{
	public partial class MainForm : Form
	{
		public MainForm()
		{
			this.FormClosed += MainForm_FormClosed;
			this.Width = 800;
			this.Height = 600;
			this.Text = "File Homer";

			MainMenu mainMenu = new MainMenu();
			{
				MenuItem fileMenu = new MenuItem();
				fileMenu.Text = "&File";
				{
					MenuItem exitItem = new MenuItem();
					exitItem.Text = "&Exit";
					exitItem.Click += new EventHandler(exitItem_Click);
					fileMenu.MenuItems.Add(exitItem);
				}
				mainMenu.MenuItems.Add(fileMenu);
			}
			{
				MenuItem editMenu = new MenuItem();
				editMenu.Text = "&Edit";
				mainMenu.MenuItems.Add(editMenu);
			}
			{
				MenuItem toolsMenu = new MenuItem();
				toolsMenu.Text = "&Tools";
				mainMenu.MenuItems.Add(toolsMenu);
			}
			{
				MenuItem helpMenu = new MenuItem();
				helpMenu.Text = "&Help";
				{
					MenuItem webItem = new MenuItem();
					webItem.Text = "&Web Site";
					webItem.Click += new EventHandler(webItem_Click);
					helpMenu.MenuItems.Add(webItem);
				}
				mainMenu.MenuItems.Add(helpMenu);
			}
			this.Menu = mainMenu;

			mSearchListBox = new ListBox();
			mSearchListBox.Dock = DockStyle.Fill;
			mSearchListBox.DoubleClick += mSearchListBox_DoubleClick;
			mSearchListBox.KeyDown += mSearchListBox_KeyDown;
			Controls.Add(mSearchListBox);

			mStatusLabel = new ToolStripStatusLabel();
			mStatusLabel.Dock = DockStyle.Fill;
			mStatusLabel.Text = "Hello!";

			mStatusStrip = new StatusStrip();
			mStatusStrip.Items.Add((ToolStripItem) mStatusLabel);
			Controls.Add(mStatusStrip);

			mSearchTextBox = new TextBox();
			mSearchTextBox.Dock = DockStyle.Top;
			mSearchTextBox.TextChanged += mSearchTextBox_TextChanged;
			Controls.Add(mSearchTextBox);

			mConfig = new Config();
			mIndexer = new DirectoryIndexer();
			mIndexer.ProjectRoot = mConfig.ProjectRoot;
			mIndexer.MaxIndexSize = mConfig.MaxIndexSize;
			mIndexer.MaxSearchResults = mConfig.MaxSearchResults;
			mIndexer.IndexingThread.Start();
			
			mStatusUpdateTimer = new Timer();
			mStatusUpdateTimer.Interval = 500;
			mStatusUpdateTimer.Tick += new EventHandler(mStatusUpdateTimer_Tick);
			mStatusUpdateTimer.Start();
		}

		void mStatusUpdateTimer_Tick(object sender, EventArgs e)
		{
			switch (mIndexer.Status)
			{
				case DirectoryIndexer.IndexingStatus.Done:
					{
						StringBuilder str = new StringBuilder();
						str.Append("Finished indexing ");
						str.Append(mIndexer.FileCount);
						str.Append(" files.");
						mStatusLabel.Text = str.ToString();
					}
					break;
				case DirectoryIndexer.IndexingStatus.Working:
					{
						StringBuilder str = new StringBuilder();
						str.Append("Indexing ");
						str.Append(mIndexer.FileCount);
						str.Append(" files, please be patient.");
						mStatusLabel.Text = str.ToString();
					}
					break;
			}
		}

		void exitItem_Click(object sender, EventArgs e)
		{
			Close();
		}

		void webItem_Click(object sender, EventArgs e)
		{
			System.Diagnostics.Process.Start(
				"http://code.google.com/p/filehomer/");
		}

		// child components
		public TextBox mSearchTextBox;
		public ListBox mSearchListBox;
		public StatusStrip mStatusStrip;
		public ToolStripStatusLabel mStatusLabel;

		private Config mConfig;
		private DirectoryIndexer mIndexer;
		private Timer mStatusUpdateTimer;

		private void mSearchTextBox_TextChanged(object sender, EventArgs e)
		{
			DoSearch();
		}

		private void DoSearch()
		{
			mSearchListBox.Items.Clear();
			if (mSearchTextBox.Text.Length < 3) { return; }			
			
			StringBuilder searchPattern = new StringBuilder();
			searchPattern.Append(mSearchTextBox.Text);

			string[] files = mIndexer.GetFiles(searchPattern.ToString());

			mSearchListBox.Items.AddRange(files);
		}

		private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
		{
			mIndexer.IndexingThread.Abort();
		}

		private void mSearchListBox_DoubleClick(object sender, EventArgs e)
		{
			OpenSelectedFile();
		}

		private void mSearchListBox_KeyDown(object ssneder, KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Enter)
			{
				OpenSelectedFile();
			}
		}

		private void OpenSelectedFile()
		{
			if (mSearchListBox.SelectedItem != null)
			{
				System.Diagnostics.Process.Start(
					mSearchListBox.SelectedItem.ToString());
			}
		}
	}
}

