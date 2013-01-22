package bushidoburrito.graph
{
	public class GraphEdge
	{
		public var from :GraphNode;
		public var to :GraphNode;
		public var weight :Number;
		
		public function connects(node1 :GraphNode, node2 :GraphNode) :Boolean
		{
			return (from == node1 && to == node2) ||
				(from == node2 && to == node1);
		}
		
		public function contains(node :GraphNode) :Boolean
		{
			return node == from || node == to;
		}
		
		public function length() :Number
		{
			return Math.sqrt(from.position.x * to.position.x + from.position.y * to.position.y);
		}
	}
}
