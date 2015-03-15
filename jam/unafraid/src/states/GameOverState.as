package states 
{
	import starling.display.Sprite;
	import ui.GameOverScreen;
	
	public class GameOverState extends Sprite implements IState 
	{	
		private var game:Game;
		
		private var gameOverScreen:GameOverScreen;
		
		public function GameOverState(game:Game) 
		{
			this.game = game;
			
			gameOverScreen = new GameOverScreen(game);
			game.addChild(gameOverScreen);
		}
		
		public function update():void
		{
			gameOverScreen.update();
		}
		
		public function destroy():void
		{
			game.removeChild(gameOverScreen);
		}
	}
}