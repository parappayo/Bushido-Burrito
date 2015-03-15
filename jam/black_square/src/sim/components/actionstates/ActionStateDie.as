package sim.components.actionstates 
{
	import sim.actors.SpriteActor;
	public class ActionStateDie implements ActionState 
	{
		private var _timer:Number;
		private var _flickerTime:Number;
		private var _alphaTarget:Number;
		
		public function ActionStateDie() 
		{
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			_timer = 0;
			_flickerTime = 0.1;
			_alphaTarget = 0;
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
			return (_flickerTime < 0.01);
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.alpha = 0;
			if (actor == game.getPlayer())
			{
				game.handleSignal(Signals.PLAYER_DIED);
			}
		}
	}
}