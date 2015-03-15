package  
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class InputHandler extends Sprite
	{
		/// where the signals get sent
		public var game :Game;
		
		public function InputHandler(game :Game)
		{
			this.game = game;
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}
		
		private function handleAddedToStage() :void
		{	
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleRemovedFromStage() :void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyUp(keyEvent :KeyboardEvent) :void
		{
			game.handleKeyUp(keyEvent);
		}

		private function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			game.handleKeyDown(keyEvent);
		}
	}

} // package

