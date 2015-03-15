package sim.actors 
{
	import starling.textures.TextureAtlas;
	import sim.*;
	import sim.components.*;
	import sim.components.animstates.*;
	import sim.components.actionstates.*;

	public class Stalin extends Enemy
	{
		public static const STATE_INIT			:int = 0;
		public static const STATE_STOP_TO_SHOOT	:int = 1;
		public static const STATE_HIT			:int = 2;
		public static const STATE_DEAD			:int = 3;
		
		public static const ShotTimeout :Number = 1;
		
		private var _state :int;
		private var _timeInState :Number;
		private var _shotTimer :Number;

		private var health:Health;
		private var animation:Animation;
		private var action:Action;
		
		public function Stalin(movementSpeed:Number, textureAtlas:TextureAtlas) 
		{
			health = new Health(3);
			
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(textureAtlas, "stalin_idle"));
			bank.add(Animations.SHOOT, new AnimStateSingle(textureAtlas, "stalin_shoot"));
			bank.add(Animations.HURT, new AnimStateSingle(textureAtlas, "stalin_hit"));
			animation = new Animation(bank);

			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.SHOOT, new ActionStateTankShoot("tank_bullet", 300));
			actionBank.add(Actions.DIE, new ActionStateDie());
			action = new Action(actionBank);
			
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
						setWalkmesh(game, false);
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
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			health.handleSignal(game, this, signal, args);
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
			
			var adjustedPos :WorldPosition = new WorldPosition();
			adjustedPos.copy(pos);
			adjustedPos.x -= Settings.TileW;
			adjustedPos.y -= Settings.TileH * 2;
			
			if (worldPosition.distance(adjustedPos) < radius*2)
			{
				health.takeDamage(1);
				if (health.isDead())
				{
					die(game);
				}
				else
				{
					hit(game);
				}
			}
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
			worldOrientation.setValues(0, 1);
			worldOrientationTarget.setValues(0, 1);
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
			handleSignal(game, Signals.ANIM_PLAY, Animations.HURT);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.DIE);
			game.handleActorSignal(Signals.STALIN_DIED, this);
			setWalkmesh(game, true);
		}
		
		override public function isDead() :Boolean
		{
			return health.isDead();
		}
		
		private function setWalkmesh(game:Game, walkable:Boolean) :void
		{
			game.getWalkmesh().setWalkable(worldPosition.x+Settings.TileW, worldPosition.y+Settings.TileH*2, walkable);
			game.getWalkmesh().setWalkable(worldPosition.x+Settings.TileW*2, worldPosition.y+Settings.TileH*2, walkable);
			game.getWalkmesh().setWalkable(worldPosition.x+Settings.TileW*3, worldPosition.y+Settings.TileH*2, walkable);
		}
		
	} // class

} // package
