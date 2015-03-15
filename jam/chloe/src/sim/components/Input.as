package sim.components 
{
	import sim.actors.Actor;
	import sim.components.action.Actions;
	import sim.components.movement.MoveUpdate;
	
	public class Input implements Component 
	{
		private var _locked:Boolean;
		private var _moveUp:Boolean;
		private var _moveDown:Boolean;
		private var _moveLeft:Boolean;
		private var _moveRight:Boolean;
		private var _moveUpdate:MoveUpdate;
		
		public function Input() 
		{
			_moveUpdate = new MoveUpdate();
			reset();
		}
		
		public function reset():void
		{
			_locked = false;
			_moveUp = false;
			_moveDown = false;
			_moveLeft = false;
			_moveRight = false;
			_moveUpdate.reset();
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number):void
		{
			if (_locked) return;
			_moveUpdate.setValues(_moveUp, _moveDown, _moveLeft, _moveRight);
			actor.handleSignal(game, Signals.MOVEMENT_UPDATE, _moveUpdate);
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object):void
		{
			if (actor.isDead()) { return; }
			switch (signal) 
			{
				case Signals.MOVE_UP_KEYUP:
					_moveUp = false;
					break;
				case Signals.MOVE_UP_KEYDOWN:
					_moveUp = true;
					break;
				case Signals.MOVE_DOWN_KEYUP:
					_moveDown = false;
					break;
				case Signals.MOVE_DOWN_KEYDOWN:
					_moveDown = true;
					break;
				case Signals.MOVE_LEFT_KEYUP:
					_moveLeft = false;
					break;
				case Signals.MOVE_LEFT_KEYDOWN:
					_moveLeft = true;
					break;					
				case Signals.MOVE_RIGHT_KEYUP:
					_moveRight = false;
					break;
				case Signals.MOVE_RIGHT_KEYDOWN:
					_moveRight = true;
					break;
				case Signals.ACTION_KEYDOWN:
					if (!_locked) actor.handleSignal(game, Signals.INTERACT_EVENT, null);
					break;
				case Signals.ACTION_LOCK:
					_locked = args as Boolean;
					break;					
				default:
					break;
			}
		}
	}
}