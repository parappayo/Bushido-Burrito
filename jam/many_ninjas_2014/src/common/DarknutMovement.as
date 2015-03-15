package common 
{
	import wyverntail.core.*;
	import wyverntail.collision.*;
	
	/**
	 *  Movement controller mimicking classic Zelda Darknut enemy patterns.
	 */
	public class DarknutMovement extends Component
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
		
		// movement speed in pixels per second
		// TODO: should be a prefab argument
		public var verticalSpeed :Number = 120;
		public var horizontalSpeed :Number = 120;
		
		public var minWorldX :Number = 0;
		public var maxWorldX :Number = Settings.ScreenWidth - 50;
		public var minWorldY :Number = 0;
		public var maxWorldY :Number = Settings.ScreenHeight - 50;

		private var _state :int;
		private var _walkTimer :Number;

		private var _pos :Position2D;
		private var _clip :Sprite;
		private var _hitbox :Hitbox;
		private var _walkmesh :CellGrid;

		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(Sprite) as Sprite;
			_hitbox = getComponent(Hitbox) as Hitbox;
			_walkmesh = prefabArgs.walkmesh;
			
			_state = STATE_INIT;
		}
		
		override public function update(elapsed :Number) :void
		{
			if (!enabled) { return; }
			
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
			
			var newX :Number = _pos.worldX;
			var newY :Number = _pos.worldY;
			var collidesX :Boolean = false;
			var collidesY :Boolean = false;
			
			if (_state == STATE_WALK_NORTH)
			{
				newY -= verticalSpeed * elapsed;
				collidesY = collidesY || newY < minWorldY;
				if (_walkmesh)
				{
					collidesY = collidesY || _walkmesh.collides(_pos.worldX, newY);
					collidesY = collidesY || _walkmesh.collides(_pos.worldX + _hitbox.width, newY);
				}
			}
			else if (_state == STATE_WALK_SOUTH)
			{
				newY += verticalSpeed * elapsed;
				collidesY = collidesY || newY > maxWorldY;
				if (_walkmesh)
				{
					collidesY = collidesY || _walkmesh.collides(_pos.worldX, newY + _hitbox.height);
					collidesY = collidesY || _walkmesh.collides(_pos.worldX + _hitbox.width, newY + _hitbox.height);
				}
			}
			else if (_state == STATE_WALK_WEST)
			{
				newX -= horizontalSpeed * elapsed;
				collidesX = collidesX || newX < minWorldX;
				if (_walkmesh)
				{
					collidesX = collidesX || _walkmesh.collides(newX, _pos.worldY);
					collidesX = collidesX || _walkmesh.collides(newX, _pos.worldY + _hitbox.height);
				}
			}
			else if (_state == STATE_WALK_EAST)
			{
				newX += horizontalSpeed * elapsed;
				collidesX = collidesX || newX > maxWorldX;
				if (_walkmesh)
				{
					collidesX = collidesX || _walkmesh.collides(newX + _hitbox.width, _pos.worldY);
					collidesX = collidesX || _walkmesh.collides(newX + _hitbox.width, _pos.worldY + _hitbox.height);
				}
			}
			
			if (!collidesX) { _pos.worldX = newX; }
			if (!collidesY) { _pos.worldY = newY; }			
			if (collidesX || collidesY) { reverseDirection(); }
			
			// flip the sprite when moving left
			if (_clip)
			{
				if (_state == STATE_WALK_EAST)
				{
					_clip.scaleX = 1;
				}
				else if (_state == STATE_WALK_WEST)
				{
					_clip.scaleX = -1;
				}
			}
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
