package sim 
{
	import sim.actors.*;
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
		
		// hacky
		private var _lastUsedRadio :MessageProp;

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
			var walkmeshOffsetY :Number;
			var walkmeshDoubleY :Boolean;

			var bitstring :String = levelData.walkmesh[0];
			walkmesh = new Walkmesh(bitstring);
			
			depthSorted.addChild(player);
			var playerSpawnFound :Boolean = false;
			
			xmlList = levelData.actors.children();
			for each (xml in xmlList)
			{
				actor = null;
				blockWalkmesh = false;
				walkmeshOffsetY = 0;
				walkmeshDoubleY = false;
				
				if (xml.name().localName == "player_spawn")
				{
					if (xml.@spawn_id == _spawnID)
					{
						playerSpawnFound = true;
						player.worldPosition.x = xml.@x;
						player.worldPosition.y = xml.@y;
						_game.centerCameraOnPlayer();
					}
				}
				else if (xml.name().localName == "sentry")
				{
					actor = enemies.spawn(Enemy.TYPE_SENTRY);
				}
				else if (xml.name().localName == "scout")
				{
					actor = enemies.spawn(Enemy.TYPE_SCOUT);
				}
				else if (xml.name().localName == "assault")
				{
					actor = enemies.spawn(Enemy.TYPE_ASSAULT);
				}
				else if (xml.name().localName == "stalin")
				{
					actor = enemies.spawn(Enemy.TYPE_STALIN);
				}
				else if (xml.name().localName == "stalin_onfoot")
				{
					actor = enemies.spawn(Enemy.TYPE_STALIN_ON_FOOT);
				}
				else if (xml.name().localName == "turret")
				{
					actor = enemies.spawn(Enemy.TYPE_TURRET);
				}
				else if (xml.name().localName == "exit")
				{
					actor = props.spawn(Prop.TYPE_STAIRS);
					
					var stairs :Stairs = actor as Stairs;
					stairs.NextLevelName = xml.@to_level_id;
					stairs.NextSpawnPoint = xml.@to_spawn_id;
				}
				else if (xml.name().localName == "secret_exit")
				{
					actor = props.spawn(Prop.TYPE_SECRET_STAIRS);
					
					var secretStairs :SecretStairs = actor as SecretStairs;
					secretStairs.NextLevelName = xml.@to_level_id;
					secretStairs.NextSpawnPoint = xml.@to_spawn_id;
				}
				else if (xml.name().localName == "barrel")
				{
					actor = props.spawn(Prop.TYPE_BARREL);
				}
				else if (xml.name().localName == "crate")
				{
					actor = props.spawn(Prop.TYPE_CRATE);
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "push_block")
				{
					actor = props.spawn(Prop.TYPE_PUSH_BLOCK);
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "secret_push_block")
				{
					actor = props.spawn(Prop.TYPE_SECRET_PUSH_BLOCK);
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "tank")
				{
					actor = props.spawn(Prop.TYPE_TANK);
				}
				else if (xml.name().localName == "truck")
				{
					actor = props.spawn(Prop.TYPE_TRUCK);
				}
				else if (xml.name().localName == "bookcase")
				{
					actor = props.spawn(Prop.TYPE_BOOKCASE);
					blockWalkmesh = true;
					walkmeshDoubleY = true;
				}
				else if (xml.name().localName == "paintings")
				{
					actor = props.spawn(Prop.TYPE_PAINTINGS);
					blockWalkmesh = true;
				}
				else if (xml.name().localName == "statue")
				{
					actor = props.spawn(Prop.TYPE_STATUE);
					blockWalkmesh = true;
					walkmeshOffsetY = Settings.TileH;
				}
				else if (xml.name().localName == "proximity_mine")
				{
					actor = props.spawn(Prop.TYPE_PROXIMITY_MINE);
				}
				else if (xml.name().localName == "radio")
				{
					actor = props.spawn(Prop.TYPE_RADIO);
					
					var radio :Radio = actor as Radio;
					radio.MessageCaption = xml.@message;
					//radio.MessageCaption.replace("\\n", "\n");
				}
				else if (xml.name().localName == "weapon_smg_pickup")
				{
					if (!player.hasSMG())
					{
						actor = props.spawn(Prop.TYPE_WEAPON_SMG_PICKUP);
					}
				}
				else if (xml.name().localName == "firstaid")
				{
					actor = props.spawn(Prop.TYPE_FIRST_AID);
				}
				else if (xml.name().localName == "blacksquare")
				{
					actor = props.spawn(Prop.TYPE_BLACK_SQUARE);
				}
				
				if (actor != null)
				{
					actor.worldPosition.x = xml.@x;
					actor.worldPosition.y = xml.@y;
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
				player.worldPosition.x = xml.@x;
				player.worldPosition.y = xml.@y;
				_game.centerCameraOnPlayer();				
			}
			
			backgroundTiles.levelWidth = levelData.@width / Settings.TileW;
			backgroundTiles.levelHeight = levelData.@height / Settings.TileH;
			backgroundTiles.setData(levelData.background.tile);
			
			foregroundTiles.levelWidth = levelData.@width / Settings.TileW;
			foregroundTiles.levelHeight = levelData.@height / Settings.TileH;
			foregroundTiles.setData(levelData.foreground.tile);
			
			hideLoadingScreen();
		}
		
		private function processPendingLoad() :void
		{
			_levelName = _pendingLoadLevel;
			_pendingLoadLevel = null;
			
			load(Assets[_levelName]);
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
				if (args.NextLevelName != "")
				{
					_spawnID = args.NextSpawnPoint;
					loadLevel(args.NextLevelName);
				}
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

