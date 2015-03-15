
package  
{
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.events.EnterFrameEvent;
		
	import common.*;
	import entities.*;
	import wyverntail.core.*;
	import wyverntail.ogmo.*;
	import wyverntail.collision.*;
	
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
		
		public function Game() 
		{
			Assets.init();

			_gameplaySprite = new Sprite();

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
			
			var tint :Quad = new Quad(Settings.ScreenWidth * 2, Settings.ScreenHeight * 2, Settings.TintColour);
			tint.x = -(Settings.ScreenWidth / 2);
			tint.y = -(Settings.ScreenHeight / 2);
			tint.alpha = Settings.TintAlpha;
			addChild(tint);
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

		public function handleSignal(signal :int, sender :Object, args :Object) :void
		{
			if (!_rootFlow.handleSignal(signal, sender, args))
			{
				wyverntail.core.Entity.handleSignalAll(signal, sender, args);
			}
		}
		
		// called only while the game is running, not paused
		public function updateSim(elapsed :Number) :void
		{
			wyverntail.core.Entity.updateAll(elapsed);
		}
		
		public function unloadLevel() :void
		{
			wyverntail.core.Entity.destroyAll();
		}
		
		public function loadLevel(levelData :Class, spawnPointName :String) :void
		{
			// prevent two levels from being loaded together
			unloadLevel();
			
			_gameplaySprite.removeChildren(0, -1, true);
			
			// TODO: ideally the layer definitions and their properties come out of loading the Ogmo project XML (oep) file
			var level :Level = new Level();
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
			var camera :wyverntail.core.Entity = factory.spawn("camera", { target : _gameplaySprite } );

			factory.addPrefab("player",
				Vector.<Class>([ Position2D, MovieClip, Hitbox, CameraPusher, Movement4Way, Player ]),
				{
					game : this,
					parentSprite : _gameplaySprite,
					scaleX : 2,
					scaleY : 2,
					walkmesh : cellgrid,
					camera : camera,
					cameraPusherDeadzone : new Rectangle(
							-Settings.ScreenWidth * 0.3,
							-Settings.ScreenHeight * 0.3,
							Settings.ScreenWidth * 0.6,
							Settings.ScreenHeight * 0.6 )
				});
			var player :wyverntail.core.Entity = factory.spawn("player", { worldX : 0, worldY : 0 } );
			
			factory.addPrefab("player_spawn",
				Vector.<Class>([ Position2D, PlayerTeleportDestination ]),
				{ player : player } );
				
			factory.addPrefab("level_transition",
				Vector.<Class>([ Position2D, ProximityTrigger ]),
				{
					game : this,
					player : player,
					triggerRadius : Settings.TileWidth + 6,
					signal : Signals.LEVEL_TRANSITION,
					canRepeat : true
				});

			factory.addPrefab("npc",
				Vector.<Class>([ Position2D, wyverntail.core.Sprite, ActionButtonTrigger, CellCollider ]),
				{
					game : this,
					player : player,
					triggerRadius : Settings.TileWidth + 12,
					signal : Signals.SHOW_DIALOG,
					canRepeat : true,
					parentSprite : _gameplaySprite,
					texture : Assets.EntitiesAtlas.getTexture("demon"),
					width : Settings.TileWidth,
					height : Settings.TileHeight,
					cellgrid : cellgrid
				});
			factory.addPrefab("signpost",
				Vector.<Class>([ Position2D, wyverntail.core.Sprite, ActionButtonTrigger, CellCollider ]),
				{
					game : this,
					player : player,
					triggerRadius : Settings.TileWidth + 12,
					signal : Signals.SHOW_DIALOG,
					parentSprite : _gameplaySprite,
					texture : Assets.EntitiesAtlas.getTexture("signpost"),
					width : Settings.TileWidth,
					height : Settings.TileHeight,
					cellgrid : cellgrid
				});
				
			addPropPrefab(factory, "barrel", cellgrid);
			addPropPrefab(factory, "crate", cellgrid);
			addPropPrefab(factory, "tree_bushy", cellgrid);
			addPropPrefab(factory, "tree_palm", cellgrid);
			addPropPrefab(factory, "tree_pine", cellgrid);
			addPropPrefab(factory, "tree_wither", cellgrid);
			
			var entityLayer :EntityLayer = level.layers["entities"] as EntityLayer;
			entityLayer.spawn(_gameplaySprite, factory);
			
			handleSignal(Signals.TELEPORT_PLAYER, this, { destinationName : spawnPointName } );			
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

