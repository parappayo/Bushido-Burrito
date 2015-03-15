
package entities 
{
	import wyverntail.core.*;
	
	public class OldGuyNPC extends Component
	{
		private var _game :Game;
		private var _pos :Position2D;
		private var _clip :MovieClip;
		
		private var _isFleeing :Boolean;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(MovieClip) as MovieClip;

			_clip.setParent(prefabArgs.parentSprite);
			_clip.scaleX = prefabArgs.scaleX ? prefabArgs.scaleX : 1;
			_clip.scaleY = prefabArgs.scaleY ? prefabArgs.scaleY : 1;
			
			_clip.addAnimation("idle", Assets.EntitiesAtlas.getTextures("old_guy_stand"), Settings.SpriteFramerate);
			_clip.addAnimation("walk", Assets.EntitiesAtlas.getTextures("old_guy_walk_left"), Settings.SpriteFramerate);
			_clip.play("walk", true);
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ATTACK_HERO)
			{
				_isFleeing = true;
			}
			return false;
		}

		override public function update(elapsed :Number) :void
		{
			if (!enabled) { return; }
			
			var speed :Number = 80;
			
			if (_isFleeing)
			{
				_pos.worldX += elapsed * speed * 5;
				
				if (_pos.worldX > Settings.ScreenWidth + 200)
				{
					_isFleeing = false;
				}
			}
			else
			{
				_pos.worldX -= elapsed * speed;
			
				if (_pos.worldX < -100)
				{
					_pos.worldX = Settings.ScreenWidth + 50;
					_pos.worldY = 340 + Math.random() * 100;
				}
			}
			
		}
		
	} // class

} // package
