package ui 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class LevelCompleteScreen extends Sprite
	{
		private var game:Game;
		private var curtain:Quad;
		private var tf_caption:TextField;
		private var framesElapsed:int;
		
		public function LevelCompleteScreen(game:Game) 
		{
			this.game = game;
			
			curtain = new Quad(1280, 720, 0x000080);
			curtain.alpha = 0.8;
			addChild(curtain);
			
			tf_caption = new TextField(1280, 720, "Level Clear", "Consolas", 32, 0x00ffff);
			addChild(tf_caption);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}
		
		private function init():void
		{
			framesElapsed = 0;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleRemovedFromStage():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function update():void
		{
			framesElapsed++;
		}
		
		private function handleKeyDown(keyEvent:KeyboardEvent):void
		{
			if (framesElapsed > 60) // 1 to 2 sec
			{
				game.resetLevel();
				game.changeState(Game.PLAY_STATE);
			}
		}
	}

}
