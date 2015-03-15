
package entities
{
	import flash.geom.Rectangle;
	import wyverntail.core.*;
	import wyverntail.collision.*;
	import common.*;
	
	public class Player extends Component
	{
		private var _game :Game;
		private var _pos :Position2D;
		private var _clip :MovieClip;
		private var _hitbox :Hitbox;
		private var _move :Movement4Way;
		
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
			
			_clip.addAnimation("idle", Assets.EntitiesAtlas.getTextures("troll_stand"), Settings.SpriteFramerate);
			_clip.addAnimation("walk", Assets.EntitiesAtlas.getTextures("troll_walk_right"), Settings.SpriteFramerate);
			_clip.play("idle", true);
			
			// 80% hitbox leaves wiggle room
			_hitbox.extents = new Rectangle( -Settings.TileWidth * 0.8, -Settings.TileHeight * 0.8, Settings.TileWidth * 0.8, Settings.TileHeight * 0.8);
			//_hitbox.useClipExtents = true;
			//_hitbox.showDebug = true;
		}
		
		override public function update(elapsed :Number) :void
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
		
	} // class
	
} // package
