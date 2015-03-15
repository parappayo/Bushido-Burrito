package sim.actors 
{
	import sim.WorldPosition;
	import starling.display.Image;
	import resources.*;
	
	public class Projectile extends SpriteActor
	{
		private var _img:Image;
		private var _texture:String;
		private var _speed:Number;
		private var _owner:SpriteActor;
		private var _lifetime:Number;
		private var _lifetimeMax:Number;
		private var _explode:Boolean;
		private var _bounce:Boolean;
		private var _spin:Boolean;
		
		public function Projectile()
		{
			_img = null;
			_texture = "";
			_speed = 0;
			_owner = null;
			_lifetime = 0;
			_lifetimeMax = 0;
			_explode = false;
			_bounce = false;
		}
		
		public function GetType():String
		{
			return _texture;
		}
		
		public function init(texture:String, speed:Number, owner:SpriteActor, lifetimeMax:Number, explode:Boolean, bounce:Boolean, spin:Boolean):void
		{
			alpha = 1;
			if (_texture != texture)
			{
				_texture = texture;
				if (_img != null) _img.removeFromParent(true);
				_img = new Image(Atlases.ElementsTextures.getTexture(_texture));
				_img.pivotX += _img.width * 0.5;
				_img.pivotY += _img.height * 0.5;
				addChild(_img);
			}
			_speed = speed;
			_owner = owner;
			_lifetime = 0;
			_lifetimeMax = lifetimeMax;
			_explode = explode;
			_bounce = bounce;
			_spin = spin;
		}
		
		override public function update(game:Game, elapsed:Number) :void
		{
			_lifetime += elapsed;

			if (_lifetime > _lifetimeMax)
			{
				alpha = 0;
				collided(game);
				
				if (_bounce)
				{
					game.handleSignal(Signals.PROJECTILE_REMOVE, this);
					game.getPlayer().setHasDisc(true);
				}
			}
			else
			{
				const oldPositionX:Number = worldPosition.x;
				const oldPositionY:Number = worldPosition.y;
				
				const lifetimeLeft:Number = _lifetimeMax - _lifetime;
				const fadingTime:Number = 0.15;
				if (lifetimeLeft < fadingTime)
				{
					alpha = lifetimeLeft / fadingTime; 
				}
				
				if (_bounce)
				{
					bounce(game, elapsed);
				}
				else
				{
					worldPosition.x += worldOrientation.x * _speed * elapsed;
					worldPosition.y += worldOrientation.y * _speed * elapsed;
				}
				
				if (game.checkCollision(worldPosition, _owner))
				{
					collided(game);
				}
				// extra tests for greater precision (ideally we can move this to a line test at some point)
				if (_bounce)
				{
					var midPosition:WorldPosition = new WorldPosition();
					midPosition.x = (oldPositionX * 0.25) + (worldPosition.x * 0.75);
					midPosition.y = (oldPositionY * 0.25) + (worldPosition.y * 0.75);
					if (game.checkCollision(midPosition, _owner))
					{
						collided(game);
					}
					midPosition.x = (oldPositionX * 0.5) + (worldPosition.x * 0.5);
					midPosition.y = (oldPositionY * 0.5) + (worldPosition.y * 0.5);
					if (game.checkCollision(midPosition, _owner))
					{
						collided(game);
					}
					midPosition.x = (oldPositionX * 0.75) + (worldPosition.x * 0.25);
					midPosition.y = (oldPositionY * 0.75) + (worldPosition.y * 0.25);
					if (game.checkCollision(midPosition, _owner))
					{
						collided(game);
					}
				}
			}
			
			if (_spin)
			{
				const angularSpeed:Number = 15;
				rotation += angularSpeed * elapsed;
			}
		}
		
		private function bounce(game:Game, elapsed:Number):void
		{
			const newX:Number = worldPosition.x + worldOrientation.x * _speed * elapsed;
			const newY:Number = worldPosition.y + worldOrientation.y * _speed * elapsed;
			// horizontal test
			if (!bounceTest(game, newX, worldPosition.y, newX, newY))
			{
				// vertical test
				if (!bounceTest(game, worldPosition.x, newY, newX, newY))
				{
					// diagonal test
					bounceTest(game, newX, newY, newX, newY);
				}
			}
			worldPosition.x = worldPosition.x + worldOrientation.x * _speed * elapsed;
			worldPosition.y = worldPosition.y + worldOrientation.y * _speed * elapsed;
		}
		
		private function bounceTest(game:Game, cellX:Number, cellY:Number, toX:Number, toY:Number):Boolean
		{
			var bounced:Boolean = false;
			cellX -= Settings.TileW / 2;
			cellY -= Settings.TileH / 2;
			if (!game.getWalkmesh().isWalkable(cellX, cellY) || game.getWalkmesh().hasEnemyPresence(cellX, cellY))
			{
				const indexX:Number = Math.round(cellX / Settings.TileW);
				const indexY:Number = Math.round(cellY / Settings.TileH);
				
				const xL:Number = indexX * Settings.TileW;
				const xR:Number = xL + Settings.TileW;
				const yU:Number = indexY * Settings.TileH;
				const yD:Number = yU + Settings.TileH;
				
				const fromX:Number = worldPosition.x;
				const fromY:Number = worldPosition.y;
				
				//var e:Effect = new Effect(Particles.beep, "beep", (xL + xR) * 0.5, (yU + yD) * 0.5, 0.1);
				//game.handleSignal(Signals.EFFECT_ADD, e);
				
				// left and right edges
				if ((toX > fromX && linesIntersect(fromX, fromY, toX, toY, xL, yU, xL, yD)) || (toX < fromX && linesIntersect(fromX, fromY, toX, toY, xR, yU, xR, yD)))
				{
					worldOrientation.x = -worldOrientation.x;
					bounced = true;
				}
				// top and bottom edges
				if ((toY > fromY && linesIntersect(fromX, fromY, toX, toY, xL, yU, xR, yU)) || (toY < fromY && linesIntersect(fromX, fromY, toX, toY, xL, yD, xR, yD)))
				{
					worldOrientation.y = -worldOrientation.y;
					bounced = true;
				}
			}
			if (bounced)
			{
				var sounds:Array = [Audio.sfx_disc_bnc_03, Audio.sfx_disc_bnc_04];
				SoundPlayer.playRandom(sounds, Settings.VolumeSfxLoud);
			}
			return bounced;
		}
		
		private function linesIntersect(p0x:Number, p0y:Number, p1x:Number, p1y:Number, p2x:Number, p2y:Number, p3x:Number, p3y:Number):Boolean
		{
			var s1x:Number = p1x - p0x;
			var s1y:Number = p1y - p0y;
			var s2x:Number = p3x - p2x;
			var s2y:Number = p3y - p2y;
			
			var s:Number = (-s1y * (p0x - p2x) + s1x * (p0y - p2y)) / (-s2x * s1y + s1x * s2y);
			var t:Number = (s2x * (p0y - p2y) - s2y * (p0x - p2x)) / (-s2x * s1y + s1x * s2y);
			
			if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
			{
				return true;
			}
			return false;
		}
		
		public function collided(game:Game):void
		{
			if (!_bounce)
			{
				game.handleSignal(Signals.PROJECTILE_REMOVE, this);
			}
			if (_explode)
			{
				explode(game);
			}
		}
		
		private function explode(game:Game):void
		{
			game.checkExplosion(worldPosition, 50);
		}
		
	} // class
	
} // package
