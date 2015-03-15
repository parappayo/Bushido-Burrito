
package  
{
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.events.EnterFrameEvent;
		
	import wyverntail.core.*;
	import wyverntail.ogmo.*;
	import wyverntail.collision.*;
	import common.*;
	import components.*;
	
	import ui.flows.RootFlow;
	import ui.flows.FlowStates;

	CONFIG::Ouya
	{
		import flash.desktop.NativeApplication;
	}

	public class Game extends starling.display.Sprite
	{
		private var _rootFlow :RootFlow;
		private var _currentLevelData :Class;
		private var _spawnPointName :String;
		
		// all UI elements that should be on top of gameplay go here
		public var UISprite :Sprite; // TODO: fix this to not be public
		
		private var _gameplaySprite :Sprite;
		private var _gameplayScene :Scene;
		private var _globalScene :Scene;
		
		public function Game() 
		{
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
			
			createGlobalScene();
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
			
			if (signal == Signals.LEVEL_RESET)
			{
				loadLevel(_currentLevelData, _spawnPointName);
			}
			
			return false;
		}
		
		// called only while the game is running, not paused
		public function updateSim(elapsed :Number) :void
		{
			_globalScene.update(elapsed);
			_gameplayScene.update(elapsed);
		}
		
		// hack for LD29
		public function getNextLevel() :Class
		{
			if (_currentLevelData == Assets.level1) { return Assets.level2; }
			if (_currentLevelData == Assets.level2) { return Assets.level3; }
			
			return null; // ends the game
		}
		
		// hack for LD29
		public function playLevelMusic(levelData :Class) :void
		{
			if      (levelData == Assets.level2) { SoundPlayer.playMusic(Assets.BattleMusic2); }
			else if (levelData == Assets.level3) { SoundPlayer.playMusic(Assets.BattleMusic3); }
			else                                 { SoundPlayer.playMusic(Assets.BattleMusic); }
		}
		
		public function unloadLevel() :void
		{
			_gameplayScene.destroy();
			_gameplaySprite.removeChildren(0, -1, true);			
		}
		
		public function createGlobalScene() :void
		{
//			var factory :Factory = new Factory();

//			factory.addPrefab("game_logic", Vector.<Class>([ ]), { game : this } );
//			factory.spawn(_globalScene, "game_logic", {});
		}
		
		public function loadLevel(levelData :Class, spawnPointName :String) :void
		{
			_currentLevelData = levelData;
			_spawnPointName = spawnPointName;
			
			// prevent two levels from being loaded together
			unloadLevel();
			
			var level :Level = new Level();
			
			// TODO: ideally the layer definitions and their properties come out of loading the Ogmo project XML (oep) file
			level.defineLayer("walkmesh", Layer.LAYER_TYPE_GRID);
			level.defineLayer("entities", Layer.LAYER_TYPE_ENTITIES);
			level.defineLayer("background", Layer.LAYER_TYPE_TILES);
			level.init(levelData);
			
			var backgroundLayer :TileLayer = level.layers["background"] as TileLayer;
			backgroundLayer.tilesAtlas = Assets.TilesAtlas;			
			var background :TileSprite = new TileSprite();
			background.setTiles(level.layers["background"] as TileData);
			background.setParent(_gameplaySprite);

			var walkmeshLayer :GridLayer = level.layers["walkmesh"] as GridLayer;
			var cellgrid :CellGrid = new CellGrid(level.width / Settings.TileWidth, Settings.TileWidth, Settings.TileHeight);
			cellgrid.addData(walkmeshLayer.bitstring);

			var factory :Factory = new Factory();

			factory.addPrefab("camera",
				Vector.<Class>([ Position2D, Camera ]),
				{});
			var camera :wyverntail.core.Entity = factory.spawn(_gameplayScene, "camera", { target : _gameplaySprite } );
			
			var cameraComponent :Camera = camera.getComponent(Camera) as Camera;
			cameraComponent.worldX = (level.width - Settings.TileWidth) * 0.5;
			cameraComponent.worldY = (level.height - Settings.TileHeight) * 0.5;

			factory.addPrefab("player_spawn",
				Vector.<Class>([ Position2D, Spawn ]),
				{
					game : this,
					factory : factory,
					playerSide : true
				});

			factory.addPrefab("enemy_spawn",
				Vector.<Class>([ Position2D, Spawn ]),
				{
					game : this,
					factory : factory,
					playerSide : false
				});
				
			addUnitPrefab(factory, "dwarf", cellgrid, 14);
			addUnitPrefab(factory, "knight", cellgrid, 12);
			addUnitPrefab(factory, "mage_red", cellgrid, 0);
			addUnitPrefab(factory, "mage_green", cellgrid, 0);
			addUnitPrefab(factory, "mage_blue", cellgrid, 0);
				
			addAnimatedPrefab(factory, "torch", cellgrid, -10, 12);
			addPropPrefab(factory, "barrel", cellgrid);
			addPropPrefab(factory, "crate", cellgrid);
			
			factory.addPrefab("grid_view", Vector.<Class>([ GridView, GridViewToggleControl ]), { parentSprite : _gameplaySprite } );
			factory.spawn(_gameplayScene, "grid_view", { } );
			
			factory.addPrefab("move_limit_view", Vector.<Class>([ MoveLimitView ]), { parentSprite : _gameplaySprite } );
			factory.spawn(_gameplayScene, "move_limit_view", { } );

			factory.addPrefab("level_logic",
				Vector.<Class>([ TurnManager ]),
				{
					game : this	
				});
			factory.spawn(_gameplayScene, "level_logic", {});

			var entityLayer :EntityLayer = level.layers["entities"] as EntityLayer;
			entityLayer.spawn(_gameplayScene, factory);
			
			playLevelMusic(levelData);
		}
		
		protected function addUnitPrefab(factory :Factory, name :String, cellgrid :CellGrid, pivotOffsetX :Number, pivotOffsetY :Number = 0) :void
		{
			var unitStats :Object;
			switch (name)
			{
				case "dwarf":
					{
						unitStats = {
							caption : "Dwarf Fighter",
							hitPoints : 80
							}
					}
					break;
				
				case "knight":
					{
						unitStats = {
							caption : "Dark Knight",
							hitPoints : 40
							}
					}
					break;

				default:
					{
						unitStats = {
							caption : name,
							hitPoints : 32
							}
					}
					break;
			}
			
			factory.addPrefab(name,
				Vector.<Class>([
					Position2D,
					wyverntail.core.MovieClip,
					CellCollider,
					IdleAnimation,
					TacticalGridMovement,
					Selectable,
					Attackable,
					UnitStats
					]),
				{
					animName : name,
					game : this,
					parentSprite : _gameplaySprite,
					width : Settings.TileWidth,
					height : Settings.TileHeight,
					pivotOffsetX : pivotOffsetX,
					pivotOffsetY : pivotOffsetY,
					cellgrid : cellgrid,
					unitStats : unitStats
				});
		}
		
		protected function addAnimatedPrefab(factory :Factory, name :String, cellgrid :CellGrid, pivotOffsetX :Number, pivotOffsetY :Number) :void
		{
			factory.addPrefab(name,
				Vector.<Class>([ Position2D, wyverntail.core.MovieClip, CellCollider, IdleAnimation ]),
				{
					animName : name,
					game : this,
					parentSprite : _gameplaySprite,
					width : Settings.TileWidth,
					height : Settings.TileHeight,
					pivotOffsetX : pivotOffsetX,
					pivotOffsetY : pivotOffsetY,
					cellgrid : cellgrid
				});
		}
		
		protected function addPropPrefab(factory :Factory, name :String, cellgrid :CellGrid) :void
		{
			factory.addPrefab(name,
				Vector.<Class>([ Position2D, wyverntail.core.Sprite, CellCollider ]),
				{
					parentSprite : _gameplaySprite,
					texture : Assets.EntitiesAtlas.getTexture(name),
					width : Settings.TileWidth,
					height : Settings.TileHeight,
					cellgrid : cellgrid
				});
		}
		
	} // class

} // package

