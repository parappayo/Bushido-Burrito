package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.components.actionstates.ActionState;
	public class Action implements Component 
	{
		private var _current:int;
		private var _target:int;
		private var _state:ActionState;
		private var _bank:ActionBank;
		
		public function Action(bank:ActionBank) 
		{
			_bank = bank;
			reset();
		}
		
		public function reset():void
		{
			_current = Actions.NONE;
			_target = Actions.NONE;
			_state = null;
		}
		
		public function update(game:Game, actor:Actor, elapsed:Number):void 
		{
			var spriteActor:SpriteActor = actor as SpriteActor;
			if (spriteActor == null) return;
			
			// update the current state
			const done:Boolean = (_state != null) ? _state.update(game, spriteActor, elapsed) : true;

			if (done || _target == Actions.CHEER || _target == Actions.DIE)
			{
				_current = Actions.NONE;
				if (_state != null)
				{
					_state.exit(game, spriteActor);
					_state = null;
				}
				
				// change to a new state?
				if (_target != _current)
				{
					_current = _target;
					_target = Actions.NONE;
					_state = _bank.find(_current);
					if (_state != null)
					{
						_state.enter(game, spriteActor);
					}
				}
			}
		}
		
		public function handleSignal(game:Game, actor:Actor, signal:int, args :Object):void 
		{
			switch (signal)
			{
				case Signals.ACTION_EXECUTE:
					execute(int(args));
					break;					
			}
		}
		
		public function execute(action:int):void
		{
			// not allowed to leave these states
			if (_current == Actions.CHEER || _target == Actions.CHEER || _current == Actions.DIE || _target == Actions.DIE)
			{
				return;
			}
			
			if (_bank.find(action) != null)
			{
				_target = action;
			}
		}
	}
}