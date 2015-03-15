package sim.components.actionstates 
{
	import sim.Memory;
	import sim.actors.Projectile;
	import sim.actors.SpriteActor;
	
	public class ActionStateSprayShoot implements ActionState 
	{
		private var _bullet:String;
		private var _bulletSpeed:Number;
		private var _bulletCount:Number;
		private var _delay:Number;
		private var _timer:Number;
		
		public function ActionStateSprayShoot(bullet:String, bulletSpeed:Number, shotsPerSecond:Number)
		{
			_bullet = bullet;
			_bulletSpeed = bulletSpeed;
			_bulletCount = 0;
			_delay = 1 / shotsPerSecond;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			var p:Projectile = Memory.newProjectile(_bullet);
			p.init(_bullet, _bulletSpeed, actor);
			p.worldPosition.copy(actor.worldPosition);
			p.worldPosition.x += actor.width * 0.5;
			p.worldPosition.y += actor.height * 0.7;
			
			// randomize the orientation a little
			_bulletCount++;
			var randRot :Number = (_bulletCount % 5 == 0) ? 0 : -0.1 + Math.random() * 0.15;
			p.worldOrientation.copy(actor.worldOrientation);
			p.worldOrientation.rotate(randRot);
			p.worldOrientation.normalize();
			
			p.rotation = p.worldOrientation.rotation();
			p.worldPosition.x += p.worldOrientation.x * actor.width * 0.5;
			p.worldPosition.y += p.worldOrientation.y * actor.height * 0.5;
			game.handleSignal(Signals.PROJECTILE_ADD, p);
			
			SoundPlayer.playRandom(Audio.gunFireSoundList, Audio.VOLUME_SFX);
			
			_timer = 0;
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer += elapsed;
			return (_timer > _delay); // Done!
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
		}
	}
}