package sim.actors.enemies
{
	import starling.textures.TextureAtlas;
	import sim.*;
	import sim.actors.*;
	import sim.components.*;
	import sim.components.animstates.*;
	import sim.components.actionstates.*;
	import resources.*;

	public class Sentry extends Enemy
	{
		public static const STATE_INIT				:int = 0;
		public static const STATE_RETURN_TO_POST	:int = 1;
		public static const STATE_CHASE				:int = 2;
		public static const STATE_STOP_TO_SHOOT		:int = 3;
		public static const STATE_DEAD				:int = 4;
		
		public static const SeePlayerDistance :Number = 500.0;
		public static const ShootPlayerDistanceMin :Number = 200.0;
		public static const ShootPlayerDistanceMax :Number = 400.0;
		public static const CheckForPlayerTimer :Number = 0.5;
		public static const ShotTimeout :Number = 0.5;
		public static const ChaseTimeout :Number = 5.0;
		public static const ChaseDestinationRadius :Number = 10.0;
		public static const ExplosionReactRadius :Number = 800.0;
		
		private var _state :int;
		private var _timeInState :Number;
		
		private var _shotTimer :Number;
		private var _lookForPlayerTimer :Number;
		private var _sawPlayer :Boolean;

		private var movement:Component;
		private var animation:Animation;
		private var action:Action;
		
		// swap movement strategies depending on state
		private var chaseMovement:ChaseMovement;
		private var noMovement:IdleComponent;
		
		private var _postedPosition :WorldPosition;
		
		public function Sentry(movementSpeed:Number, textureAtlas:TextureAtlas) 
		{
			chaseMovement = new ChaseMovement(movementSpeed * 1.20);
			noMovement = new IdleComponent();
			movement = noMovement;
		
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.WALK, new AnimState4Way(textureAtlas, "duck_walk", Settings.SpriteFramerate));
			bank.add(Animations.IDLE, new AnimStateSingle(textureAtlas, "duck_walk_down"));
			animation = new Animation(bank);
			animation.play(Animations.IDLE);

			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.SHOOT, new ActionStateShoot("bubble1", 250, 1));
			actionBank.add(Actions.DIE, new ActionStateDie());
			action = new Action(actionBank);
			
			_state = STATE_INIT;
			_timeInState = 0;
			changeState(STATE_RETURN_TO_POST);

			_shotTimer = 0;
			_lookForPlayerTimer = 0;
			_sawPlayer = false;
		}

		override public function update(game :Game, elapsed :Number) :void
		{
			_timeInState += elapsed;
			_shotTimer += elapsed;
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
			}
			else
			{
				_sawPlayer = false;
			}
			
			switch (_state)
			{
				case STATE_RETURN_TO_POST:
					{
						if (_postedPosition == null)
						{
							_postedPosition = new WorldPosition();
							_postedPosition.copy(worldPosition);
						}
						
						if (_sawPlayer)
						{
							chaseMovement.ChasePlayer = true;
							changeState(STATE_CHASE);
						}
						else if (_postedPosition.distance(worldPosition) > 2)
						{
							chaseMovement.setChasePosition(_postedPosition);
							movement = chaseMovement;
						}
						else
						{
							movement = noMovement;
						}
					}
					break;
				
				case STATE_CHASE:
					{
						chaseMovement.ChasePlayer = _sawPlayer;
						
						if (_sawPlayer)
						{
							if (playerDistance < ShootPlayerDistanceMin)
							{
								changeState(STATE_STOP_TO_SHOOT);
							}
						}
						else
						{
							if (_timeInState >= ChaseTimeout)
							{
								// took too long to reach destination
								changeState(STATE_RETURN_TO_POST);
							}
							else if (chaseMovement.getChasePosition().distance(worldPosition) < ChaseDestinationRadius)
							{
								// destination reached
								changeState(STATE_RETURN_TO_POST);
							}
						}
					}
					break;
					
				case STATE_STOP_TO_SHOOT:
					{
						if (!_sawPlayer || playerDistance > ShootPlayerDistanceMax)
						{
							changeState(STATE_CHASE);
						}
						else if (_shotTimer > ShotTimeout)
						{
							shootAtPlayer(game);
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
			if (signal == Signals.EXPLOSION_EVENT)
			{
				if (!isDead() && !_sawPlayer)
				{
					var explodedActor :SpriteActor = args as SpriteActor;
					if (explodedActor != null)
					{
						if (explodedActor.worldPosition.distance(worldPosition) < ExplosionReactRadius)
						{
							chaseMovement.setChasePosition(explodedActor.worldPosition);
							changeState(STATE_CHASE);
						}
					}
				}
			}
			
			
			movement.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
			action.handleSignal(game, this, signal, args);
		}

		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (ignore == this || isDead()) { return false; }
			
			if (pos.boxCollide(worldPosition))
			{
				die(game);
				return true;
			}
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
				case STATE_RETURN_TO_POST:
					{
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
		
		private function shootAtPlayer(game :Game) :void
		{
			var playerPos :WorldPosition = game.getPlayer().worldPosition;
			worldOrientation.x = playerPos.x - worldPosition.x;
			worldOrientation.y = playerPos.y - worldPosition.y;
			worldOrientationAim.x = worldOrientation.x;
			worldOrientationAim.y = worldOrientation.y;
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.SHOOT);
		}
		
		private function die(game :Game) :void
		{
			changeState(STATE_DEAD);
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.DIE);
			SoundPlayer.playRandom([Audio.sfx_en_duck_attack_b_03, Audio.sfx_en_duck_attack_b_05], Settings.VolumeSfxLoud);
		}
		
		override public function isDead() :Boolean
		{
			return _state == STATE_DEAD;
		}
		
	} // class

} // package
