package common 
{
	import entities.Player;
	import wyverntail.core.*;

	public class ActionButtonTrigger extends Component
	{
		public var spawnArgs :Object;
		
		private var _game :Game;
		private var _signal :int;
		private var _signalArgs :Object;
		private var _pos :Position2D;
		private var _playerPos :Position2D;
		private var _triggerRadius :Number;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			this.spawnArgs = spawnArgs;
			
			_game = prefabArgs.game;
			_signal = prefabArgs.signal;
			_pos = getComponent(Position2D) as Position2D;
			_playerPos = prefabArgs.player.getComponent(Position2D) as Position2D;
			_triggerRadius = prefabArgs.triggerRadius;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ACTION_KEYUP)
			{
				var distSq :Number = _pos.distanceSquared(_playerPos);
				if (distSq < _triggerRadius * _triggerRadius)
				{
					_game.handleSignal(_signal, this, spawnArgs);
					return true;
				}
			}
			
			return false;
		}
		
	} // class

} // package
