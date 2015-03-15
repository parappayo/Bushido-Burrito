package sim.components.actionstates 
{
	import sim.Memory;
	import sim.actors.Projectile;
	import sim.actors.SpriteActor;
	import sim.components.Animations;
	import resources.*;
	
	public class ActionStateThrow implements ActionState 
	{
		private var _disc:String;
		private var _discSpeed:Number;
		private var _discLifetime:Number;
		private var _delay:Number;
		private var _timer:Number;
		
		public function ActionStateThrow()
		{
			_disc = "disc";
			_discSpeed = 900;
			_discLifetime = 2;
			_delay = 0.2;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			var p:Projectile = new Projectile();
			p.init(_disc, _discSpeed, actor, _discLifetime, false, true, true);
			p.worldPosition.copy(actor.worldPosition);
			p.worldPosition.x += actor.width * 0.5;
			p.worldPosition.y += actor.height * 0.5;
			p.worldOrientation.copy(actor.worldOrientationAim);
			p.rotation = p.worldOrientation.rotation();
			game.handleSignal(Signals.PROJECTILE_ADD, p);
			game.getPlayer().setHasDisc(false);
			
			actor.handleSignal(game, Signals.MOVEMENT_PAUSE, true);
			actor.handleSignal(game, Signals.ANIM_PLAY, Animations.THROW);
			
			var sounds:Array = [Audio.sfx_disc_fly_01, Audio.sfx_disc_fly_02];
			SoundPlayer.playRandom(sounds, Settings.VolumeSfx);
			
			_timer = 0;
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer += elapsed;
			return (_timer > _delay); // Done!
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			actor.handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			actor.handleSignal(game, Signals.MOVEMENT_UNPAUSE, true);
		}
	}
}