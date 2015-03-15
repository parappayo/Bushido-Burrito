package common 
{
	import wyverntail.core.*;
	
	public class PlayerTeleportDestination extends Component
	{
		private var _game :Game;
		private var _name :String;
		private var _pos :Position2D;
		private var _playerPos :Position2D;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_name = spawnArgs.name;
			_pos = getComponent(Position2D) as Position2D;
			_playerPos = prefabArgs.player.getComponent(Position2D) as Position2D;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.TELEPORT_PLAYER)
			{
				if (_name == args.destinationName)
				{
					_playerPos.worldX = _pos.worldX;
					_playerPos.worldY = _pos.worldY;
					
					_game.handleSignal(Signals.CENTER_CAMERA, this, { } );
					return true;
				}
			}
			
			return false;
		}
		
	} // class

} // package
