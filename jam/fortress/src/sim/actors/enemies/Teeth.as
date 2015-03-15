package sim.actors.enemies
{
	import starling.textures.TextureAtlas;
	import sim.*;
	import sim.actors.*;
	import sim.components.*;
	import sim.components.animstates.*;
	import sim.components.actionstates.*;
	import resources.*;

	public class Teeth extends Enemy
	{
		public static const STATE_INIT			:int = 0;
		public static const STATE_WANDERING		:int = 1;
		public static const STATE_DEAD			:int = 2;
			
		public static const MeleeAttackTimeout :Number = 1.0;
		public static const MeleeAttackRange :Number = 30.0;
		public static const MeleeAttackDamage :Number = 1.0;
		
		private var _state :int;
		private var _timeInState :Number;
		
		private var _attackTimer :Number;
		private var _soundTimer :Number;
		private var _lookForPlayerTimer :Number;
		private var _sawPlayer :Boolean;

		private var movement:Component;
		private var animation:Animation;
		private var action:Action;
		
		private var sweepMovement:SweepMovement;
		
		public function Teeth(movementSpeed:Number, textureAtlas:TextureAtlas) 
		{
			sweepMovement = new SweepMovement(240.0);
			sweepMovement.eastWest = false;
				
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.WALK, new AnimState4Way(textureAtlas, "teeth_walk", Settings.SpriteFramerate));
			bank.add(Animations.IDLE, new AnimStateSingle(textureAtlas, "teeth_idle"));
			animation = new Animation(bank);
			animation.play(Animations.IDLE);

			var actionBank:ActionBank = new ActionBank();
//			actionBank.add(Actions.DIE, new ActionStateDie());
			action = new Action(actionBank);
			
			_state = STATE_INIT;
			_timeInState = 0;
			changeState(STATE_WANDERING);

			_attackTimer = 0;
			_soundTimer = 0;
		}

		override public function update(game :Game, elapsed :Number) :void
		{
			_attackTimer += elapsed;
			_soundTimer += elapsed;
			_timeInState += elapsed;
			_lookForPlayerTimer += elapsed;
			
			var playerDistance :Number = 10000.0;
			
			if (!isDead())
			{
				playerDistance = game.getPlayer().worldPosition.distance(worldPosition);
			
				const idleSoundDistance:Number = 500;
				const soundTimerTimeout:Number = 3 + (Math.random() * 0.5);
				if (playerDistance < idleSoundDistance && _soundTimer > soundTimerTimeout)
				{
					var idles:Array = [Audio.sfx_en_teeth_idle_02, Audio.sfx_en_teeth_idle_03];
					const volumeModifier:Number = Math.max(1 - (playerDistance / idleSoundDistance), 0.3);
					SoundPlayer.playRandom(idles, Settings.VolumeSfx * volumeModifier);
					_soundTimer = 0;
				}
				
				if (playerDistance < MeleeAttackRange && _attackTimer > MeleeAttackTimeout)
				{
					// bite the player
					var attacks:Array = [Audio.sfx_en_teeth_attack_01, Audio.sfx_en_teeth_attack_02];
					SoundPlayer.playRandom(attacks, Settings.VolumeSfx);
					game.getPlayer().takeDamage(game, MeleeAttackDamage);
					_attackTimer = 0;
				}
			}
			else
			{
				_sawPlayer = false;
			}
			
			game.getWalkmesh().setEnemyPresence(worldPosition.x, worldPosition.y, false);
			movement.update(game, this, elapsed);
			game.getWalkmesh().setEnemyPresence(worldPosition.x, worldPosition.y, true);
			
			animation.update(game, this, elapsed);
			action.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			movement.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
			action.handleSignal(game, this, signal, args);
		}

		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			return false;
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (isDead()) { return; }
			
			if (worldPosition.distance(pos) < radius)
			{
				die(game);
			}
		}
		
		private function changeState(newState :int) :void
		{
			if (_state == newState) { return; }
			
			switch (newState)
			{
				case STATE_WANDERING:
					{
						movement = sweepMovement;
					}
					break;					
			}
			
			_state = newState;
			_timeInState = 0;
		}
		
		private function die(game :Game) :void
		{
			changeState(STATE_DEAD);
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.DIE);
		}
		
		override public function isDead() :Boolean
		{
			return _state == STATE_DEAD;
		}
		
	} // class

} // package
