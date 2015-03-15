package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.WorldOrientation;
	import sim.WorldPosition;

	/**
	 *  AI sweeps side to side with some random variation
	 */
	public class SweepMovement implements Component
	{
		public static const STATE_IDLE			:int = 0;
		public static const STATE_INIT			:int = 1;
		public static const STATE_WALK_TO		:int = 2;
		public static const STATE_WALK_FRO		:int = 3;
		
		public static const ChangeDirectionTimeout :Number = 2.0;
		public static const ChangeDirectionRandomTimeout :Number = 1.5;
		public static const ChangeDirectionMinTimeout :Number = 0.5;
		
		private var _state :int;
		private var _speed :Number; // pixels per second
		private var _newPos :WorldPosition;
		private var _newOri :WorldOrientation;
		private var _walkTimer :Number;
		
		public var randomMovement :Boolean;
		public var eastWest :Boolean; // if false, then north-south
		
		public function SweepMovement(speed:Number) 
		{
			_state = STATE_INIT;
			_speed = speed;
			_newPos = new WorldPosition();
			_newOri = new WorldOrientation();
			
			randomMovement = false;
			eastWest = false;
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
						resetWalkTimer();
						if (randomMovement) { setRandomWalkDirection(); }
						else { _state = STATE_WALK_TO; }
					}
					break;
					
				default:
					{
						// wait a random time and change directions
						_walkTimer -= elapsed;
						if (_walkTimer <= 0)
						{
							reverseDirection();
						}
					}
					break;
			}
			
			// horizontal movement
			if (_state == STATE_WALK_TO || _state == STATE_WALK_FRO)
			{
				if (_state == STATE_WALK_TO)
				{
					if (eastWest)
					{
						_newPos.x += moveDistance;
						_newOri.x = 1;
					}
					else
					{
						_newPos.y += moveDistance;
						_newOri.y = 1;
					}
				}
				else if (_state == STATE_WALK_FRO)
				{
					if (eastWest)
					{
						_newPos.x -= moveDistance;
						_newOri.x = -1;
					}
					else
					{
						_newPos.y -= moveDistance;
						_newOri.y = -1;
					}
				}
				if (eastWest)
				{
					_newOri.y = 0;
				}
				else
				{
					_newOri.x = 0;
				}
			}
			
			var isMoving :Boolean = false;
			var hitWall :Boolean = false;

			if (eastWest)
			{
				var horizontalOffset :Number = Settings.TileW / 2;
				if (_state == STATE_WALK_FRO) { horizontalOffset *= -1; }

				if (game.getWalkmesh().isWalkable(_newPos.x + horizontalOffset, spriteActor.worldPosition.y))
				{
					isMoving = isMoving || (spriteActor.worldPosition.x - _newPos.x < 0.1);
					spriteActor.worldPosition.x = _newPos.x;
				}
				else
				{
					hitWall = true;
				}
				if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x, _newPos.y))
				{
					isMoving = isMoving || (spriteActor.worldPosition.y - _newPos.y < 0.1);
					spriteActor.worldPosition.y = _newPos.y;
				}
				else
				{
					hitWall = true;
				}
			}
			else
			{
				var verticalOffset :Number = Settings.TileH / 2;
				if (_state == STATE_WALK_FRO) { verticalOffset *= -1; }

				if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x, _newPos.y + verticalOffset))
				{
					isMoving = isMoving || (spriteActor.worldPosition.y - _newPos.y < 0.1);
					spriteActor.worldPosition.y = _newPos.y;
				}
				else
				{
					hitWall = true;
				}
				if (game.getWalkmesh().isWalkable(_newPos.x, spriteActor.worldPosition.y))
				{
					isMoving = isMoving || (spriteActor.worldPosition.x - _newPos.x < 0.1);
					spriteActor.worldPosition.x = _newPos.x;
				}
				else
				{
					hitWall = true;
				}				
			}
			
			if (hitWall)
			{
				reverseDirection();
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
			_walkTimer = ChangeDirectionTimeout;
			if (randomMovement)
			{
				_walkTimer += Math.random() * ChangeDirectionRandomTimeout;
			}
			if (_walkTimer < ChangeDirectionMinTimeout) { _walkTimer = ChangeDirectionMinTimeout; }
		}
		
		private function setRandomWalkDirection():void
		{
			resetWalkTimer();

			var rand :Number = Math.random();
			if (rand < 0.5) { _state = STATE_WALK_TO; }
			else { _state = STATE_WALK_FRO; }
		}
		
		private function reverseDirection():void
		{
			resetWalkTimer();
			
			switch (_state)
			{
				case STATE_WALK_TO:
					{
						_state = STATE_WALK_FRO;
					}
					break;

				case STATE_WALK_FRO:
					{
						_state = STATE_WALK_TO;
					}
					break;
				}
		}
		
	} // class
	
} // package
