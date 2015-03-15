package bushidoburrito.graph
{
	import flash.geom.Point;
	
	public class GraphData
	{
		public var nodes :Vector.<GraphNode>;
		public var edges :Vector.<GraphEdge>;
		
		public function GraphData()
		{
			nodes = new Vector.<GraphNode>();
			edges = new Vector.<GraphEdge>();
		}
		
		public function populateTest() :void
		{	
			createNode(new Point(50, 50), 1);
			createNode(new Point(300, 50), 1);
			createNode(new Point(300, 300), 1);
			
			createEdge(nodes[0], nodes[1]);
			createEdge(nodes[0], nodes[2]);
		}
		
		public function createNode(position :Point, weight :Number) :GraphNode
		{
			var node :GraphNode = new GraphNode();
			node.position = position;
			node.weight = weight;
			
			nodes.push(node);
			return node;
		}
		
		public function createEdge(from :GraphNode, to :GraphNode) :GraphEdge
		{
			var edge :GraphEdge = new GraphEdge();
			edge.from = from;
			edge.to = to;
			
			edges.push(edge);
			return edge;
		}
	}
}
