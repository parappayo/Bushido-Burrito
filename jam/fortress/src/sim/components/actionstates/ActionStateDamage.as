package sim.components.actionstates 
{
	import sim.actors.SpriteActor;
	public class ActionStateDamage implements ActionState 
	{
		private var _timer:Number;
		private var _totalTime:Number
		private var _alphaTarget:Number;
		
		public function ActionStateDamage() 
		{
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			_timer = 0;
			_totalTime = 0;
			_alphaTarget = 0;
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer += elapsed;
			_totalTime += elapsed;
			if (_timer > 0.02)
			{
				_timer = 0;
				actor.alpha = _alphaTarget;
				_alphaTarget = (_alphaTarget == 0) ? 1 : 0;
			}
			return (_totalTime > 0.2);
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.alpha = 1;
		}
	}
}