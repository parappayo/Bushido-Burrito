package sim.actors 
{
	
	import sim.*;
	import sim.components.*;
	import sim.components.actionstates.*;
	import sim.components.animstates.*;
	import resources.*;
	
	public class Player extends SpriteActor
	{
		public var health:Health;

		private var input:Input;
		private var movement:Movement;
		
		private var action:Action;
		private var animation:Animation;
		private var actionBank:ActionBank;
		private var doingIntro :Boolean;
		private var introStarted :Boolean;
		private var _hasDisc :Boolean;
		private var introTimer :Number;
		private const IntroWait :Number = 0.5;
		private const IntroWalk :Number = 0.5;
		
		public function Player()
		{
			input = new Input();
			health = new Health(6);
			movement = new Movement(250);
			doingIntro = false;
			introStarted = false;
			_hasDisc = true; 
			introTimer = 0;
			
			actionBank = new ActionBank();
			actionBank.add(Actions.THROW, new ActionStateThrow());
			actionBank.add(Actions.DAMAGE, new ActionStateDamage());
			actionBank.add(Actions.DIE, new ActionStateDie(true));
			actionBank.add(Actions.CHEER, new ActionStateCheer());
			action = new Action(actionBank);
			
			var animBank:AnimationBank = new AnimationBank();
			animBank.add(Animations.IDLE, new AnimState4Way(Atlases.ElementsTextures, "kid_idle", Settings.SpriteFramerate));
			animBank.add(Animations.WALK, new AnimState4Way(Atlases.ElementsTextures, "kid_walk", Settings.SpriteFramerate, new SoundEvent([Audio.sfx_player_footstep_01, Audio.sfx_player_footstep_02], 0.5)));
			animBank.add(Animations.THROW, new AnimState4Way(Atlases.ElementsTextures, "kid_throw", Settings.SpriteFramerate));
			animBank.add(Animations.DEAD, new AnimStateSingle(Atlases.ElementsTextures, "kid_hit_down", true, Settings.SpriteFramerate));
			animation = new Animation(animBank);
		}
		
		public function clear(hard:Boolean) :void
		{
			_hasDisc = true;
			input.reset();
			health.heal();
			alpha = 1;
			action.reset();
			movement.reset();
		}
		
		override public function lock() :void
		{
			input.reset();
			input.lock();
			movement.reset();
			movement.lock();
		}
		
		override public function unlock() :void
		{
			movement.unlock();
			input.unlock();
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			input.update(game, this, elapsed);
			health.update(game, this, elapsed);
			action.update(game, this, elapsed);
			movement.update(game, this, elapsed);
			animation.update(game, this, elapsed);
			
			if (health.isDead())
			{
				die(game);
			}
			else if (doingIntro)
			{
				updateIntro(game, elapsed);
			}
		}
		
		private function updateIntro(game :Game, elapsed :Number) :void
		{
			if (!introStarted)
			{
				if (introTimer > IntroWait)
				{
					onIntroStart(game);
				}
			}
			else
			{
				if (introTimer > IntroWalk)
				{
					onIntroComplete(game);
				}
			}
			introTimer += elapsed;
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			input.handleSignal(game, this, signal, args);
			health.handleSignal(game, this, signal, args);
			action.handleSignal(game, this, signal, args);
			movement.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
		}
		
		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (ignore == this || isDead()) { return false; }
			
			if (pos.boxCollide(worldPosition))
			{
				takeDamage(game, 1);
				return true;
			}
			return false;
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (isDead()) { return; }
			
			if (worldPosition.distance(pos) < radius)
			{
				takeDamage(game, 1);
			}
		}
		
		public function takeDamage(game :Game, damage :Number):void
		{
			if (!Settings.GodMode)
			{
				health.takeDamage(damage);	
			}
			if (!health.isDead())
			{
				handleSignal(game, Signals.ACTION_EXECUTE, Actions.DAMAGE);
			}
		}
		
		private function die(game :Game) :void
		{
			handleSignal(game, Signals.ANIM_PLAY, Animations.IDLE);
			handleSignal(game, Signals.ACTION_EXECUTE, Actions.DIE);
		}
		
		override public function isDead() :Boolean
		{
			return health.isDead();
		}
		
		public function doIntro() :void
		{
			lock();
			doingIntro = true;
			introStarted = false;
			introTimer = 0;
		}
		
		private function onIntroStart(game:Game) :void
		{
			introStarted = true;
			introTimer = 0;
			movement.handleSignal(game, this, Signals.MOVE_LEFT_KEYDOWN, true);
		}
		
		private function onIntroComplete(game:Game) :void
		{
			movement.handleSignal(game, this, Signals.MOVE_LEFT_KEYUP, true);
			doingIntro = false;
			unlock();
		}
		
		/**
		 *  Update camera origin based on player's position.
		 */
		public function moveCamera(camera :Camera) :void
		{
			var horizMargin :Number = Settings.ScreenWidth/2.25;
			var vertMargin :Number = Settings.ScreenHeight/2.25;
			
			if (worldPosition.x < camera.worldPosition.x + horizMargin)
			{
				camera.worldPosition.x = worldPosition.x - horizMargin;
			}
			else if (worldPosition.x > camera.worldPosition.x + Settings.ScreenWidth - horizMargin)
			{				
				camera.worldPosition.x = worldPosition.x - Settings.ScreenWidth + horizMargin;
			}
			
			if (worldPosition.y < camera.worldPosition.y + vertMargin)
			{
				camera.worldPosition.y = worldPosition.y - vertMargin;
			}
			else if (worldPosition.y > camera.worldPosition.y + Settings.ScreenHeight - vertMargin)
			{
				camera.worldPosition.y = worldPosition.y - Settings.ScreenHeight + vertMargin;
			}
		}
		
		public function setHasDisc(disc:Boolean) :void
		{
			_hasDisc = disc;
		}
		
		public function hasDisc() :Boolean
		{
			return _hasDisc;
		}
		
		public function getHealth() :Number
		{
			return health.getCurrent();
		}
		
		public function heal() :void
		{
			health.heal();
		}
		
		public function isFullHealth() :Boolean
		{
			return health.getCurrent() >= health.getMax();
		}
	}

} // package
