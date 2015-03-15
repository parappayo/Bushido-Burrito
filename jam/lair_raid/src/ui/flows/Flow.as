package ui.flows 
{
	public class Flow 
	{
		protected var _state :int;
		protected var _child :Flow;
		protected var _parent :Flow;
		
		protected var _timeElapsedInState :Number;
		
		public function Flow(parent :Flow = null) :void
		{
			_state = FlowStates.INIT;
			_parent = parent;
			_timeElapsedInState = 0;
		}
		
		// override to provide per-frame logic
		public function update(elapsed :Number) :void
		{
			_timeElapsedInState += elapsed;
			
			if (_child != null)
			{
				_child.update(elapsed);
			}
		}
		
		// override to handle game signals
		public function handleSignal(signal :int) :void
		{
			if (_child != null)
			{
				_child.handleSignal(signal);
			}			
		}

		public function getState() :int
		{
			return _state;
		}

		public function changeState(newState :int) :Boolean
		{
			var oldState :int = _state;
			
			if (oldState == newState) { return false; }
			
			if (!canChangeState(oldState, newState))
			{
				return false;
			}
			
			_timeElapsedInState = 0;
			
			handleExitState(oldState, newState);
			
			if (_child != null)
			{
				_child.changeState(FlowStates.EXIT);
				_child = null;
			}
			
			_state = newState;

			handleEnterState(oldState, newState);
			
			return true;
		}

		// override to place restrictions on valid state transitions
		protected function canChangeState(oldState :int, newState :int) :Boolean
		{
			return true;
		}
		
		// override to perform state setup logic
		protected function handleEnterState(oldState :int, newState :int) :void
		{
		}
		
		// override to perform state cleanup logic
		protected function handleExitState(oldState :int, newState :int) :void
		{
		}
		
		// called from child flow when it is ready to exit
		public function handleChildDone() :void
		{
		}
		
	} // class

} // package

