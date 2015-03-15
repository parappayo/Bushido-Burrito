package sim.components 
{
	import sim.actors.Actor;
	
	public class Input implements Component 
	{
		private var _shootRepeat :Boolean;
		private var _locked :Boolean;
		
		public function Input() 
		{
			_shootRepeat = false;
		}
		
		public function reset() :void
		{
			_shootRepeat = false;
			_locked = false;
		}
		
		public function lock() :void
		{
			_locked = true;
		}
		
		public function unlock() :void
		{
			_locked = false;
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number) :void
		{
			if (_shootRepeat)
			{
				actor.handleSignal(game, Signals.ACTION_EXECUTE, Actions.SHOOT_REPEAT);
			}
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			if (_locked || actor.isDead()) { return; }
			
			switch (signal) 
			{
				case Signals.SHOOT_KEYDOWN:
					{
						_shootRepeat = true;
						actor.handleSignal(game, Signals.ACTION_EXECUTE, Actions.SHOOT);
					}
					break;
					
				case Signals.SHOOT_KEYUP:
					{
						_shootRepeat = false;
					}
					break;
			}
		}
	}
}