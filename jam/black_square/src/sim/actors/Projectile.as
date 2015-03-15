package sim.actors 
{
	import starling.display.Image;
	
	public class Projectile extends SpriteActor
	{
		private var _img:Image;
		private var _texture:String;
		private var _speed:Number;
		private var _owner:SpriteActor;
		private var _lifetime:Number;
		private var _explode:Boolean;
		
		public function Projectile()
		{
			_img = null;
			_texture = "";
			_speed = 0;
			_owner = null;
			_lifetime = 0;
			_explode = false;
		}
		
		public function GetType():String
		{
			return _texture;
		}
		
		public function init(texture:String, speed:Number, owner:SpriteActor, explode:Boolean = false):void
		{
			if (_texture != texture)
			{
				_texture = texture;
				if (_img != null) _img.removeFromParent(true);
				_img = new Image(Assets.ElementsTextures.getTexture(_texture));
				_img.pivotX += _img.width * 0.5;
				_img.pivotY += _img.height * 0.5;
				addChild(_img);
			}
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
			var e1:Effect = new Effect(Particles.ShellHitXML, "shellhit", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
			game.handleSignal(Signals.EFFECT_ADD, e1);
			var e2:Effect = new Effect(Particles.SmokeXML, "smoke", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
			game.handleSignal(Signals.EFFECT_ADD, e2);
			SoundPlayer.play(Audio.tankHit, Audio.VOLUME_SFX_LOUD);
		}
		
	} // class
	
} // package
