package  
{
	import sim.*;
	import sim.actors.*;
	
	import ui.screens.RadioDialog;
	import ui.flows.RootFlow;
	import ui.flows.FlowStates;
	
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	
	import flash.events.Event;

	CONFIG::Ouya
	{
		import flash.desktop.NativeApplication;
	}

	public class Game extends Sprite
	{
		public var inputHandler :InputHandler;

		private var _level :Level;
		private var _camera :Camera;
		private var _rootFlow :RootFlow;
		private var _tint :Quad
		
		// should always be on top of other gameplay
		public var UISprite :Sprite;
		
		public function Game()
		{
			CONFIG::Ouya
			{
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleAppFocusLost);
			}
			
			Assets.init();
			Memory.init();
			SoundPlayer.init();

			UISprite = new Sprite();
			
			_level = new Level(this);
			addChild(_level);
			
			_rootFlow = new RootFlow(this);
			_rootFlow.changeState(FlowStates.FRONT_END_FLOW);
			
			inputHandler = new InputHandler(this);
			addChild(inputHandler);
			
			_camera = new Camera();

			addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
			
			addChild(UISprite);
			
			_tint = new Quad(Settings.ScreenWidth * 2, Settings.ScreenHeight * 2, Settings.TintColour);
			_tint.x = -(Settings.ScreenWidth / 2);
			_tint.y = -(Settings.ScreenHeight / 2);
			_tint.alpha = Settings.TintAlpha;
			addChild(_tint);
		}
		
		public function handleSignal(signal :int, args :Object = null) :void
		{
			_level.handleSignal(this, signal, args);
			_rootFlow.handleSignal(signal);
		}
		
		public function handleEnterFrame(event :EnterFrameEvent) :void
		{
			_rootFlow.update(event.passedTime);
		}
		
		// called only while the game is running, not paused
		public function updateSim(elapsed :Number) :void
		{
			if (elapsed > 0.1) { elapsed = 0.1; }
			
			_level.update(this, elapsed);
			_level.applyCamera(_camera);
		}
		
		public function pause() :void
		{
			_rootFlow.handleSignal(Signals.PAUSE_GAME);
		}
		
		public function resume() :void
		{
			_rootFlow.handleSignal(Signals.RESUME_GAME);			
		}
		
		public function loadLevel(levelName :String) :void
		{
			_level.loadLevel(levelName);
		}
		
		public function clearLevel() :void
		{
			_level.clear();
		}
		
		public function clearPlayer(hard:Boolean) :void
		{
			_level.player.clear(hard);
		}
		
		public function getWalkmesh() :Walkmesh
		{
			return _level.walkmesh;
		}
		
		public function getPlayer() :Player
		{
			return _level.player;
		}
		
		public function centerCameraOnPlayer() :void
		{
			_camera.worldPosition.x = _level.player.worldPosition.x - Settings.ScreenWidth / 3;
			_camera.worldPosition.y = _level.player.worldPosition.y - Settings.ScreenHeight / 3;
		}
		
		public function setRadioCaption(dialog :RadioDialog) :void
		{
			dialog.setCaption(_level.getRadioCaption());
		}
		
		public function handleActorSignal(signal :int, args :Object) :void
		{
			_level.handleSignal(this, signal, args);
		}
		
		public function checkCollision(pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (_level.player.checkCollision(this, pos, ignore))
			{
				return true;
			}
			
			if (_level.enemies.checkCollision(this, pos, ignore))
			{
				return true;
			}

			if (_level.props.checkCollision(this, pos, ignore))
			{
				return true;
			}
			
			const xOffset:Number = Settings.TileW/2 + 6.5; // magic :)
			const yOffset:Number = Settings.TileH/2 + 6.5; // magic :)
			if (!getWalkmesh().isWalkable(pos.x-xOffset, pos.y-yOffset))
			{
				//var e:Effect = new Effect(Particles.MetalHitXML, "metalhit", pos.x, pos.y, 0.1);
				//handleSignal(Signals.EFFECT_ADD, e);
				SoundPlayer.playRandom(Audio.bulletConcreteSoundList, Audio.VOLUME_SFX);
				return true;
			}
			
			return false;			
		}
		
		public function checkExplosion(pos :WorldPosition, radius :Number) :void
		{
			_level.player.checkExplosion(this, pos, radius);
			_level.enemies.checkExplosion(this, pos, radius);
			_level.props.checkExplosion(this, pos, radius);
		}
		
		public function checkPush(pos :WorldPosition, dir :WorldOrientation) :void
		{
			_level.props.checkPush(this, pos, dir);
		}
		
		public function isInBossFight() :Boolean
		{
			return _level.isBossFight();
		}
		
		public function handleAppExit(e :Event) :void
		{
			_rootFlow.handleSignal(Signals.APP_EXIT);
		}
		
		public function handleAppFocusLost(e :Event) :void
		{
			pause();
			SoundPlayer.stopMusic();
			
			// hack so that InGameFlow knows to resume playing the music
			SoundPlayer._musicChannel = null;
		}

	} // class
	
} // package
