package common 
{
	import wyverntail.core.*;

	public class ProximityTrigger extends Component
	{
		public var spawnArgs :Object;
		
		private var _game :Game;
		private var _signal :int;
		private var _signalArgs :Object;
		private var _pos :Position2D;
		private var _playerPos :Position2D;
		private var _triggerRadius :Number;
		private var _isTriggered :Boolean;
		private var _canRepeat :Boolean;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			this.spawnArgs = spawnArgs;
			
			_game = prefabArgs.game;
			_signal = prefabArgs.signal;
			_pos = getComponent(Position2D) as Position2D;
			_playerPos = prefabArgs.player.getComponent(Position2D) as Position2D;
			_triggerRadius = prefabArgs.triggerRadius;
			_isTriggered = false;
			_canRepeat = prefabArgs.canRepeat;
		}
		
		override public function update(elapsed :Number) :void
		{
			var distSq :Number = _pos.distanceSquared(_playerPos);
			if (distSq < _triggerRadius * _triggerRadius)
			{
				if (!_isTriggered)
				{
					_game.handleSignal(_signal, this, spawnArgs);
					
					_isTriggered = true;
				}
			}
			else if (_canRepeat && distSq > _triggerRadius * _triggerRadius * 1.44)
			{
				_isTriggered = false;
			}
		}
		
	} // class

} // package
