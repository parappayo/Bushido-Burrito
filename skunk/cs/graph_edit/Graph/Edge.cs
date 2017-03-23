
using System.Collections.Generic;

namespace GraphEdit.Graph
{
    public class Edge
    {
        public Dictionary<string, string> Properties = new Dictionary<string, string>();

        public Node From;

        public Node To;

        public bool Bidirectional = true;
    }
}
