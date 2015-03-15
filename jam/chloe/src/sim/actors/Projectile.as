package sim.actors 
{
	import resources.*;
	import flash.media.SoundTransform;
	import sim.actors.SpriteActor;
	import starling.display.Image;
	
	public class Projectile extends SpriteActor
	{
		private var _speed:Number;
		private var _owner:SpriteActor;
		private var _lifetime:Number;
		private var _explode:Boolean;
		
		function Projectile(image:String, speed:Number, owner:SpriteActor, explode:Boolean = false)
		{
			var img:Image = new Image(Atlases.ProjectilesTextures.getTexture(image));
			img.pivotX += img.width * 0.5;
			img.pivotY += img.height * 0.5;
			addChild(img);
			_speed = speed;
			_owner = owner;
			_lifetime = 0;
			_explode = explode;
		}
		
		override public function update(game:Game, elapsed:Number) :void
		{
			worldPosition.x += worldOrientation.x * _speed * elapsed;
			worldPosition.y += worldOrientation.y * _speed * elapsed;
			_lifetime += elapsed;

			if (_lifetime > 5)
			{
				collided(game);
			}
			else
			{
				if (game.checkCollision(worldPosition, _owner))
				{
					collided(game);
				}
			}
		}
		
		public function collided(game:Game):void
		{
			game.handleSignal(Signals.PROJECTILE_REMOVE, this);
			if (_explode)
			{
				explode(game);
			}
		}
		
		private function explode(game:Game):void
		{
			game.checkExplosion(worldPosition, 50);
			var e:Effect = new Effect(Particles.smokeXML, "smoke", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
			game.handleSignal(Signals.EFFECT_ADD, e);
		}
		
	} // class
	
} // package
