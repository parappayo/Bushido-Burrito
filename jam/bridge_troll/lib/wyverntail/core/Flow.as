//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	public class Flow 
	{
		protected var _state :int;
		protected var _child :Flow;
		protected var _parent :Flow;
		
		protected var _timeElapsedInState :Number;
		protected var _signalQueue :Vector.<QueuedSignal>;
		
		public function Flow(parent :Flow = null) :void
		{
			_state = FlowStates.INIT;
			_parent = parent;
			_timeElapsedInState = 0;
			_signalQueue = new Vector.<QueuedSignal>();
		}
		
		// override to provide per-frame logic
		public function update(elapsed :Number) :void
		{
			_timeElapsedInState += elapsed;
			
			if (_child != null)
			{
				_child.update(elapsed);
			}
			
			while (_signalQueue.length > 0)
			{
				var signal :QueuedSignal = _signalQueue.pop();
				handleSignal(signal.signal, signal.sender, signal.args);
			}
		}
		
		// override to handle game signals
		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_child != null)
			{
				return _child.handleSignal(signal, sender, args);
			}
			return false;
		}
		
		public function queueSignal(signal :int, sender :Object, args :Object) :void
		{
			var queuedSignal :QueuedSignal = new QueuedSignal();
			queuedSignal.signal = signal;
			queuedSignal.sender = sender;
			queuedSignal.args = args;
			
			_signalQueue.push(queuedSignal);
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

class QueuedSignal
{
	public var signal :int;
	public var sender :Object;
	public var args :Object;
}
