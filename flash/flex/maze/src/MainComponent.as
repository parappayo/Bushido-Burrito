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
			mazeData = new MazeData(64, 64);
			mazeData.populate();
			trace(mazeData.toString());
			
			mazeView = new MazeView(mazeData);
			mazeView.viewPos.x = 1;
			mazeView.viewPos.y = 1;
			addChild(mazeView);
		}
	
		public function init() :void
		{
			mazeView.draw();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function handleKeyDown(event :KeyboardEvent) :void
		{
			if (event.keyCode == 38 || // up arrow
				event.keyCode == 87) // W key
			{
				mazeView.moveForward();
				mazeView.draw();
			}
			else if (event.keyCode == 40 || // back arrow
				event.keyCode == 83) // S key
			{
				mazeView.moveBack();
				mazeView.draw();
			}
			else if (event.keyCode == 37 || // left arrow
				event.keyCode == 65) // A key
			{
				mazeView.turnLeft();
				mazeView.draw();
			}
			else if (event.keyCode == 39 || // right arrow
				event.keyCode == 68) // D key
			{
				mazeView.turnRight();
				mazeView.draw();
			}
			else if (event.keyCode == 81) // Q key
			{
				mazeView.shiftLeft();
				mazeView.draw();
			}
			else if (event.keyCode == 69) // E key
			{
				mazeView.shiftRight();
				mazeView.draw();
			}
		}
	}

}