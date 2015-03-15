package sim.components.actionstates 
{
	import sim.Memory;
	import sim.actors.Projectile;
	import sim.actors.SpriteActor;
	import resources.*;
	
	public class ActionStateShoot implements ActionState 
	{
		private var _bullet:String;
		private var _bulletSpeed:Number;
		private var _delay:Number;
		private var _timer:Number;
		
		public function ActionStateShoot(bullet:String, bulletSpeed:Number, shotsPerSecond:Number)
		{
			_bullet = bullet;
			_bulletSpeed = bulletSpeed;
			_delay = 1 / shotsPerSecond;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			var p:Projectile = new Projectile();
			p.init(_bullet, _bulletSpeed, actor, 5, false, false, true);
			p.worldPosition.copy(actor.worldPosition);
			p.worldPosition.x += actor.width * 0.5;
			p.worldPosition.y += actor.height * 0.7;
			p.worldOrientation.copy(actor.worldOrientationAim);
			p.worldOrientation.normalize();
			p.rotation = p.worldOrientation.rotation();
			p.worldPosition.x += p.worldOrientation.x * actor.width * 0.5;
			p.worldPosition.y += p.worldOrientation.y * actor.height * 0.5;
			game.handleSignal(Signals.PROJECTILE_ADD, p);
			
			SoundPlayer.playRandom([Audio.sfx_en_duck_attack_a_02, Audio.sfx_en_duck_attack_a_03], Settings.VolumeSfx);
			
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