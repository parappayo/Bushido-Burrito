package sim.components.actionstates 
{
	import sim.Memory;
	import sim.actors.Projectile;
	import sim.actors.SpriteActor;
	import sim.components.Animations;
	public class ActionStateTankShoot implements ActionState 
	{
		private var _bullet:String;
		private var _bulletSpeed:Number;
		private var _timer:Number;
		private var _turretLoadTime:Number;
		
		public function ActionStateTankShoot(bullet:String, bulletSpeed:Number)
		{
			_bullet = bullet;
			_bulletSpeed = bulletSpeed;
			_timer = 0;
			_turretLoadTime = 0;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{	
			_timer = 0;
			_turretLoadTime = 0.2 + (Math.random() * 0.1);
			actor.handleSignal(game, Signals.ANIM_PLAY, Animations.SHOOT);
			SoundPlayer.play(Audio.tankTurret, Audio.VOLUME_SFX_LOUD);
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			const done:Boolean = (_timer > _turretLoadTime);
			_timer += elapsed;
			return done;
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			if (actor.isDead())
			{
				actor.handleSignal(game, Signals.ANIM_PLAY, Animations.HURT);
			}
			else
			{
				actor.handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			}
			
			var p:Projectile = Memory.newProjectile(_bullet);
			p.init(_bullet, _bulletSpeed, actor, true);
			p.worldPosition.copy(actor.worldPosition);
			p.worldPosition.x += actor.width * 0.5;
			p.worldPosition.y += actor.height * 0.5;
			p.worldOrientation.copy(actor.worldOrientation);
			const sign:Number = (Math.random() > 0.5) ? 1 : -1;
			p.worldOrientation.x += sign * Math.random() * 0.04;
			p.worldOrientation.normalize();
			p.rotation = p.worldOrientation.rotation();
			p.worldPosition.x += p.worldOrientation.x * actor.width * 0.5;
			p.worldPosition.y += p.worldOrientation.y * actor.height * 0.5;
			game.handleSignal(Signals.PROJECTILE_ADD, p);
			
			SoundPlayer.play(Audio.tankFire, Audio.VOLUME_SFX_LOUD);
		}
	}
}