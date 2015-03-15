package sim.components 
{
	import sim.*;
	import sim.actors.*;
	
	public class ChaseMovement implements Component
	{
		private var _speed :Number; // pixels per second
		private var _newPos :WorldPosition;
		private var _newOri :WorldOrientation;

		public var ChasePlayer :Boolean;
		private var _chasePos :WorldPosition; // position to seek to
		
		public function ChaseMovement(speed:Number) 
		{
			_speed = speed;
			_newPos = new WorldPosition();
			_newOri = new WorldOrientation();
			ChasePlayer = true;
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number) :void
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null) return;
			
			_newPos.copy(spriteActor.worldPosition);
			_newOri.copy(spriteActor.worldOrientation);
			
			var moveUp :Boolean = false;
			var moveDown :Boolean = false;
			var moveLeft :Boolean = false;
			var moveRight :Boolean = false;
			
			if (ChasePlayer)
			{
				_chasePos = game.getPlayer().worldPosition;
			}
			
			if (spriteActor.worldPosition.x > _chasePos.x + 2)
			{
				moveLeft = true;
			}
			else if (spriteActor.worldPosition.x < _chasePos.x - 2)
			{
				moveRight = true;
			}
			if (spriteActor.worldPosition.y < _chasePos.y - 2)
			{
				moveDown = true;
			}
			else if (spriteActor.worldPosition.y > _chasePos.y + 2)
			{
				moveUp = true;
			}

			var modifier :Number = 1;
			if ((moveUp || moveDown) && (moveLeft || moveRight))
			{
				modifier = 0.7071;
			}
			var moveDistance :Number = elapsed * _speed * modifier;

			// vertical movement
			if (moveUp || moveDown)
			{
				if (moveUp)
				{
					_newPos.y -= moveDistance;
					_newOri.y = -1;
				}
				else if (moveDown)
				{
					_newPos.y += moveDistance;
					_newOri.y = 1;
				}
				if (!moveLeft && !moveRight) _newOri.x = 0;
			}
			
			// horizontal movement
			if (moveLeft || moveRight)
			{
				if (moveLeft)
				{
					_newPos.x -= moveDistance;
					_newOri.x = -1;
				}
				else if (moveRight)
				{
					_newPos.x += moveDistance;
					_newOri.x = 1;
				}
				if (!moveUp && !moveDown) _newOri.y = 0;
			}

			var horizontalOffset :Number = Settings.TileW / 2;
			if (moveLeft) { horizontalOffset *= -1; }
			
			var isMoving :Boolean = false;
			if (game.getWalkmesh().isWalkable(_newPos.x + horizontalOffset, spriteActor.worldPosition.y))
			{
				isMoving = isMoving || (spriteActor.worldPosition.x - _newPos.x < 0.1);
				spriteActor.worldPosition.x = _newPos.x;
			}
			if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x + horizontalOffset/2, _newPos.y) &&
				game.getWalkmesh().isWalkable(spriteActor.worldPosition.x - horizontalOffset/2, _newPos.y))
			{
				isMoving = isMoving || (spriteActor.worldPosition.y - _newPos.y < 0.1);
				spriteActor.worldPosition.y = _newPos.y;
			}
			
			spriteActor.worldOrientationTarget = _newOri;
			
			const animation :int = isMoving ? Animations.WALK : Animations.IDLE;
			spriteActor.handleSignal(game, Signals.ANIM_PLAY, animation);
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			// no need to do anything here
		}
		
		public function setChasePosition(pos:WorldPosition):void
		{
			ChasePlayer = false;
			_chasePos = pos;
		}
		
		public function getChasePosition():WorldPosition
		{
			return _chasePos;
		}
		
	} // class

} // package
