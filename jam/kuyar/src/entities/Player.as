
package entities 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import common.*;
	import wyverntail.core.*;
	import wyverntail.collision.*;
	
	public class Player extends Component
	{
		private var _game :Game;
		private var _pos :Position2D;
		private var _clip :MovieClip;
		private var _hitbox :Hitbox;
		private var _move :Movement4Way;		
		
		private static const STATE_READY	:int = 1000;
		private static const STATE_ATTACK	:int = 1001;
		private static const STATE_JUMP		:int = 1002;
		private static const STATE_RECOVER	:int = 1003;
		private var _state :int;
		
		public function Player() 
		{
			_state = STATE_READY;
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(MovieClip) as MovieClip;
			_hitbox = getComponent(Hitbox) as Hitbox;
			_move = getComponent(Movement4Way) as Movement4Way;
			
			_clip.setParent(prefabArgs.parentSprite);
			_clip.scaleX = prefabArgs.scaleX ? prefabArgs.scaleX : 1;
			_clip.scaleY = prefabArgs.scaleY ? prefabArgs.scaleY : 1;
			
			_clip.addAnimation("idle", Assets.EntitiesAtlas.getTextures("demon"), Settings.SpriteFramerate);
			_clip.addAnimation("walk", Assets.EntitiesAtlas.getTextures("demon"), Settings.SpriteFramerate);
			_clip.addAnimation("attack", Assets.EntitiesAtlas.getTextures("demon"), Settings.SpriteFramerate);
			_clip.play("idle", true);
			
			// 80% hitbox leaves wiggle room
			_hitbox.extents = new Rectangle( -Settings.TileWidth * 0.8, -Settings.TileHeight * 0.8, Settings.TileWidth * 0.8, Settings.TileHeight * 0.8);
			//_hitbox.useClipExtents = true;
			//_hitbox.showDebug = true;
		}
		
		override public function update(elapsed :Number) :void
		{
			_move.enabled = (_state == STATE_READY);
			
			switch (_state)
			{
				case STATE_READY:
					{
						if (_move.isMoving)
						{
							_clip.play("walk", true);
						}
						else
						{
							_clip.play("idle", true);
						}
					}
					break;
					
				case STATE_ATTACK:
					{
						if (_clip.isDone)
						{
							_state = STATE_READY;
						}
						else
						{
							_clip.play("attack", false);
						}
					}
					break;
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.ACTION_KEYDOWN:
				{
					//_state = STATE_ATTACK;
					//_game.handleSignal(Signals.PLAYER_ATTACK, this, args);
				}
			}
			
			return false;
		}
		
	} // class

} // package
