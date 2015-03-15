package  
{
	import starling.display.Sprite;
	import starling.events.*;
	
	/**
	 *  This class converts Stage input events into Entity signals.
	 * 
	 *  The only inputs we really care about are four directions and two other
	 *  buttons: accept and back.
	 */
	public class InputHandler extends Sprite
	{
		/// where the signals get sent
		private var _game :Game;
		
		public function InputHandler(game :Game)
		{
			_game = game;
			
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
		}
		
		private function handleKeyUp(keyEvent :KeyboardEvent) :void
		{
			if (_game.handleSignal(Signals.KEYUP_EVENT, this, keyEvent))
			{
				return;
			}

			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				//case 16: // shift
				case 32: // space bar
					{
						_game.handleSignal(Signals.ACTION_KEYUP, this, {});
					}
					break;
					
				case 38: // up arrow key
				case 87: // W key
					{
						_game.handleSignal(Signals.MOVE_UP_KEYUP, this, {});
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						_game.handleSignal(Signals.MOVE_DOWN_KEYUP, this, {});
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{
						_game.handleSignal(Signals.MOVE_LEFT_KEYUP, this, {});
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						_game.handleSignal(Signals.MOVE_RIGHT_KEYUP, this, {});
					}
					break;
					
				case 13: // Enter
				case 90: // Z key
					{
						_game.handleSignal(Signals.ACCEPT_KEYUP, this, {});
					}
					break;
					
				case 27: // Esc
				case 81: // Q key
					{
						_game.handleSignal(Signals.BACK_KEYUP, this, {});
					}
					break;
					
				case 191: // ? or / key
				case 112: // F1 key
					{
						_game.handleSignal(Signals.HELP_KEYUP, this, {});
					}
					break;
			}
		}

		private function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			if (_game.handleSignal(Signals.KEYDOWN_EVENT, this, keyEvent))
			{
				return;
			}

			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				//case 16: // shift
				case 32: // space bar
					{
						_game.handleSignal(Signals.ACTION_KEYDOWN, this, {});
					}
					break;
				
				case 38: // up arrow key
				case 87: // W key
					{
						_game.handleSignal(Signals.MOVE_UP_KEYDOWN, this, {});
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						_game.handleSignal(Signals.MOVE_DOWN_KEYDOWN, this, {});
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{						
						_game.handleSignal(Signals.MOVE_LEFT_KEYDOWN, this, {});
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						_game.handleSignal(Signals.MOVE_RIGHT_KEYDOWN, this, {});
					}
					break;
				
				case 13: // Enter
				case 90: // Z key
					{
						_game.handleSignal(Signals.ACCEPT_KEYDOWN, this, {});
					}
					break;
					
				case 27: // Esc
				case 81: // Q key
					{
						_game.handleSignal(Signals.BACK_KEYDOWN, this, {});
					}
					break;
					
				case 191: // ? or / key
				case 112: // F1 key
					{
						_game.handleSignal(Signals.HELP_KEYDOWN, this, {});
					}
					break;
			}
		}
		
		private function handleTouch(touchEvent :TouchEvent) :void
		{
			if (_game.handleSignal(Signals.TOUCH_EVENT, this, touchEvent))
			{
				return;
			}
			
			if (touchEvent.touches.length > 0 &&
				touchEvent.touches[0].phase == TouchPhase.BEGAN)
			{
				_game.handleSignal(Signals.TOUCH_BEGAN, this, touchEvent);
			}
		}
		
	} // class

} // package
