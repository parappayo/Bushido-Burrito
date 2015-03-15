package sim.actors 
{
	import starling.textures.TextureAtlas;
	
	import sim.*;
	import sim.components.*;
	import sim.components.animstates.*;
	import sim.components.actionstates.*;

	public class StalinOnFoot extends Enemy
	{
		public static const STATE_INIT			:int = 0;
		public static const STATE_STOP_TO_SHOOT	:int = 1;
		public static const STATE_HIT			:int = 2;
		public static const STATE_DEAD			:int = 3;
		
		public static const ShotTimeout :Number = 0.2;
		
		private var _state :int;
		private var _timeInState :Number;
		private var _shotTimer :Number;

		private var health:Health;
		private var animation:Animation;
		private var action:Action;
		private var movement:Component;
		
		public function StalinOnFoot(movementSpeed:Number, textureAtlas:TextureAtlas) 
		{
			health = new Health(3);
			
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(textureAtlas, "stalin_on_foot"));
			bank.add(Animations.SHOOT, new AnimStateSingle(textureAtlas, "stalin_on_foot"));
			bank.add(Animations.HURT, new AnimStateSingle(textureAtlas, "stalin_on_foot"));
			animation = new Animation(bank);

			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.SHOOT, new ActionStateShoot("hero_bullet", 250, 5, false));
			actionBank.add(Actions.DIE, new ActionStateDie());
			action = new Action(actionBank);
			
			// TODO: create a sweeping side to side movement
			movement = new SweepMovement(movementSpeed * 1.2);
			
			_state = STATE_INIT;
			_timeInState = 0;
			_shotTimer = 0;
			changeState(STATE_INIT);
		}

		override public function update(game :Game, elapsed :Number) :void
		{
			_timeInState += elapsed;
			_shotTimer += elapsed;
			
			switch (_state)
			{
				case STATE_INIT:
					{
						handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
						changeState(STATE_STOP_TO_SHOOT);
					}
					break;
					
				case STATE_STOP_TO_SHOOT:
					{
						if (_shotTimer > ShotTimeout)
						{
							shootAtPlayer(game);
						}
					}
					break;
					
				case STATE_HIT:
					{
						if (_timeInState > 0.2)
						{
							changeState(STATE_STOP_TO_SHOOT);
						}
					}
					break;					
					
				default:
					break;
			}
			
			health.update(game, this, elapsed);
			animation.update(game, this, elapsed);
			action.update(game, this, elapsed);
			movement.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			health.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
			action.handleSignal(game, this, signal, args);
			movement.handleSignal(game, this, signal, args);
		}

		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (ignore == this || isDead()) { return false; }
			
			if (pos.boxCollide(worldPosition))
			{
				var e:Effect = new Effect(Particles.BloodXML, "blood", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
				game.handleSignal(Signals.EFFECT_ADD, e);
				SoundPlayer.playRandom(Audio.bulletEnemySoundList, Audio.VOLUME_SFX);

				health.takeDamage(1);
				if (health.isDead())
				{
					die(game);
				}
				else
				{
					hit(game);
				}
				
				return true;
			}
			return false;
		}
		
		private function changeState(newState :int) :void
		{
			if (_state == newState) { return; }
			
			_state = newState;
			_timeInState = 0;
		}
		
		private function shootAtPlayer(game :Game) :void
		{
			var playerPos :WorldPosition = game.getPlayer().worldPosition;
			worldOrientation.x = playerPos.x - worldPosition.x;
			worldOrientation.y = playerPos.y - worldPosition.y;
			worldOrientationTarget.x = worldOrientation.x;
			worldOrientationTarget.y = worldOrientation.y;
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.SHOOT);
			_shotTimer = 0;
		}
		
		private function hit(game :Game) :void
		{
			SoundPlayer.play(Audio.stalinHit, Audio.VOLUME_SFX_LOUD);
			changeState(STATE_HIT);
			handleSignal(game, Signals.ANIM_PLAY, Animations.HURT);
		}
		
		private function die(game :Game) :void
		{
			SoundPlayer.play(Audio.stalinDeath, Audio.VOLUME_SFX_LOUD);
			changeState(STATE_DEAD);
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.DIE);
			game.handleActorSignal(Signals.STALIN_DIED, this);
		}

		override public function isDead() :Boolean
		{
			return health.isDead();
		}
		
	} // class

} // package
