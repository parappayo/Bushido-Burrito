package states 
{
	import starling.display.Sprite;
	import ui.LevelCompleteScreen;
	
	public class LevelCompleteState extends Sprite implements IState 
	{	
		private var game:Game;
		
		private var levelCompleteScreen:LevelCompleteScreen;
		
		public function LevelCompleteState(game:Game) 
		{
			this.game = game;

			levelCompleteScreen = new LevelCompleteScreen(game);
			game.addChild(levelCompleteScreen);
		}
		
		public function update():void
		{
			levelCompleteScreen.update();
		}
		
		public function destroy():void
		{
			game.removeChild(levelCompleteScreen);
		}
	}
}
