package bushidoburrito.graph
{
	import mx.core.UIComponent;
	
	public class MainComponent extends UIComponent
	{
		private var graphView :GraphView;
		
		public function MainComponent()
		{
			graphView = new GraphView();
			addChild(graphView);
			
			// populate test data
			graphView.data.populateTest();
		}
	
		public function init() :void
		{
			graphView.draw();
		}
	}

}