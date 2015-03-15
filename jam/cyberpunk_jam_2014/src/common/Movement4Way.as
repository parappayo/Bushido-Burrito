package common
{
	import wyverntail.collision.CellGrid;
	import wyverntail.collision.Hitbox;
	import wyverntail.core.*;
	
	public class Movement4Way extends Component
	{
		private var _moveUp :Boolean;
		private var _moveDown :Boolean;		
		private var _moveLeft :Boolean;
		private var _moveRight :Boolean;
		
		// movement speed in pixels per second
		// TODO: should be a prefab argument
		public var verticalSpeed :Number = 320;
		public var horizontalSpeed :Number = 320;

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
		}
		
		public function get isMoving() :Boolean
		{
			return _moveUp || _moveDown || _moveLeft || _moveRight;
		}
		
		override public function update(elapsed :Number) :void
		{
			if (!enabled) { return; }
			
			var moveFactor :Number = 1;
			if ((_moveUp || _moveDown) && (_moveLeft || _moveRight))
			{
				// not right when vertical speed != horizontal speed
				moveFactor *= 0.7071; // 1 / sqrt(2)
			}
			
			var newX :Number = _pos.worldX;
			var newY :Number = _pos.worldY;
			var collidesX :Boolean = false;
			var collidesY :Boolean = false;
			
			if (_moveUp)
			{
				newY -= verticalSpeed * moveFactor * elapsed;
				collidesY = collidesY || _walkmesh.collides(_pos.worldX, newY);
				collidesY = collidesY || _walkmesh.collides(_pos.worldX + _hitbox.width, newY);
			}
			if (_moveDown && !collidesY)
			{
				newY += verticalSpeed * moveFactor * elapsed;
				collidesY = collidesY || _walkmesh.collides(_pos.worldX, newY + _hitbox.height);
				collidesY = collidesY || _walkmesh.collides(_pos.worldX + _hitbox.width, newY + _hitbox.height);
			}
			if (_moveLeft)
			{
				newX -= horizontalSpeed * moveFactor * elapsed;
				collidesX = collidesX || _walkmesh.collides(newX, _pos.worldY);
				collidesX = collidesX || _walkmesh.collides(newX, _pos.worldY + _hitbox.height);
			}
			if (_moveRight && !collidesX)
			{
				newX += horizontalSpeed * moveFactor * elapsed;
				collidesX = collidesX || _walkmesh.collides(newX + _hitbox.width, _pos.worldY);
				collidesX = collidesX || _walkmesh.collides(newX + _hitbox.width, _pos.worldY + _hitbox.height);
			}
			
			if (!collidesX) { _pos.worldX = newX; }
			if (!collidesY) { _pos.worldY = newY; }
			
			// flip the sprite when moving left
			if (_clip)
			{
				if (_moveRight)
				{
					_clip.scaleX = 1;
				}
				else if (_moveLeft)
				{
					_clip.scaleX = -1;
				}
			}
		}
		
		public function resetState() :void
		{
			_moveUp = false;
			_moveDown = false;
			_moveLeft = false;
			_moveRight = false;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.LEVEL_TRANSITION:		resetState();			break;
				case Signals.MOVE_UP_KEYDOWN:		_moveUp = true;			break;
				case Signals.MOVE_DOWN_KEYDOWN:		_moveDown = true;		break;
				case Signals.MOVE_LEFT_KEYDOWN:		_moveLeft = true;		break;
				case Signals.MOVE_RIGHT_KEYDOWN:	_moveRight = true;		break;
				case Signals.MOVE_UP_KEYUP:			_moveUp = false;		break;
				case Signals.MOVE_DOWN_KEYUP:		_moveDown = false;		break;
				case Signals.MOVE_LEFT_KEYUP:		_moveLeft = false;		break;
				case Signals.MOVE_RIGHT_KEYUP:		_moveRight = false;		break;
			}
			
			return false;
		}
		
		public function get worldX() :Number { return _pos.worldX; }
		public function get worldY() :Number { return _pos.worldY; }
		
	} // class

} // package
