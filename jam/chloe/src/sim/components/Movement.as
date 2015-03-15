package sim.components 
{
	import sim.actors.Actor;
	import sim.actors.SpriteActor;
	import sim.components.animation.Animations;
	import sim.components.movement.MoveUpdate;
	import sim.WorldOrientation;
	import sim.WorldPosition;
	
	public class Movement implements Component 
	{
		private var _speed :Number; // pixels per second
		private var _newPos :WorldPosition;
		private var _newOri :WorldOrientation;
		
		private var _locked:Boolean;
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
			_moveUp = false;
			_moveDown = false;
			_moveLeft = false;
			_moveRight = false;
		}
		
		public function update(game :Game, actor :Actor, elapsed :Number) :void
		{
			var spriteActor :SpriteActor = actor as SpriteActor;
			if (spriteActor == null || spriteActor.isDead() || _locked) return;
			
			// speed and distance
			const carrying :Boolean = spriteActor.isCarrying();
			var modifier :Number = carrying ? 0.8 : 1; 
			if ((_moveUp || _moveDown) && (_moveLeft || _moveRight))
			{
				modifier = 0.7071;
			}
			var moveDistance :Number = elapsed * _speed * modifier;
			
			_newPos.copy(spriteActor.worldPosition);
			_newOri.copy(spriteActor.worldOrientation);
			
			// vertical movement
			if (_moveUp || _moveDown)
			{
				if (_moveUp && !_moveDown)
				{
					_newPos.y -= moveDistance;
					_newOri.y = -1;
				}
				else if (_moveDown && !_moveUp)
				{
					_newPos.y += moveDistance;
					_newOri.y = 1;
				}
				if (!_moveLeft && !_moveRight) _newOri.x = 0;
			}
			
			// horizontal movement
			if (_moveLeft || _moveRight)
			{
				if (_moveLeft && !_moveRight)
				{
					_newPos.x -= moveDistance;
					_newOri.x = -1;
				}
				else if (_moveRight && !_moveLeft)
				{
					_newPos.x += moveDistance;
					_newOri.x = 1;
				}
				if (!_moveUp && !_moveDown) _newOri.y = 0;
			}
			
			// position
			var horizontalOffset :Number = Settings.WalkmeshSize / 2;
			if (_moveLeft) { horizontalOffset *= -1; }
			var moveHorizontal :Boolean = false;
			if (game.getWalkmesh().isWalkable(_newPos.x + horizontalOffset, spriteActor.worldPosition.y))
			{
				moveHorizontal = (Number(_moveLeft) ^ Number(_moveRight)) != 0;
				spriteActor.worldPosition.x = _newPos.x;
			}
			var moveVertical :Boolean = false;
			if (game.getWalkmesh().isWalkable(spriteActor.worldPosition.x, _newPos.y))
			{
				moveVertical = (Number(_moveUp) ^ Number(_moveDown)) != 0;
				spriteActor.worldPosition.y = _newPos.y;
			}
			
			// orientation
			spriteActor.worldOrientationTarget = _newOri;
			
			// animation
			const idleAnim :int = carrying ? Animations.HOLD : Animations.IDLE;
			const moveAnim :int = carrying ? Animations.CARRY : Animations.WALK;
			const animation :int = (moveHorizontal || moveVertical) ? moveAnim : idleAnim;
			spriteActor.handleSignal(game, Signals.ANIMATION_PLAY, animation);
		}
		
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void
		{
			if (actor.isDead()) { return; }
			switch (signal) 
			{
				case Signals.MOVEMENT_STOP:
					reset();
					break;
				case Signals.MOVEMENT_UPDATE:
					var moveUpdate:MoveUpdate = args as MoveUpdate;
					_moveUp = moveUpdate._up;
					_moveDown = moveUpdate._down;
					_moveLeft = moveUpdate._left;
					_moveRight = moveUpdate._right;
					break;
				case Signals.ACTION_LOCK:
					_locked = args as Boolean;
					break;						
				default:
					break;
			}
		}
	} // class
} // package
