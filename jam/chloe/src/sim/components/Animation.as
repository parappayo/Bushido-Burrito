package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.components.animation.*;
	
	public class Animation implements Component 
	{	
		private var _current:int;
		private var _target:int;
		private var _state:AnimState;
		private var _bank:AnimationBank;
		
		public function Animation(bank:AnimationBank) 
		{
			_bank = bank;
			reset();
		}
		
		public function reset():void
		{
			_current = Animations.NONE;
			_target = Animations.NONE;
			_state = null;
		}
		
		public function update(game:Game, actor:Actor, elapsed:Number):void 
		{	
			var spriteActor:SpriteActor = actor as SpriteActor;
			if (spriteActor == null) return;
			
			// update the current state
			if (_state != null)
			{
				_state.update(spriteActor, elapsed);
			}
			
			// change to a new state?
			if (_target != _current)
			{
				var done :Boolean = (_state != null) ? _state.exit(spriteActor) : true;
				if (done)
				{
					_current = _target;
					_state = _bank.find(_current);
					_state.enter(spriteActor);
				}
			}
		}
		
		public function handleSignal(game:Game, actor:Actor, signal:int, args:Object):void 
		{
			switch (signal)
			{
				case Signals.ANIMATION_PLAY:
					play(int(args));
					break;
			}
		}
		
		public function play(animation:int):void
		{
			if (_bank.find(animation) != null)
			{
				_target = animation;
			}
		}
		
		public function exit(actor:SpriteActor):void
		{
			if (_state)
			{
				_state.exit(actor, true);
			}
			reset();
		}
		
		public function isDone():Boolean
		{
			return _state != null && _state.isDone();
		}
		
	} // class
} // package
