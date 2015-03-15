package sim.components.actionstates 
{
	import sim.actors.SpriteActor;
	import sim.components.Animations;
	public class ActionStateDie implements ActionState 
	{
		private var _playAnim:Boolean;
		private var _timer:Number;
		private var _flickerTime:Number;
		private var _alphaTarget:Number;
		
		public function ActionStateDie(playAnim:Boolean = false) 
		{
			_playAnim = playAnim;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			_timer = 0;
			_flickerTime = 0.15;
			_alphaTarget = 0;
			actor.handleSignal(game, Signals.MOVEMENT_PAUSE, true);
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer += elapsed;
			if (_timer > _flickerTime)
			{
				actor.alpha = _alphaTarget;
				_timer = 0;
				_flickerTime -= 0.01;
				_alphaTarget = (_alphaTarget == 0) ? 1 : 0;
			}
			if (_playAnim)
			{
				actor.handleSignal(game, Signals.ANIM_PLAY, Animations.DEAD);
			}
			return (_flickerTime < 0.01);
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.alpha = 0;
			actor.handleSignal(game, Signals.MOVEMENT_UNPAUSE, true);
			if (actor == game.getPlayer())
			{
				game.handleSignal(Signals.PLAYER_DIED);
			}
		}
	}
}