package 
{
	import actors.*;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import states.*;
	import ui.*;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const LEVEL_COMPLETE_STATE:int = 2;
		public static const GAME_OVER_STATE:int = 3;
		
		private var state_id:int;
		private var state:IState;
		private var actorManager:ActorManager;
		
		public var mainCamera:Camera;
		public var player:Player;
		public var fireplace:Fireplace;
		public var ghostManager:GhostManager;
		public var wallManager:WallManager;		
		public var fog:Fog;
		public var level:Level

		// widgets
		public var heartrateWidget:HeartrateWidget;
		public var narrationWidget:NarrationWidget;
		
		public function Game()
		{
			Audio.init();
			Assets.init();
			Particles.init();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			changeState(MENU_STATE);
			addEventListener(Event.ENTER_FRAME, update);
			
			mainCamera = new Camera();
			actorManager = new ActorManager();
			ghostManager = new GhostManager();

			wallManager = new WallManager();
			actorManager.register(wallManager);
			
			fireplace = new Fireplace();
			actorManager.register(fireplace);
			
			player = new Player();
			actorManager.register(player);
			
			fog = new Fog();
			fog.alpha = 0.9;
			
			heartrateWidget = new HeartrateWidget();
			narrationWidget = new NarrationWidget();
			
			level = new Level(Assets.LevelXML);
		}
		
		public function changeState(state_id:int):void
		{
			if(state != null)
			{
				state.destroy();
				state = null;
			}
			
			this.state_id = state_id;
			
			switch(state_id)
			{
				case MENU_STATE:
					state = new MenuState(this);
					break;
				case PLAY_STATE:
					state = new PlayState(this);
					break;
				case LEVEL_COMPLETE_STATE:
					state = new LevelCompleteState(this);
					break;
				case GAME_OVER_STATE:
					state = new GameOverState(this);
					break;
			}
			
			addChild(Sprite(state));
		}
		
		private function update(event:Event):void
		{
			state.update();
			
			switch(state_id)
			{
				case PLAY_STATE:
					{
						actorManager.update(this);
						ghostManager.update(this);
						wallManager.update(this);
			
						player.moveCamera(mainCamera);
						
						fog.startFrame();
						fog.applyMask(player.x, player.y, 1.0);
						fog.applyMask(fireplace.x, fireplace.y, 1.5);
					}
					break;
			}
			
		}
		
		public function startLevel():void
		{			
			// draw the walls first
			var wallPos:Point;
			for each(wallPos in level.wallsPos)
			{
				wallManager.spawnAtPos(wallPos.x, wallPos.y);
			}
			wallManager.flattenInner();
			addChild(wallManager);
			
			// fireplace
			fireplace.worldPos.x = level.fireplacePos.x;
			fireplace.worldPos.y = level.fireplacePos.y;
			addChild(fireplace);
			
			// player
			player.worldPos.x = level.playerPos.x;
			player.worldPos.y = level.playerPos.y;
			addChild(player);
			
			// fog - everything after this will be drawn over the fog
			addChild(fog);
			
			// heart rate display
			heartrateWidget.x = 1280 - 200;
			heartrateWidget.y = 30;
			heartrateWidget.setRate(20);
			//addChild(heartrateWidget);
			
			// telling stuff to the player
			narrationWidget.visible = false;
			narrationWidget.x = (1280 - narrationWidget.width) / 2;
			narrationWidget.y = 50;
			addChild(narrationWidget);
		}
		
		public function destoryLevel():void
		{
			Audio.fireplaceLoopChannel.soundTransform = new SoundTransform(0);
			removeChild(wallManager);
			removeChild(fireplace);
			removeChild(player);
			removeChild(fog);
			removeChild(heartrateWidget);
			removeChild(narrationWidget);
			ghostManager.clear(actorManager);
		}

		public function spawnGhosts():void
		{
			// ghosts
			var ghostPos:Point;
			for each(ghostPos in level.ghostsPos)
			{
				ghostManager.spawnAtPos(ghostPos.x, ghostPos.y, this, actorManager);
			}			
		}
		
		public function resetLevel():void
		{
		}
	}
}
