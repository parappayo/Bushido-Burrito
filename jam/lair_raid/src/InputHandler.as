package  
{
	import starling.display.Sprite;
	import starling.events.*;
	
	/**
	 *  This class converts Stage input events into Actor signals.
	 * 
	 *  The only inputs we really care about are four directions and two other
	 *  buttons: accept and back.
	 */
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
			stage.addEventListener(TouchEvent.TOUCH, handleTouch);
		}

		private function handleRemovedFromStage() :void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
		}
		
		private function handleKeyUp(keyEvent :KeyboardEvent) :void
		{
			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				case 38: // up arrow key
				case 87: // W key
					{
						game.handleSignal(Signals.MOVE_UP_KEYUP);
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						game.handleSignal(Signals.MOVE_DOWN_KEYUP);
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{
						game.handleSignal(Signals.MOVE_LEFT_KEYUP);
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						game.handleSignal(Signals.MOVE_RIGHT_KEYUP);
					}
					break;
					
				case 13: // Enter
				case 79: // O
					{
						game.handleSignal(Signals.ACCEPT_KEYUP);
					}
					break;
					
				case 90: // Z key
					{
						game.handleSignal(Signals.ACCEPT_KEYUP);
					}
					break;
					
				case 27: // Esc
				case 81: // Q key
					{
						game.handleSignal(Signals.BACK_KEYUP);
					}
					break;
			}
		}

		private function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				case 38: // up arrow key
				case 87: // W key
					{
						game.handleSignal(Signals.MOVE_UP_KEYDOWN);
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						game.handleSignal(Signals.MOVE_DOWN_KEYDOWN);
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{						
						game.handleSignal(Signals.MOVE_LEFT_KEYDOWN);
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						game.handleSignal(Signals.MOVE_RIGHT_KEYDOWN);
					}
					break;
				
				case 13: // Enter
				case 79: // O
					{
						game.handleSignal(Signals.ACCEPT_KEYDOWN);
					}
					break;

				case 90: // Z key
					{
						game.handleSignal(Signals.ACCEPT_KEYDOWN);
					}
					break;
					
				case 27: // Esc
				case 81: // Q key
					{
						game.handleSignal(Signals.BACK_KEYDOWN);
					}
					break;
			}
		}
		
		private function handleTouch(event :TouchEvent) :void
		{
			var touch :Touch = event.getTouch(game.stage);
			
			if (!touch) { return; }
			
			if (touch.phase == TouchPhase.ENDED)
			{
				game.handleSignal(Signals.ACCEPT_KEYUP);
			}
			else if (touch.phase == TouchPhase.BEGAN)
			{
				game.handleSignal(Signals.ACCEPT_KEYDOWN);				
			}
		}
		
	} // class

} // package
