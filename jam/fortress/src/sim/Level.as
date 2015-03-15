package sim 
{
	import maze.MazeCell;
	import maze.MazeData;
	import sim.actors.*;
	import ui.screens.*;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import flash.utils.ByteArray;
	import resources.*;
	
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
		private var _levelCellX :int;
		private var _levelCellY :int;
		private var _shouldGenerate :Boolean;
		private var _mazeData :MazeData;
		
		private var _game :Game;
		
		// hacky
		private var _lastUsedRadio :MessageProp;

		public function Level(game :Game)
		{
			_game = game;
			
			walkmesh = new Walkmesh(Settings.MaxLevelWidth, Settings.RoomWidth+1);
			
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
			
			backgroundTiles.levelWidth = Settings.MaxLevelWidth;
			backgroundTiles.levelHeight = Settings.MaxLevelHeight;
			foregroundTiles.levelWidth = Settings.MaxLevelWidth;
			foregroundTiles.levelHeight = Settings.MaxLevelHeight;
		}
		
		public function clear() :void
		{
			backgroundTiles.clear();
			foregroundTiles.clear();
			depthSorted.removeChildren();
			enemies.clear();
			props.clear();
			projectiles.clear();
			effects.clear();
		}
		
		/**
		 *  Level data comes from Ogmo editor XML.
		 */
		private function load(data :Class, cellX :int, cellY :int) :void
		{
			if (Settings.Verbose) { trace("loading player start at (" + cellX + ", " + cellY + ")"); }
			
			if (_levelName == null)
			{
				_levelName = "Sandbox";
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
			var blockWalkmesh :Boolean;
			var walkmeshOffsetY :Number;
			var walkmeshDoubleY :Boolean;

			var bitstring :String = levelData.walkmesh[0];
			walkmesh.addData(bitstring, cellX, cellY);
			
			depthSorted.addChild(player);
			var playerSpawnFound :Boolean = false;
			
			xmlList = levelData.actors.children();
			for each (xml in xmlList)
			{
				var actor :SpriteActor = null;
				blockWalkmesh = false;
				walkmeshOffsetY = 0;
				walkmeshDoubleY = false;
				
				if (xml.name().localName == "player_spawn")
				{
					if (xml.@spawn_id == _spawnID)
					{
						playerSpawnFound = true;
						player.worldPosition.x = int(xml.@x) + (cellX * Settings.TileW);
						player.worldPosition.y = int(xml.@y) + (cellY * Settings.TileH);
						_game.centerCameraOnPlayer();
						
						if (Settings.Verbose) { trace("player spawn point at (" + (player.worldPosition.x / Settings.TileW) + ", " + (player.worldPosition.y / Settings.TileH) + ")"); }
					}
				}
				else
				{
					actor = spawnEntity(xml);
				}
				
				if (xml.name().localName == "crate")
				{
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "push_block")
				{
					blockWalkmesh = true;
				}

				if (actor != null)
				{
					actor.worldPosition.x = int(xml.@x) + (cellX * Settings.TileW);
					actor.worldPosition.y = int(xml.@y) + (cellY * Settings.TileH);
					if (blockWalkmesh)
					{
						walkmesh.setWalkable(actor.worldPosition.x, actor.worldPosition.y + walkmeshOffsetY, false);
						if (walkmeshDoubleY)
						{
							walkmesh.setWalkable(actor.worldPosition.x, actor.worldPosition.y + walkmeshOffsetY + Settings.TileH, false);
						}
					}
				}
			}
			
			if (!playerSpawnFound)
			{
				xml = levelData.actors.player_spawn[0];
				player.worldPosition.x = int(xml.@x) + (cellX * Settings.TileW);
				player.worldPosition.y = int(xml.@y) + (cellY * Settings.TileH);
				_game.centerCameraOnPlayer();				
			}
			
			backgroundTiles.setData(levelData.background.tile, cellX, cellY);
			foregroundTiles.setData(levelData.foreground.tile, cellX, cellY);
			
			refreshTiles();
			hideLoadingScreen();
		}
		
		private function loadCell(data :Class, cellX :int, cellY :int) :Boolean
		{
			if (!data) { return false; }
			
			if (Settings.Verbose) { trace("loading room cell at (" + cellX + ", " + cellY + ")"); }
			
			var rawData :ByteArray = new data();
			var dataString :String = rawData.readUTFBytes(rawData.length);
			var levelData :XML = new XML(dataString);

			var xml :XML;
			var xmlList :XMLList;
			var blockWalkmesh :Boolean;
			var walkmeshOffsetY :Number;
			var walkmeshDoubleY :Boolean;

			var bitstring :String = levelData.walkmesh[0];
			walkmesh.addData(bitstring, cellX, cellY);
			
			depthSorted.addChild(player);
			
			xmlList = levelData.actors.children();
			for each (xml in xmlList)
			{
				blockWalkmesh = false;
				walkmeshOffsetY = 0;
				walkmeshDoubleY = false;
				
				var actor :SpriteActor = spawnEntity(xml);
				
				if (xml.name().localName == "crate")
				{
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "push_block")
				{
					blockWalkmesh = true;
				}
				
				if (actor != null)
				{
					actor.worldPosition.x = int(xml.@x) + (cellX * Settings.TileW);
					actor.worldPosition.y = int(xml.@y) + (cellY * Settings.TileH);
					if (blockWalkmesh)
					{
						walkmesh.setWalkable(actor.worldPosition.x, actor.worldPosition.y + walkmeshOffsetY, false);
						if (walkmeshDoubleY)
						{
							walkmesh.setWalkable(actor.worldPosition.x, actor.worldPosition.y + walkmeshOffsetY + Settings.TileH, false);
						}
					}
				}
			}
			
			backgroundTiles.setData(levelData.background.tile, cellX, cellY);
			foregroundTiles.setData(levelData.foreground.tile, cellX, cellY);
			
			return true;
		}
		
		private function spawnEntity(xml :XML) :SpriteActor
		{
			var actor :SpriteActor;
			
			if (xml.name().localName == "teeth")
			{
				return enemies.spawn(Enemy.TYPE_TEETH);
			}
			else if (xml.name().localName == "gummi")
			{
				return enemies.spawn(Enemy.TYPE_GUMMI);
			}
			else if (xml.name().localName == "kitty")
			{
				return enemies.spawn(Enemy.TYPE_KITTY);
			}
			else if (xml.name().localName == "sentry")
			{
				return enemies.spawn(Enemy.TYPE_SENTRY);
			}
			else if (xml.name().localName == "scout")
			{
				return enemies.spawn(Enemy.TYPE_SCOUT);
			}
			else if (xml.name().localName == "assault")
			{
				return enemies.spawn(Enemy.TYPE_ASSAULT);
			}
			else if (xml.name().localName == "exit")
			{
				actor = props.spawn(Prop.TYPE_STAIRS);
				
				var stairs :Stairs = actor as Stairs;
				stairs.NextLevelName = xml.@to_level_id;
				stairs.NextSpawnPoint = xml.@to_spawn_id;
				
				return actor;
			}
			else if (xml.name().localName == "barrel")
			{
				return props.spawn(Prop.TYPE_BARREL);
			}
			else if (xml.name().localName == "crate")
			{
				return props.spawn(Prop.TYPE_CRATE);
			}
			else if (xml.name().localName == "push_block")
			{
				return props.spawn(Prop.TYPE_PUSH_BLOCK);
			}
			else if (xml.name().localName == "proximity_mine")
			{
				return props.spawn(Prop.TYPE_PROXIMITY_MINE);
			}
			else if (xml.name().localName == "radio")
			{
				actor = props.spawn(Prop.TYPE_RADIO);
					
				var radio :Radio = actor as Radio;
				radio.MessageCaption = xml.@message;
				//radio.MessageCaption.replace("\\n", "\n");
				
				return actor;
			}
			else if (xml.name().localName == "weapon_smg_pickup")
			{
				return props.spawn(Prop.TYPE_WEAPON_SMG_PICKUP);
			}
			else if (xml.name().localName == "firstaid")
			{
				return props.spawn(Prop.TYPE_FIRST_AID);
			}
			else if (xml.name().localName == "goal")
			{
				return props.spawn(Prop.TYPE_GOAL);
			}
			
			return null;
		}
		
		private function processPendingLoad() :void
		{
			_levelName = _pendingLoadLevel;
			_pendingLoadLevel = null;
			load(Levels[_levelName], _levelCellX, _levelCellY);
		}

		public function loadLevel(levelName :String, cellX :int, cellY :int) :void
		{
			if (levelName == null) { return; }
			
			_pendingLoadLevel = levelName;
			_levelCellX = cellX;
			_levelCellY = cellY;
			showLoadingScreen();
		}
		
		public function generate(mazeData :MazeData) :void
		{
			_shouldGenerate = true;
			_mazeData = mazeData;
		}
		
		public function _generate() :void
		{
			// sets up the player spawn point
			var x :int = _mazeData.playerStartX;
			var y :int = _mazeData.playerStartY;
			load(Levels["PlayerStartRoom"], x * Settings.RoomWidth, y * Settings.RoomHeight);

			for (y = 0; y < _mazeData.height; y++)
			{
				for (x = 0; x < _mazeData.width; x++)
				{
					if (x == _mazeData.playerStartX && y == _mazeData.playerStartY) { continue; }
					
					var cell :MazeCell = _mazeData.getCell(x, y);
					if (!cell || !cell.visited) { continue; }
					
					if (!loadCell(Levels[cell.getLevelName()], x * Settings.RoomWidth, y * Settings.RoomHeight))
					{
						trace("error: could not find level " + cell.getLevelName());
					}
				}
			}
			
			refreshTiles();
		}
		
		public function resetLevel() :void
		{
			_shouldGenerate = true;
		}
		
		public function refreshTiles() :void
		{
			backgroundTiles.refresh();
			foregroundTiles.refresh();
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_pendingLoadLevel != null)
			{
				clear();
				processPendingLoad();
				_pendingLoadLevel = null;
			}
			if (_shouldGenerate)
			{
				_shouldGenerate = false;
				clear();
				_generate();
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
				// level transition not allowed for Fortress jam
//				if (args.NextLevelName != "")
//				{
//					_spawnID = args.NextSpawnPoint;
//					loadLevel(args.NextLevelName);
//				}
			}
			else if (signal == Signals.RADIO_USED)
			{
				if (args != null)
				{
					_lastUsedRadio = args as MessageProp;
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
			onLoadComplete();
		}
		
		private function onLoadComplete() :void
		{
			if (_levelName == "Area01_Courtyard" && _spawnID != "back")
			{
				player.doIntro();
			}
		}
		
		public function getRadioCaption() :String
		{
			return _lastUsedRadio.getMessageCaption();
		}
		
		public function isBossFight() :Boolean
		{
			return (_levelName == "Area07_Vault");
		}
		
	} // class

} // package

