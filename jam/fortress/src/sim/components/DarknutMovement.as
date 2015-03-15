package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	import sim.WorldPosition;

	/**
	 *  Movement controller mimicking classic Zelda Darknut enemy patterns.
	 */
	public class DarknutMovement implements Component
	{
		public static const STATE_IDLE			:int = 0;
		public static const STATE_INIT			:int = 1;
		public static const STATE_WALK_NORTH	:int = 2;
		public static const STATE_WALK_SOUTH	:int = 3;
		public static const STATE_WALK_EAST		:int = 4;
		public static const STATE_WALK_WEST		:int = 5;
		
		public static const ChangeDirectionTimeout :Number = 2.0;
		public static const ChangeDirectionRandomTimeout :Number = 1.5;
		public static const ChangeDirectionMinTimeout :Number = 0.5;
		
		private var _state :int;
		private var _speed :Number; // pixels per second
		private var _newPos :WorldPosition;
		private var _newOri :WorldOrientation;
		private var _walkTimer :Number;
		
		public function DarknutMovement(speed:Number) 
		{
			_state = STATE_INIT;
			_speed = speed;
			_newPos = new WorldPosition();
			_newOri = new WorldOrientation();
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number) :void
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null) return;
			
			_newPos.copy(spriteActor.worldPosition);
			_newOri.copy(spriteActor.worldOrientation);
			
			var moveDistance :Number = elapsed * _speed;
			
			switch (_state)
			{
				case STATE_INIT:
					{
						setRandomWalkDirection();
					}
					break;
					
				default:
					{
						// wait a random time and change directions
						_walkTimer -= elapsed;
						if (_walkTimer <= 0)
						{
							changeWalkDirection();
						}
					}
					break;
			}
			
			// vertical movement
			if (_state == STATE_WALK_NORTH || _state == STATE_WALK_SOUTH)
			{
				if (_state == STATE_WALK_NORTH)
				{
					_newPos.y -= moveDistance;
					_newOri.y = -1;
				}
				else if (_state == STATE_WALK_SOUTH)
				{
					_newPos.y += moveDistance;
					_newOri.y = 1;
				}
				if (_state != STATE_WALK_EAST && _state != STATE_WALK_WEST)
				{
					_newOri.x = 0;
				}
			}
			
			// horizontal movement
			if (_state == STATE_WALK_EAST || _state == STATE_WALK_WEST)
			{
				if (_state == STATE_WALK_EAST)
				{
					_newPos.x -= moveDistance;
					_newOri.x = -1;
				}
				else if (_state == STATE_WALK_WEST)
				{
					_newPos.x += moveDistance;
					_newOri.x = 1;
				}
				if (_state != STATE_WALK_NORTH && _state != STATE_WALK_SOUTH)
				{
					_newOri.y = 0;
				}
			}
			
			var isMoving :Boolean = false;
			var hitWall :Boolean = false;

			var horizontalOffset :Number = Settings.TileW / 2;
			if (_state == STATE_WALK_EAST) { horizontalOffset *= -1; }

			if (game.getWalkmesh().isWalkable(_newPos.x + horizontalOffset, spriteActor.worldPosition.y))
			{
				isMoving = isMoving || (spriteActor.worldPosition.x - _newPos.x < 0.1);
				spriteActor.worldPosition.x = _newPos.x;
			}
			else
			{
				hitWall = true;
			}
			if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x + horizontalOffset/2, _newPos.y) &&
				game.getWalkmesh().isWalkable(spriteActor.worldPosition.x - horizontalOffset/2, _newPos.y))
			{
				isMoving = isMoving || (spriteActor.worldPosition.y - _newPos.y < 0.1);
				spriteActor.worldPosition.y = _newPos.y;
			}
			else
			{
				hitWall = true;
			}
			
			if (hitWall)
			{
				// could do smarter stuff here, like see which direction is open
				if (Math.random() < 0.5)
				{
					reverseDirection();
				}
				else
				{
					changeWalkDirection();
				}
			}
			
			spriteActor.worldOrientationTarget = _newOri;
			
			const animation :int = isMoving ? Animations.WALK : Animations.IDLE;
			spriteActor.handleSignal(game, Signals.ANIM_PLAY, animation);
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			// no need to do anything here
		}
		
		private function resetWalkTimer():void
		{
			_walkTimer = ChangeDirectionTimeout + Math.random() * ChangeDirectionRandomTimeout;
			if (_walkTimer < ChangeDirectionMinTimeout) { _walkTimer = ChangeDirectionMinTimeout; }
		}
		
		private function setRandomWalkDirection():void
		{
			resetWalkTimer();

			var rand :Number = Math.random();
			if (rand < 0.25) { _state = STATE_WALK_NORTH; }
			else if (rand < 0.5) { _state = STATE_WALK_SOUTH; }
			else if (rand < 0.75) { _state = STATE_WALK_EAST; }
			else { _state = STATE_WALK_WEST; }
		}
		
		private function changeWalkDirection():void
		{
			resetWalkTimer();

			var rand :Number = Math.random();
			switch (_state)
			{
				case STATE_WALK_NORTH:
				case STATE_WALK_SOUTH:
					{
						if (rand < 0.5) { _state = STATE_WALK_EAST; }
						else { _state = STATE_WALK_WEST; }
					}
					break;

				case STATE_WALK_EAST:
				case STATE_WALK_WEST:
					{
						if (rand < 0.5) { _state = STATE_WALK_NORTH; }
						else { _state = STATE_WALK_SOUTH; }
					}
					break;
			}
		}
		
		private function reverseDirection():void
		{
			resetWalkTimer();

			switch (_state)
			{
				case STATE_WALK_NORTH:
					{
						_state = STATE_WALK_SOUTH;
					}
					break;

				case STATE_WALK_SOUTH:
					{
						_state = STATE_WALK_NORTH;
					}
					break;

				case STATE_WALK_EAST:
					{
						_state = STATE_WALK_WEST;
					}
					break;

				case STATE_WALK_WEST:
					{
						_state = STATE_WALK_EAST;
					}
					break;
				}
		}
		
	} // class
	
} // package
