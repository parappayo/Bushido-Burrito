package states 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import ui.SplashScreen;
	
	public class MenuState extends Sprite implements IState 
	{
		private var game:Game;		
		private var splashScreen:SplashScreen;
		
		public function MenuState(game:Game) 
		{
			this.game = game;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			splashScreen = new SplashScreen();
			addChild(splashScreen);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChild(splashScreen);
			
			Audio.splashMusicChannel.stop();
		}
		
		public function handleKeyDown(e:KeyboardEvent):void
		{
			game.changeState(Game.PLAY_STATE);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
	}
}