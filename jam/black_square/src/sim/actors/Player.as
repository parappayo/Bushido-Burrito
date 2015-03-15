package sim.actors 
{
	
	import sim.*;
	import sim.components.*;
	import sim.components.actionstates.*;
	import sim.components.animstates.*;
	
	public class Player extends SpriteActor
	{
		private var input:Input;
		private var health:Health;
		private var movement:Movement;
		
		private var action:Action;
		private var animation:Animation;
		private var actionBank:ActionBank;
		private var pistolShootAction:ActionStateShoot;
		private var smgShootAction:ActionStateSprayShoot;
		private var hasSmg :Boolean;
		private var doingIntro :Boolean;
		private var introStarted :Boolean;
		private var introTimer :Number;
		private const IntroWait :Number = 0.5;
		private const IntroWalk :Number = 0.5;
		
		public function Player()
		{
			input = new Input();
			health = new Health(5);
			movement = new Movement(180);
			pistolShootAction = new ActionStateShoot("hero_bullet", 400, 6, true);
			smgShootAction = new ActionStateSprayShoot("hero_bullet", 400, 10);
			hasSmg = false;
			doingIntro = false;
			introStarted = false;
			introTimer = 0;
			
			actionBank = new ActionBank();
			actionBank.add(Actions.SHOOT, pistolShootAction);
			actionBank.add(Actions.DAMAGE, new ActionStateDamage());
			actionBank.add(Actions.DIE, new ActionStateDie());
			actionBank.add(Actions.CHEER, new ActionStateCheer());
			action = new Action(actionBank);
			
			var animBank:AnimationBank = new AnimationBank();
			animBank.add(Animations.IDLE, new AnimState4Way(Assets.ElementsTextures, "helmut_idle"));
			animBank.add(Animations.WALK, new AnimState4Way(Assets.ElementsTextures, "helmut_walk"));
			animBank.add(Animations.CHEER, new AnimStateSingle(Assets.ElementsTextures, "helmut_cheer", true, 5));
			animation = new Animation(animBank);
		}
		
		public function clear(hard:Boolean) :void
		{
			input.reset();
			health.heal();
			alpha = 1;
			action.reset();
			movement.reset();
			if (hard)
			{
				unequipSMG();
			}
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
			if (doingIntro)
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
				var e:Effect = new Effect(Particles.BloodXML, "blood", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
				game.handleSignal(Signals.EFFECT_ADD, e);
				SoundPlayer.playRandom(Audio.bulletEnemySoundList, Audio.VOLUME_SFX);
				if (!Settings.GodMode)
				{
					health.takeDamage(1);
				}
				if (health.isDead()) 
				{
					die(game);
				}
				else
				{
					handleSignal(game, Signals.ACTION_EXECUTE, Actions.DAMAGE);
				}
				return true;
			}
			return false;
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (isDead()) { return; }
			
			if (worldPosition.distance(pos) < radius)
			{
				if (!Settings.GodMode)
				{
					health.takeDamage(1);	
				}
				if (health.isDead())
				{
					die(game);
				}
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
			var horizMargin :Number = Settings.ScreenWidth/2.5;
			var vertMargin :Number = Settings.ScreenHeight/2.5;
			
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
		
		/**
		 *  Called when the player finds the smg weapon upgrade
		 */
		public function equipSMG() :void
		{
			if (hasSmg) return;
			hasSmg = true;
			actionBank.remove(Actions.SHOOT);
			actionBank.add(Actions.SHOOT_REPEAT, smgShootAction);
		}
		public function unequipSMG() :void
		{
			if (!hasSmg) return;
			hasSmg = false;
			actionBank.remove(Actions.SHOOT_REPEAT);
			actionBank.add(Actions.SHOOT, pistolShootAction);
		}
		
		public function hasSMG() :Boolean
		{
			return hasSmg;
		}
		
		public function getHealth() :int
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
