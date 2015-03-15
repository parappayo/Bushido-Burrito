
package  
{
	import flash.geom.Rectangle;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.events.EnterFrameEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;
		
	// Feathers UI
	import feathers.themes.MinimalMobileTheme;
	import flash.display.BitmapData;

	import wyverntail.core.*;
	import wyverntail.ogmo.*;
	import wyverntail.collision.*;
	import common.*;
	import sim.*;
	import entities.*;
	
	import ui.flows.RootFlow;
	import ui.flows.FlowStates;

	CONFIG::Ouya
	{
		import flash.desktop.NativeApplication;
	}

	public class Game extends starling.display.Sprite
	{
		private var _rootFlow :RootFlow;
		
		// all UI elements that should be on top of gameplay go here
		public var UISprite :Sprite; // TODO: fix this to not be public
		
		private var _gameplaySprite :Sprite;
		private var _gameplayScene :Scene;
		private var _globalScene :Scene;
		
		private var _factory :Factory;
		
		// UI uses this to access game state
		public var SimEntity :wyverntail.core.Entity;
		
		public function Game() 
		{
			initStarling();
			
			Assets.init();

			_gameplaySprite = new Sprite();
			_gameplayScene = new Scene();
			_globalScene = new Scene();

			UISprite = new Sprite();
			_rootFlow = new RootFlow(this);
			_rootFlow.changeState(ui.flows.FlowStates.FRONT_END_FLOW);

			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);

			CONFIG::Ouya
			{
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, handleAppFocusLost);
			}
			
			addChild(_gameplaySprite);
			addChild(UISprite);
			
			Settings.ScreenScaleX = _gameplaySprite.scaleX;
			Settings.ScreenScaleY = _gameplaySprite.scaleY;
		}
		
		protected function initStarling() :void
		{
			new MinimalMobileTheme();
			
			const atlasBitmapData :BitmapData = (new MinimalMobileTheme.ATLAS_IMAGE()).bitmapData;
			const atlas :TextureAtlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new MinimalMobileTheme.ATLAS_XML()));
			
			TextField.registerBitmapFont(new BitmapFont(
				atlas.getTexture("pf_ronda_seven_0"),
				XML(new MinimalMobileTheme.ATLAS_FONT_XML())),
				"theme_font");
		}
		
		protected function handleAddedToStage(event :starling.events.Event) :void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addChild(new InputHandler(this));
		}
		
		public function handleEnterFrame(event :EnterFrameEvent) :void
		{
			_rootFlow.update(event.passedTime);
		}

		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_rootFlow.handleSignal(signal, sender, args)) { return true; }
			if (_globalScene.handleSignal(signal, sender, args)) { return true; }
			if (_gameplayScene.handleSignal(signal, sender, args)) { return true; }
			
			return false;
		}
		
		// called only while the game is running, not paused
		public function updateSim(elapsed :Number) :void
		{
			_globalScene.update(elapsed);
			_gameplayScene.update(elapsed);
		}
		
		public function unloadLevel() :void
		{
			_gameplayScene.destroy();
		}
		
		public function loadLevel(levelData :Class, spawnPointName :String) :void
		{
			// prevent two levels from being loaded together
			unloadLevel();
			_gameplaySprite.removeChildren(0, -1, true);
			
			_factory = new Factory();

			_factory.addPrefab("ninja",
				Vector.<Class>([ Position2D, MovieClip, Ninja, DarknutMovement ]),
				{
					game : this,
					parentSprite : _gameplaySprite
				});

			_factory.addPrefab("sim",
				Vector.<Class>([ NinjaPool, RicePool, CastlePool ]),
				{
					game :this
				});
			SimEntity = _factory.spawn(_gameplayScene, "sim", { target : _gameplaySprite } );
		}
		
		public function spawnNinja() :wyverntail.core.Entity
		{
			return _factory.spawn(_gameplayScene, "ninja",
				{
					worldX : Math.random() * Settings.ScreenWidth,
					worldY : Math.random() * Settings.ScreenHeight
				});
		}

	} // class

} // package

