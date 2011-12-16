using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Threading;

namespace FileHomer
{
	class DirectoryIndexer
	{
		public DirectoryIndexer()
		{
			mStatus = IndexingStatus.Empty;
			mKnownFiles = new ArrayList();
			mIndexingThread = new Thread(new ThreadStart(IndexingThreadFunc));
			mStatus = IndexingStatus.Empty;
			
			// default settingss
			mProjectRoot = ".";
			mMaxIndexSize = 20000;
			mMaxSearchResults = 50;
			mSearchWholePathString = false;
		}

		// TODO: need to allow more than one root
		private string mProjectRoot;
		public string ProjectRoot
		{
			get
			{
				return mProjectRoot;
			}

			set
			{
				mProjectRoot = value;
				mKnownFiles.Clear();
			}
		}
		
		private uint mMaxIndexSize;
		public uint MaxIndexSize
		{
			get { return mMaxIndexSize; }
			set { mMaxIndexSize = value; }
		}
	
		private uint mMaxSearchResults;
		public uint MaxSearchResults
		{
			get { return mMaxSearchResults; }
			set { mMaxSearchResults = value; }
		}
		
		private bool mSearchWholePathString;
		public bool SearchWholePathString
		{
			get { return mSearchWholePathString; }
			set { mSearchWholePathString = value; }
		}
		
		public Thread IndexingThread
		{
			get { return mIndexingThread; }
		}
		private Thread mIndexingThread;
		
		private void IndexingThreadFunc()
		{
			mStatus = IndexingStatus.Working;
			BuildIndex(mProjectRoot, "*");
			mStatus = IndexingStatus.Done;
		}
		
		public enum IndexingStatus
		{
			Empty,
			Working,
			Done,
		}
		
		public IndexingStatus Status
		{
			get { return mStatus; }
		}
		private IndexingStatus mStatus;
		
		private ArrayList mKnownFiles;

		private void BuildIndex(string root, string searchPattern)
		{
			string[] files = Directory.GetFiles(root);//, searchPattern);

			foreach (string file in files)
			{
				if (mKnownFiles.Count >= mMaxIndexSize) { break; }
				AddFile(Path.GetFileName(file), file);
			}
			string[] dirs = Directory.GetDirectories(root);
			foreach (string dir in dirs)
			{
				if (mKnownFiles.Count >= mMaxIndexSize) { break; }
				BuildIndex(dir, searchPattern);
			}
		}

		private void AddFile(string name, string path)
		{
			lock (mKnownFiles)
			{
				mKnownFiles.Add(path);
			}
		}

		public string[] GetFiles(string searchPattern)
		{
			lock (mKnownFiles)
			{
				ArrayList tempList = new ArrayList();
				foreach (string file in mKnownFiles)
				{
					string searchText;
					if (mSearchWholePathString)
					{
						searchText = file;
					}
					else
					{
						searchText = Path.GetFileName(file);
					}
			
					// TODO: supporting regexes would be a nice option
					//if (Regex.IsMatch(searchText, searchPattern, RegexOptions.IgnoreCase))
					if (searchText.IndexOf(searchPattern) != -1)
					{
						tempList.Add(file);
						if (tempList.Count >= mMaxSearchResults) { break; }
					}
				}

				string[] retval = new string[tempList.Count];
				for (int i = 0; i < tempList.Count; i++)
				{
					retval[i] = (string)tempList[i];
				}
				return retval;
			}
		}
		
		public int FileCount
		{
			get
			{
				lock (mKnownFiles)
				{
					return mKnownFiles.Count;				
				}				
			}
		}
	}
}
