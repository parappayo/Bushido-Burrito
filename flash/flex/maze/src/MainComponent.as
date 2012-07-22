package  
{
	import flash.events.KeyboardEvent;
	import mx.core.UIComponent;
	
	public class MainComponent extends UIComponent
	{
		private var mazeView :MazeView;
		private var mazeData :MazeData;
		
		public function MainComponent()
		{
			mazeData = new MazeData(16, 16);
			mazeData.populate();  // TODO: random gen here
			
			mazeView = new MazeView(mazeData);
			mazeView.viewPos.x = 3;
			mazeView.viewPos.y = 3;
			addChild(mazeView);
		}
	
		public function init() :void
		{
			mazeView.draw();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function handleKeyDown(event :KeyboardEvent) :void
		{
			if (event.keyCode == 38) // up arrow
			{
				mazeView.moveForward();
				mazeView.draw();
			}
			else if (event.keyCode == 40)
			{
				mazeView.moveBack();
				mazeView.draw();
			}
			else if (event.keyCode == 37)
			{
				mazeView.turnLeft();
				mazeView.draw();
			}
			else if (event.keyCode == 39)
			{
				mazeView.turnRight();
				mazeView.draw();
			}
		}
	}

}