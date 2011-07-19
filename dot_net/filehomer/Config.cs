using System;
using System.IO;
using System.Xml;

namespace FileHomer
{
	class Config
	{
		public Config()
		{
			const string configFile = "filehomer.xml";

			SetDefaults();
	
			// TODO: look in app config dir, user home dir
			if (File.Exists(configFile))
			{
				LoadFromFile(configFile);
			}
			else
			{
				SaveToFile(configFile);
			}
		}

		public void LoadFromFile(string filename)
		{
			mConfigXml = new XmlDocument();
			mConfigXml.Load(filename);

			XmlNodeList nodeList = mConfigXml.GetElementsByTagName("ProjectRoot");
			foreach (XmlNode node in nodeList)
			{
				mProjectRoot = node.InnerText;
				break;  // TODO: process the whole list
			}
		}

		public void SaveToFile(string filename)
		{
			mConfigXml = new XmlDocument();

			XmlNode node = mConfigXml.CreateNode(XmlNodeType.XmlDeclaration, "", "");
			mConfigXml.AppendChild(node);

			XmlNode root = mConfigXml.CreateElement("", "root", "");
			mConfigXml.AppendChild(root);

			node = mConfigXml.CreateElement("ProjectRoot");
			root.AppendChild(node);

			XmlText x = mConfigXml.CreateTextNode(ProjectRoot);
			node.AppendChild(x);

			mConfigXml.Save(filename);
		}
		
		private XmlDocument mConfigXml;

		// TODO: need system for specifying multiple roots
		public string ProjectRoot
		{
			get { return mProjectRoot; }
		}
		private string mProjectRoot;

		private void SetDefaults()
		{
			mProjectRoot = Environment.GetFolderPath(Environment.SpecialFolder.Personal);
		}
	}
}

