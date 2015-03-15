
package  
{
	import flash.geom.Rectangle;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.events.EnterFrameEvent;
		
	import wyverntail.core.*;
	import wyverntail.collision.*;
	import common.*;
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
		private var _depthSortedSprite :Sprite;
		private var _gameplayScene :Scene;
		private var _globalScene :Scene;
		
		private var _player :Entity;
		private var _hero :Entity;
		private var _oldGuy :Entity;
		
		public var commandParser :CommandParser;
		
		public function Game() 
		{
			Assets.init();
			
			commandParser = new CommandParser(this);

			_gameplaySprite = new Sprite();
			_depthSortedSprite = new Sprite();
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
			
			_depthSortedSprite.sortChildren(sortOnY);
		}
		
		private function sortOnY(obj1 :DisplayObject, obj2 :DisplayObject) :int
		{
			var y1 :Number = obj1.y + obj1.height;
			var y2 :Number = obj2.y + obj2.height;
			
			if (y1 > y2) { return 1; }
			if (y2 > y1) { return -1; }
			
			return 0;
		}
		
		public function playerDistanceToHero() :Number
		{
			if (!_player || !_hero || !_oldGuy) { return 9999.0; }
			
			var playerPos :Position2D = _player.getComponent(Position2D) as Position2D;
			var heroPos :Position2D = _hero.getComponent(Position2D) as Position2D;
			var oldGuyPos :Position2D = _oldGuy.getComponent(Position2D) as Position2D;
			
			var distSq :Number = Math.min(playerPos.distanceSquared(heroPos), playerPos.distanceSquared(oldGuyPos));
			return Math.sqrt(distSq);
		}

		public function unloadLevel() :void
		{
			_gameplayScene.destroy();
		}
		
		public function loadLevel() :void
		{
			unloadLevel();
			
			_gameplaySprite.removeChildren(0, -1, true);
			
			var factory :Factory = new Factory();
			
			factory.addPrefab("background",
				Vector.<Class>([ wyverntail.core.Sprite ]),
				{
					parentSprite : _gameplaySprite,
					texture : Assets.BackgroundTexture,
					width : Settings.ScreenWidth,
					height : Settings.ScreenHeight
				} );
			var background :Entity = factory.spawn(_gameplayScene, "background");
			
			_gameplaySprite.addChild(_depthSortedSprite);
			
			var customCollider :PlayerCollider = new PlayerCollider;

			factory.addPrefab("player",
				Vector.<Class>([ Position2D, MovieClip, Hitbox, Movement4Way, Player ]),
				{
					game : this,
					parentSprite : _depthSortedSprite,
					scaleX : 8,
					scaleY : 8,
					walkmesh : customCollider
				});
			_player = factory.spawn(_gameplayScene, "player", { worldX : 600, worldY : 400 } );
			
			factory.addPrefab("hero",
				Vector.<Class>([ Position2D, MovieClip, Hitbox, HeroNPC ]),
				{
					game : this,
					parentSprite : _depthSortedSprite,
					scaleX : 8,
					scaleY : 8
				});
			_hero = factory.spawn(_gameplayScene, "hero", { worldX : Settings.ScreenWidth + 10, worldY : 340 } );

			factory.addPrefab("old_guy",
				Vector.<Class>([ Position2D, MovieClip, Hitbox, OldGuyNPC ]),
				{
					game : this,
					parentSprite : _depthSortedSprite,
					scaleX : 8,
					scaleY : 8
				});
			_oldGuy = factory.spawn(_gameplayScene, "old_guy", { worldX : Settings.ScreenWidth + 20, worldY : 440 } );

			factory.addPrefab("foreground",
				Vector.<Class>([ Position2D, wyverntail.core.Sprite ]),
				{
					parentSprite : _gameplaySprite,
					texture : Assets.ForegroundTexture,
					pivotTopLeft : true,
					scaleX : 8,
					scaleY : 8
				} );
			var foreground :Entity = factory.spawn(_gameplayScene, "foreground",
				{ worldX : 15 * 8, worldY : 58 * 8 } );
			
		}
		
	} // class

} // package

