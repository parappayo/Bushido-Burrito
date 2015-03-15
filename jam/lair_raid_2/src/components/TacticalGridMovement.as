package components 
{
	import starling.display.Sprite;
	import starling.events.*;
	import wyverntail.collision.CellCollider;
	import wyverntail.collision.CellGrid;
	import wyverntail.core.*;

	public class TacticalGridMovement extends Component
	{
		private var _game :Game;
		private var _parent :starling.display.Sprite;
		private var _cellgrid :CellGrid;
		private var _pos :Position2D;
		private var _clip :MovieClip;
		private var _isSelected :Boolean;
		private var _unitStats :UnitStats;
		private var _movePoints :int;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_parent = prefabArgs.parentSprite;
			_cellgrid = prefabArgs.cellgrid;
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(MovieClip) as MovieClip;
			_isSelected = false;
			_unitStats = getComponent(UnitStats) as UnitStats;
			_movePoints = 3;
			
			if (spawnArgs.playerSide == false) { enabled = false; }
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.UNIT_DEFEATED)
			{
				var senderComponent :Component = sender as Component;
				if (senderComponent && senderComponent.isSibling(this))
				{
					enabled = false;

					_clip.stop();
					_clip.enabled = false;
					
					var collider :CellCollider = getComponent(CellCollider) as CellCollider;
					if (collider)
					{
						collider.clear();
						collider.enabled = false;
					}
				}
			}
			if (_unitStats.isDead()) { return false; }
			
			if (signal == Signals.PLAYER_TURN_START)
			{
				_clip.play("idle", true);
				return false;
			}
			if (_unitStats.hasMoved) { return false; }
			
			if (signal == Signals.SELECTED_STATE_CHANGED)
			{
				if (!isSibling(sender as Component)) { return false; }
				
				_isSelected = sender.selected;
				
				// when a unit becomes de-selected, it could be because the user clicked away
				if (!_isSelected)
				{
					if (args == null) { return false; }
					var event :TouchEvent = args.touchEvent;
					if (event == null) { return false; }
					var touch :Touch = event.getTouch(_parent.stage, TouchPhase.BEGAN);
					if (touch == null) { return false; }

					moveTo(touch.globalX, touch.globalY);
				}
				return false;
			}
			
			return false;
		}
		
		public function moveTo(worldX :Number, worldY :Number) :Boolean
		{
			if (!canMoveTo(worldX, worldY) ||
				gridDistance(worldX, worldY) < 1)
			{
				return false;
			}

			// TODO: write a GridPosition2D component to handle this
			// convert movement coords to a grid position
			var posX :Number = worldX - worldX % Settings.TileWidth;
			var posY :Number = worldY - worldY % Settings.TileHeight;
			
			// TODO: move phases and animation
			_pos.worldX = posX;
			_pos.worldY = posY;
			
			_unitStats.hasMoved = true;
			_clip.play("turn_done");
			
			// units auto-attack after a move
			if (_unitStats.playerSide)
			{
				_game.handleSignal(Signals.PLAYER_CHARGE_ATTACK, this, { posX : posX, posY : posY } );
			}
			else
			{
				_game.handleSignal(Signals.AI_CHARGE_ATTACK, this, { posX : posX, posY : posY } );
			}
			
			return true;
		}
		
		public function gridDistance(worldX :Number, worldY :Number) :int
		{
			var deltaX :Number = worldX - _pos.worldX;
			var deltaY :Number = worldY - _pos.worldY;
			var gridDeltaX :int = Math.floor(deltaX / Settings.TileWidth);
			var gridDeltaY :int = Math.floor(deltaY / Settings.TileHeight);
			var gridDistanceX :int = Math.abs(gridDeltaX);
			var gridDistanceY :int = Math.abs(gridDeltaY);
			var gridDistance :int = gridDistanceX + gridDistanceY;
			
			return gridDistance;
		}
		
		public function canMoveTo(worldX :Number, worldY :Number) :Boolean
		{
			var deltaX :Number = worldX - _pos.worldX;
			var deltaY :Number = worldY - _pos.worldY;
			var gridDeltaX :int = Math.floor(deltaX / Settings.TileWidth);
			var gridDeltaY :int = Math.floor(deltaY / Settings.TileHeight);
			var gridDistanceX :int = Math.abs(gridDeltaX);
			var gridDistanceY :int = Math.abs(gridDeltaY);
			var gridDistance :int = gridDistanceX + gridDistanceY;
			
			// recursion end conditions
			if (gridDistance < 1) { return true; }
			if (gridDistance > _movePoints) { return false; }
			if (_cellgrid.collides(worldX, worldY)) { return false; }
			
			// recursively search if there is an unobstructed route
			var retval :Boolean = false;
			
			if (gridDeltaX > 0)
			{
				retval = retval || canMoveTo(worldX - Settings.TileWidth, worldY);
			}
			else if (gridDeltaX < 0)
			{
				retval = retval || canMoveTo(worldX + Settings.TileWidth, worldY);
			}
			
			if (gridDeltaY > 0)
			{
				retval = retval || canMoveTo(worldX, worldY - Settings.TileHeight);
			}
			else if (gridDeltaY < 0)
			{
				retval = retval || canMoveTo(worldX, worldY + Settings.TileHeight);
			}
			
			return retval;
		}
		
		public function findNearestHostile() :Entity
		{
			var retval :Entity;
			var closestPos :Position2D;
		
			var units :Vector.<Entity> = scene.findEntities(UnitStats);
			for each (var unit :Entity in units)
			{
				// skip friendlies
				var stats :UnitStats = unit.getComponent(UnitStats) as UnitStats;
				if (stats.playerSide == _unitStats.playerSide) { continue; }
				
				if (stats.isDead()) { continue; }
				
				if (retval == null)
				{
					retval = unit;
					closestPos = unit.getComponent(Position2D) as Position2D;
					continue;
				}
				
				var pos :Position2D = unit.getComponent(Position2D) as Position2D;
				if (_pos.distanceSquared(pos) < _pos.distanceSquared(closestPos))
				{
					retval = unit;
					closestPos = pos;
				}
			}
			
			return retval;
		}
		
		/// returns true if the nearest hostile is in melee range after moving
		public function moveTowardNearestHostile() :Boolean
		{
			if (_unitStats.isDead()) { return false; }
			
			var nearestHostile :Entity = findNearestHostile();
			if (nearestHostile == null) { return false; } // game over!
			var hostilePos :Position2D = nearestHostile.getComponent(Position2D) as Position2D;
			
			var maxMove :Number = Settings.TileWidth * _movePoints;
			var dx :Number = hostilePos.worldX - _pos.worldX;
			var dy :Number = hostilePos.worldY - _pos.worldY;
			var destX :Number = hostilePos.worldX;
			var destY :Number = hostilePos.worldY;
			
			if (Math.abs(dx) + Math.abs(dy) < Settings.TileWidth * 1.1)
			{
				// no need to move, already adjacent
				return true;
			}
			
			if (Math.abs(dx) < Settings.TileWidth)
			{
				// target is on the same column, so focus on vertical movement
				if (dy < 0)
				{
					// target is above us, try to move to its bottom side
					destY = hostilePos.worldY + Settings.TileWidth;
				}
				else
				{
					// target is above us, try to move to its top side
					destY = hostilePos.worldY - Settings.TileWidth;
				}
			}
			else if (dx < 0)
			{
				// target is to the left, try to move to its right side
				destX = hostilePos.worldX + Settings.TileWidth;
			}
			else // dx > 0
			{
				// target is to the right, try to move to its left side
				destX = hostilePos.worldX - Settings.TileWidth;	
			}
			
			// try to get there in one jump
			if (moveTo(destX, destY)) { return true; }
			
			// re-figure our target pos
			dx = destX - _pos.worldX;
			dy = destY - _pos.worldY;
			
			if (dx < 0)
			{
				dx = Math.max(dx, -maxMove);
			}
			else
			{
				dx = Math.min(dx, maxMove);
			}
			
			if (dy < 0)
			{
				dy = Math.max(dy, -maxMove);
			}
			else
			{
				dy = Math.min(dy, maxMove);
			}
			
			if (moveTo(_pos.worldX + dx, _pos.worldY)) { return false; }
			if (moveTo(_pos.worldX, _pos.worldY + dy)) { return false; }
			
			// try one square at a time
			dx = dx / 3;
			dy = dy / 3;
			if (moveTo(_pos.worldX + dx, _pos.worldY)) { return false; }
			if (moveTo(_pos.worldX, _pos.worldY + dy)) { return false; }
			
			return false;
		}
		
	} // class

} // package
