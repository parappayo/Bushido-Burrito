package sim 
{
	import resources.*;
	import sim.actors.*;
	import sim.actors.props.*;
	import ui.screens.*;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import flash.utils.ByteArray;
	
	public class Level extends SpriteActor
	{
		public var backgroundTiles :BackgroundTiles;
		public var foregroundTiles :BackgroundTiles;
		public var walkmesh :Walkmesh;
		public var player :Player;
		public var enemies :EnemyManager;
		public var props :PropManager;
		public var projectiles :ProjectileManager;
		public var effects :EffectManager;
		
		// improper UI
		public var loadingScreen :LoadingScreen;
		
		private var depthSorted :Sprite;
		
		private var _levelName :String;
		private var _spawnID :String;
		private var _pendingLoadLevel :String;
		
		private var _game :Game;
		
		// hack
		private var _lastUsedRadio :Radio;

		public function Level(game :Game)
		{
			_game = game;
			
			// background
			backgroundTiles = new BackgroundTiles();
			addChild(backgroundTiles);
			
			// depth sorted
			depthSorted = new Sprite();
			addChild(depthSorted);
			player = new Player();
			enemies = new EnemyManager(depthSorted);
			props = new PropManager(depthSorted);
			
			// projectiles
			projectiles = new ProjectileManager(this);

			// effects
			effects = new EffectManager(this);
			
			// foreground
			foregroundTiles = new BackgroundTiles();
			addChild(foregroundTiles);
			
			loadingScreen = new LoadingScreen();
		}
		
		public function clear() :void
		{
			backgroundTiles.clear();
			foregroundTiles.clear();
			depthSorted.removeChildren();
			
			player.clear();
			enemies.clear();
			props.clear();
			projectiles.clear();
			effects.clear();
		}
		
		/**
		 *  Level data comes from Ogmo editor XML.
		 */
		private function load(data :Class) :void
		{
			clear();
			
			if (_levelName == null)
			{
				_levelName = "sandbox";
			}
			
			if (_spawnID == null)
			{
				_spawnID = "";
			}
					
			var rawData :ByteArray = new data();
			var dataString :String = rawData.readUTFBytes(rawData.length);
			var levelData :XML = new XML(dataString);

			var xml :XML;
			var xmlList :XMLList;
			var actor :SpriteActor;
			var blockWalkmesh :Boolean;

			var bitstring :String = levelData.walkmesh[0];
			walkmesh = new Walkmesh(bitstring);
			
			depthSorted.addChild(player);
			var playerSpawnFound :Boolean = false;
			
			xmlList = levelData.actors.children();
			for each (xml in xmlList)
			{
				actor = null;
				blockWalkmesh = false;
				
				if (xml.name().localName == "chloe")
				{
					if (xml.@spawn_id == _spawnID)
					{
						playerSpawnFound = true;
						player.worldPosition.x = xml.@x;
						player.worldPosition.y = xml.@y;
						_game.centerCameraOnPlayer();
					}
				}
				else if (xml.name().localName == "cat")
				{
					actor = props.spawn(Prop.TYPE_CAT);
				}
				else if (xml.name().localName == "exit")
				{
					actor = props.spawn(Prop.TYPE_STAIRS);
					
					var stairs :Stairs = actor as Stairs;
					stairs.NextLevelName = xml.@to_level_id;
					stairs.NextSpawnPoint = xml.@to_spawn_id;
				}
				else if (xml.name().localName == "prop1" || xml.name().localName == "prop2" || xml.name().localName == "prop3" || xml.name().localName == "prop4" || xml.name().localName == "prop5" || xml.name().localName == "prop6" || xml.name().localName == "prop7" || xml.name().localName == "prop8" || xml.name().localName == "prop9")
				{
					actor = props.spawn(Prop.TYPE_GENERIC, xml.name().localName);
				}
				else if (xml.name().localName == "radio")
				{
					actor = props.spawn(Prop.TYPE_RADIO);
					
					var radio :Radio = actor as Radio;
					radio.MessageCaption = xml.@message;
				}
				
				if (actor != null)
				{
					actor.worldPosition.x = xml.@x;
					actor.worldPosition.y = xml.@y;
					if (blockWalkmesh)
					{
						walkmesh.setWalkable(actor.worldPosition.x, actor.worldPosition.y, false);
					}
				}
			}
			
			if (!playerSpawnFound)
			{
				xml = levelData.actors.player_spawn[0];
				player.worldPosition.x = xml.@x;
				player.worldPosition.y = xml.@y;
				_game.centerCameraOnPlayer();				
			}
			
			backgroundTiles.levelWidth = levelData.@width;
			backgroundTiles.levelHeight = levelData.@height;
			backgroundTiles.setData(levelData.background.tile);
			
			foregroundTiles.levelWidth = levelData.@width;
			foregroundTiles.levelHeight = levelData.@height;
			foregroundTiles.setData(levelData.foreground.tile);
			
			hideLoadingScreen();
		}
		
		private function processPendingLoad() :void
		{
			_levelName = _pendingLoadLevel;
			_pendingLoadLevel = null;
			
			if (_levelName == "Sandbox")
			{
				load(Levels.SandboxXML);
			}
			else
			{
				new Assert(_levelName + " level not found!");
			}
		}

		public function loadLevel(levelName: String) :void
		{
			if (levelName == null) { return; }
			
			_pendingLoadLevel = levelName;
			showLoadingScreen();
		}
		
		public function resetLevel() :void
		{
			loadLevel(_levelName);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_pendingLoadLevel != null)
			{
				processPendingLoad();
			}
			
			player.update(game, elapsed);
			enemies.update(game, elapsed);
			props.update(game, elapsed);
			projectiles.update(game, elapsed);
			effects.update(game, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			if (signal == Signals.LEVEL_RESET)
			{
				resetLevel();
			}
			else if (signal == Signals.LEVEL_TRANSITION)
			{
				_spawnID = args.NextSpawnPoint;
				loadLevel(args.NextLevelName);
			}
			else if (signal == Signals.RADIO_USED)
			{
				if (args != null)
				{
					_lastUsedRadio = args as Radio;
				}
			}
			else
			{
				player.handleSignal(game, signal, args);
				enemies.handleSignal(game, signal, args);
				props.handleSignal(game, signal, args);
				projectiles.handleSignal(game, signal, args);
				effects.handleSignal(game, signal, args);
			}
		}
		
		public function applyCamera(camera :Camera) :void
		{
			player.moveCamera(camera);
			
			camera.apply(backgroundTiles);
			camera.apply(foregroundTiles);
			camera.apply(player);
			enemies.applyCamera(camera);
			props.applyCamera(camera);
			projectiles.applyCamera(camera);
			effects.applyCamera(camera);
			
			depthSorted.sortChildren(sortOnY);
		}
		
		private function sortOnY(obj1 :DisplayObject, obj2 :DisplayObject) :int
		{
			var y1 :Number = obj1.y + obj1.height;
			var y2 :Number = obj2.y + obj2.height;
			
			if (y1 > y2) { return 1; }
			if (y2 > y1) { return -1; }
			
			return 0;
		}
		
		private function showLoadingScreen() :void
		{
			addChild(loadingScreen);
		}

		private function hideLoadingScreen() :void
		{
			removeChild(loadingScreen);
		}
		
		public function getRadioCaption() :String
		{
			return _lastUsedRadio.MessageCaption;
		}
		
	} // class

} // package

