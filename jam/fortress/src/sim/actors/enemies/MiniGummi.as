package sim.actors.enemies
{
	import resources.Atlases;
	import starling.textures.TextureAtlas;
	import sim.*;
	import sim.actors.*;
	import sim.components.*;
	import sim.components.animstates.*;
	import sim.components.actionstates.*;
	import resources.*;

	public class MiniGummi extends Enemy
	{
		public static const STATE_INIT			:int = 0;
		public static const STATE_WANDERING		:int = 1;
		public static const STATE_CHASE			:int = 2;
		public static const STATE_DEAD			:int = 3;
		
		public static const SeePlayerDistance :Number = 600.0;
		public static const CheckForPlayerTimer :Number = 2.0;
		public static const ChaseTimeout :Number = 5.0;
		public static const ChaseDestinationRadius :Number = 10.0;
		
		public static const MeleeAttackTimeout :Number = 0.5;
		public static const MeleeAttackRange :Number = 5.0;
		public static const MeleeAttackDamage :Number = 0.2;
		
		private var _state :int;
		private var _timeInState :Number;
		private var _lifetime :Number;
		
		private var _attackTimer :Number;
		private var _lookForPlayerTimer :Number;
		private var _sawPlayer :Boolean;

		private var movement:Component;
		private var animation:Animation;
		private var action:Action;
		
		private var _animBank:AnimationBank;
		
		// swap movement strategies depending on state
		private var darknutMovement:DarknutMovement;
		private var chaseMovement:ChaseMovement;
		private var noMovement:IdleComponent;
		
		public function MiniGummi(movementSpeed:Number, textureAtlas:TextureAtlas) 
		{
			darknutMovement = new DarknutMovement(movementSpeed * 0.60);
			chaseMovement = new ChaseMovement(movementSpeed * 1.80);
			noMovement = new IdleComponent();
		
			_animBank = new AnimationBank();

			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.DIE, new ActionStateDie());
			action = new Action(actionBank);
			
			_state = STATE_INIT;
			_timeInState = 0;
			_lifetime = 0;
			changeState(STATE_WANDERING);			

			_attackTimer = 0;
			_lookForPlayerTimer = 0;
			_sawPlayer = false;
		}
		
		public function initAnims(spawnColor :int) :void
		{
			if (spawnColor == Gummi.COLOR_RED)
			{
				_animBank.add(Animations.WALK, new AnimState4Way(Atlases.ElementsTextures, "mini_gummi2_walk", Settings.SpriteFramerate));
				_animBank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "mini_gummi2_idle"));
			}
			else if (spawnColor == Gummi.COLOR_GREEN)
			{
				_animBank.add(Animations.WALK, new AnimState4Way(Atlases.ElementsTextures, "mini_gummi_walk", Settings.SpriteFramerate));
				_animBank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "mini_gummi_idle"));
			}
			else
			{
				_animBank.add(Animations.WALK, new AnimState4Way(Atlases.ElementsTextures, "mini_gummi3_walk", Settings.SpriteFramerate));
				_animBank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "mini_gummi3_idle"));
			}
			animation = new Animation(_animBank);
			animation.play(Animations.IDLE);
		}

		override public function update(game :Game, elapsed :Number) :void
		{
			_attackTimer += elapsed;
			_timeInState += elapsed;
			_lifetime += elapsed;
			_lookForPlayerTimer += elapsed;
			
			var playerDistance :Number = 10000.0;
			
			if (!isDead())
			{
				playerDistance = game.getPlayer().worldPosition.distance(worldPosition);
			
				// random is to keep all ray-cast checks from happening on the same frame
				if (_lookForPlayerTimer > CheckForPlayerTimer + Math.random())
				{
					_sawPlayer = (playerDistance < SeePlayerDistance) &&
								(worldPosition.CheckLOS(game, game.getPlayer().worldPosition));
					_lookForPlayerTimer = 0;
				}
				
				if (playerDistance < MeleeAttackRange && _attackTimer > MeleeAttackTimeout)
				{
					// bite the player
					if (!SoundPlayer._blockGummiAttack)
					{
						SoundPlayer.playRandom([Audio.sfx_disc_hit_01, Audio.sfx_disc_hit_02], Settings.VolumeSfx*0.8);
						SoundPlayer._blockGummiAttack = true;
						SoundPlayer._blockGummiAttackTimer = 0;
					}
					game.getPlayer().takeDamage(game, MeleeAttackDamage);
					_attackTimer = 0;
				}
			}
			else
			{
				_sawPlayer = false;
			}
			
			switch (_state)
			{
				case STATE_WANDERING:
					{
						if (_sawPlayer)
						{
							chaseMovement.ChasePlayer = true;
							changeState(STATE_CHASE);
						}
					}
					break;
				
				case STATE_CHASE:
					{
						chaseMovement.ChasePlayer = _sawPlayer;
						
						{
							if (_timeInState >= ChaseTimeout)
							{
								// took too long to reach destination
								changeState(STATE_WANDERING);
							}
							else if (chaseMovement.getChasePosition().distance(worldPosition) < ChaseDestinationRadius)
							{
								// destination reached
								changeState(STATE_WANDERING);
							}
						}
					}
					break;
			}
					
			movement.update(game, this, elapsed);
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
			if (ignore == this || isDead()) { return false; }
			
			if (_lifetime > 0.5 && pos.boxCollide(worldPosition, 32, 32))
			{
				die(game);
				return true;
			}
			return false;
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (isDead()) { return; }
			
			// mini-gummi is invulerable at first
			if (_lifetime > 0.5 && worldPosition.distance(pos) < radius)
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
						movement = darknutMovement;
						chaseMovement.ChasePlayer = false;
					}
					break;
					
				case STATE_CHASE:
					{
						movement = chaseMovement;
					}
					break;
					
				default:
					{
						movement = noMovement;
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
			if (!SoundPlayer._blockGummiDeath)
			{
				SoundPlayer.playRandom([Audio.sfx_en_gummi_death_01, Audio.sfx_en_gummi_death_03], Settings.VolumeSfx);
				SoundPlayer._blockGummiDeath = true;
				SoundPlayer._blockGummiDeathTimer = 0;
			}
		}
		
		override public function isDead() :Boolean
		{
			return _state == STATE_DEAD;
		}
		
	} // class

} // package
