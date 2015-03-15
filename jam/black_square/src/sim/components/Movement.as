package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.Settings;
	import sim.WorldOrientation;
	import sim.WorldPosition;
	
	public class Movement implements Component 
	{
		private var _speed :Number; // pixels per second
		private var _newPos :WorldPosition;
		private var _newOri :WorldOrientation;
		
		private var _locked :Boolean;
		private var _paused :Boolean;
		private var _moveUp :Boolean;
		private var _moveDown :Boolean;
		private var _moveLeft :Boolean;
		private var _moveRight :Boolean;
		
		public function Movement(speed:Number) 
		{
			_speed = speed;
			_newPos = new WorldPosition();
			_newOri = new WorldOrientation();
			reset();
		}
		
		public function reset() :void
		{
			_locked = false;
			_paused = false;
			_moveUp = false;
			_moveDown = false;
			_moveLeft = false;
			_moveRight = false;
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
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || spriteActor.isDead() || _paused) return;
			
			// speed and distance
			var modifier :Number = 1; 
			if ((_moveUp || _moveDown) && (_moveLeft || _moveRight))
			{
				modifier = 0.7071; // 1 / sqrt(2)
			}
			var moveDistance :Number = elapsed * _speed * modifier;
			
			_newPos.copy(spriteActor.worldPosition);
			_newOri.copy(spriteActor.worldOrientation);
			
			// vertical movement
			if (_moveUp || _moveDown)
			{
				if (_moveUp)
				{
					_newPos.y -= moveDistance;
					_newOri.y = -1;
				}
				else if (_moveDown)
				{
					_newPos.y += moveDistance;
					_newOri.y = 1;
				}
				if (!_moveLeft && !_moveRight) _newOri.x = 0;
			}
			
			// horizontal movement
			if (_moveLeft || _moveRight)
			{
				if (_moveLeft)
				{
					_newPos.x -= moveDistance;
					_newOri.x = -1;
				}
				else if (_moveRight)
				{
					_newPos.x += moveDistance;
					_newOri.x = 1;
				}
				if (!_moveUp && !_moveDown) _newOri.y = 0;
			}
			
			// position
			var horizontalOffset :Number = Settings.TileW / 2;
			if (_moveLeft) { horizontalOffset *= -1; }
			var moveHorizontal :Boolean = false;
			var blockedHorizontal :Boolean = false;
			if (game.getWalkmesh().isWalkable(_newPos.x + horizontalOffset, spriteActor.worldPosition.y))
			{
				moveHorizontal = (_moveLeft || _moveRight);
				spriteActor.worldPosition.x = _newPos.x;
			}
			else
			{
				blockedHorizontal = true;
			}
			var moveVertical :Boolean = false;
			var blockedVertical :Boolean = false;
			if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x + horizontalOffset/2, _newPos.y) &&
				game.getWalkmesh().isWalkable(spriteActor.worldPosition.x - horizontalOffset/2, _newPos.y))
			{
				moveVertical = (_moveUp || _moveDown);
				spriteActor.worldPosition.y = _newPos.y;
			}
			else
			{
				blockedVertical = true;
			}
			
			// orientation
			spriteActor.worldOrientationTarget = _newOri;
			
			// push block testing
			if ( blockedHorizontal || blockedVertical )
			{
				game.checkPush(_newPos, _newOri);
			}
			
			// animation
			const animation :int = (moveHorizontal || moveVertical) ? Animations.WALK : Animations.IDLE;
			spriteActor.handleSignal(game, Signals.ANIM_PLAY, animation);
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			var force :Boolean = args as Boolean;
			if ((_locked && !force) || actor.isDead()) { return; }
			
			switch (signal) 
			{
				case Signals.MOVE_UP_KEYUP:
					_moveUp = false;
					break;
				case Signals.MOVE_UP_KEYDOWN:
					_moveUp = true;
					break;
				case Signals.MOVE_DOWN_KEYUP:
					_moveDown = false;
					break;
				case Signals.MOVE_DOWN_KEYDOWN:
					_moveDown = true;
					break;
				case Signals.MOVE_LEFT_KEYUP:
					_moveLeft = false;
					break;
				case Signals.MOVE_LEFT_KEYDOWN:
					_moveLeft = true;
					break;					
				case Signals.MOVE_RIGHT_KEYUP:
					_moveRight = false;
					break;
				case Signals.MOVE_RIGHT_KEYDOWN:
					_moveRight = true;
					break;
				case Signals.MOVEMENT_PAUSE:
					_paused = true;
					break;
				case Signals.MOVEMENT_UNPAUSE:
					_paused = false;
					break;					
				default:
					break;
			}
		}
	} // class
} // package
