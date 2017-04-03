
using System.Collections.Generic;

namespace GraphEdit.Graph
{
    public class Node
    {
        public Dictionary<string, string> Properties = new Dictionary<string, string>();

        public Point Position;

        public string Name
        {
            get { return Properties["name"]; }
        }
    }
}
