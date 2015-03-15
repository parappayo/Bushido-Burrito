package sim.components.actionstates 
{
	import sim.actors.SpriteActor;
	import sim.components.Animations;
	public class ActionStateCheer implements ActionState 
	{
		private var _timer:Number;
		public function ActionStateCheer() 
		{
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			actor.lock();
			actor.handleSignal(game, Signals.MOVEMENT_PAUSE, true);
			actor.handleSignal(game, Signals.ANIM_PLAY, Animations.CHEER);
			_timer = 0;
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer += elapsed;
			return (_timer > 3);
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			actor.handleSignal(game, Signals.MOVEMENT_UNPAUSE, true);
			actor.unlock();
			game.handleSignal(Signals.VICTORY);
		}
	}
}