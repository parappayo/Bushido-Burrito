package bushidoburrito.graph
{
	import flash.display.Sprite;
	
	public class GraphView extends Sprite
	{
		public var data :GraphData;
		
		public var lineThickness :uint;
		public var nodeRadius :uint;
		
		public function GraphView()
		{
			data = new GraphData();
			
			lineThickness = 5;
			nodeRadius = 30;
		}
		
		public function draw() :void
		{
			
			// clear
			graphics.lineStyle(0);
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();

			graphics.lineStyle(lineThickness, 0x000000);
			
			for each (var edge :GraphEdge in data.edges)
			{
				graphics.moveTo(edge.from.position.x, edge.from.position.y);
				graphics.lineTo(edge.to.position.x, edge.to.position.y);
			}
			
			for each (var node :GraphNode in data.nodes)
			{
				graphics.beginFill(0x00ffff);
				graphics.drawCircle(node.position.x, node.position.y, nodeRadius);
				graphics.endFill();
			}
		}
	}
}
