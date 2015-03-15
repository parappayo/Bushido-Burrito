package states 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import flash.media.SoundTransform;	
	
	public class PlayState extends Sprite implements IState 
	{		
		private var game:Game;

		private static const INIT_STATE:int = 0;
		private static const LEVEL_INTRO_NARRATION_STATE:int = 1;
		private static const SEEK_FIREPLACE_STATE:int = 2;
		private static const FIREPLACE_NARRATION_STATE:int = 3;
		private static const GHOSTS_ACTIVE_STATE:int = 4;

		private var state:int;
		private var framesElapsedInState:int;
		
		public function PlayState(game:Game) 
		{
			this.game = game;
			state = INIT_STATE;	
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			game.startLevel();
			changeState(LEVEL_INTRO_NARRATION_STATE);
		}
		
		private function handleRemovedFromStage():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function update():void
		{
			framesElapsedInState++;
			
			switch (state)
			{
				case SEEK_FIREPLACE_STATE:
					{
						playBabySounds();
						
						if (game.fireplace.isDiscovered())
						{
							changeState(FIREPLACE_NARRATION_STATE);
						}
					}
					break;
				
				case GHOSTS_ACTIVE_STATE:
					{
						playScarySounds();
						
						if (game.ghostManager.areGhostsDead())
						{
							game.changeState(Game.LEVEL_COMPLETE_STATE);
						}
						
						if (game.player.isDead())
						{
							game.changeState(Game.GAME_OVER_STATE);					
						}
					}
					break;
			}
		}
		
		private var framesSinceLastBabySound:int = 0;
		private function playBabySounds():void
		{
			framesSinceLastBabySound++;
			if (framesSinceLastBabySound > 300)
			{
				var index:int = Math.random() * (Audio.babySoundList.length-1);
				if (Audio.babySoundList != null)
				{
					Audio.babySoundList[index].play(0, 0, new SoundTransform(0.9));					
				}
				framesSinceLastBabySound = 0;
			}			
		}
		
		
		private var framesSinceLastScarySound:int = 0;
		private function playScarySounds():void
		{
			framesSinceLastScarySound++;
			const framesThreshold:int = 100 + (150 * Math.random());
			if (framesSinceLastScarySound > framesThreshold)
			{
				var index:int = Math.random() * (Audio.scarySoundList.length-1);
				if (Audio.scarySoundList != null)
				{
					Audio.scarySoundList[index].play(0, 0, new SoundTransform(0.9));					
				}
				framesSinceLastScarySound = 0;
			}			
		}		
		
		public function destroy():void
		{
			game.destoryLevel();
		}
		
		public function changeState(newState:int):void
		{
			handleExitState(state, newState);
			var oldState:int = newState;
			state = newState;
			framesElapsedInState = 0;
			handleEnterState(oldState, state);
		}
		
		public function handleEnterState(oldState:int, newState:int):void
		{
			switch(newState)
			{
				case LEVEL_INTRO_NARRATION_STATE:
					{
						game.player.canMove = false;
						game.narrationWidget.visible = true;
						game.narrationWidget.setCaption("DISTANT VOICE: FIND A WARM PLACE");
					}
					break;
					
				case SEEK_FIREPLACE_STATE:
					{
						game.player.canMove = true;
					}
					break;
					
				case FIREPLACE_NARRATION_STATE:
					{
						game.player.canMove = false;
						game.narrationWidget.visible = true;
						game.narrationWidget.setCaption("BRING ME YOUR FEARS!");
					}
					break;
					
				case GHOSTS_ACTIVE_STATE:
					{
						game.player.canMove = true;
						game.spawnGhosts();						
					}
					break;
			}
		}
		
		public function handleExitState(oldState:int, newState:int):void
		{
			switch(oldState)
			{
				case LEVEL_INTRO_NARRATION_STATE:
					{
						game.narrationWidget.visible = false;
					}
					break;

				case FIREPLACE_NARRATION_STATE:
					{
						game.narrationWidget.visible = false;
					}
					break;
			}
		}
		
		private function handleKeyDown(keyEvent:KeyboardEvent):void
		{
			switch(state)
			{
				case LEVEL_INTRO_NARRATION_STATE:
					{
						if (framesElapsedInState > 30) // 1 or 2 sec
						{
							changeState(SEEK_FIREPLACE_STATE);
						}
					}
					break;
					
				case FIREPLACE_NARRATION_STATE:
					{
						if (framesElapsedInState > 30) // 1 or 2 sec
						{
							changeState(GHOSTS_ACTIVE_STATE);
						}
					}
					break;
			}
		}
	}
}
