package sim.components.action 
{
	import sim.actors.SpriteActor;
	import sim.components.animation.Animations;
	public class ActionStateGrab implements ActionState 
	{
		private var _duration:Number;
		private var _timer:Number;
		
		public function ActionStateGrab(duration:Number)
		{
			_duration = duration;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			_timer = 0;
			actor.handleSignal(game, Signals.ACTION_LOCK, true);
			actor.handleSignal(game, Signals.ANIMATION_PLAY, Animations.PICKUP);
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			if (_timer > _duration)
			{
				return true;
			}
			_timer += elapsed;
			return false;
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.handleSignal(game, Signals.ACTION_LOCK, false);
			actor.handleSignal(game, Signals.ANIMATION_PLAY, Animations.IDLE);
		}
	}
}