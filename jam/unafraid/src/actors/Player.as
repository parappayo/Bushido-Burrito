package actors
{
	import flash.media.SoundTransform;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Player extends Actor
	{
		public var canMove:Boolean;
		private var isDeadFlag:Boolean;
		
		// flags reflect the keyboard state
		private var moveUp:Boolean;
		private var moveDown:Boolean;
		private var moveLeft:Boolean;
		private var moveRight:Boolean;
	
		private var speed:Number;
		private var velocity:Vector2D;
		private var targetVelocity:Vector2D;
		
		public function Player() 
		{
			canMove = true;
			isDeadFlag = false;
			
			var movieClip:MovieClip = new MovieClip(Assets.TA.getTextures("playerWalk"), 8);
			movieClip.pivotX = movieClip.width * 0.5;
			movieClip.pivotY = movieClip.height * 0.5;
			movieClip.addEventListener(Event.ADDED_TO_STAGE, init);
			movieClip.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			addChild(movieClip);
			Starling.juggler.add(movieClip);
			
			speed = 0;
			velocity = new Vector2D();
			targetVelocity = new Vector2D();
		}
		
		private function init():void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleRemovedFromStage():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			speed = 0;
			velocity.x = 0;
			velocity.y = 0;
			canMove = false;
			isDeadFlag = false;
			
			moveUp = false;
			moveDown = false;
			moveLeft = false;
			moveRight = false;
		}
		
		override public function update(game:Game):void
		{
			super.update(game);
			
			if (isDeadFlag) { return; }
			
			var acceleration :Number = 0.2;
			var deceleration :Number = 0.2;
			var maxSpeed :Number = 10;
			
			updateTargetVelocity();			
			if (targetVelocity.length() == 0)
			{
				speed -= deceleration;
				if (speed < 0) { speed = 0; }
				
				// hack: make stops more sudden
				if (velocity.length() < 0.2)
				{
					velocity.multiplyScalar(0);
				}
			}
			else
			{
				speed += acceleration;
				if (speed > maxSpeed) { speed = maxSpeed; }
				
				if (velocity.length() < 0.2)
				{
					// hack: make starts more sudden
					velocity.x = targetVelocity.x / 5;
					velocity.y = targetVelocity.y / 5;
				}
			}
			targetVelocity.multiplyScalar(speed);

			// how quickly should we approach the target velocity?
			velocity.blend(targetVelocity, 0.2);
			
			var newX:Number = worldPos.x + velocity.x;
			var newY:Number = worldPos.y + velocity.y;
					
			if (game.level.walkmesh.isWalkable(newX, worldPos.y))
			{
				worldPos.x = newX;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (game.level.walkmesh.isWalkable(worldPos.x, newY))
			{
				worldPos.y = newY;
			}
			else
			{
				velocity.y = 0;
			}
		}
		
		public function isDead():Boolean
		{
			return isDeadFlag;
		}
		
		public function kill():void
		{
			isDeadFlag = true;
		}
		
		/**
		 *  This creates a normalized velocity with no "speed" component to it.
		 */
		private function updateTargetVelocity():void
		{
			targetVelocity.x = 0;
			targetVelocity.y = 0;
			
			if (!canMove || isDead()) { return; }
			
			if (moveUp)
			{
				targetVelocity.y = -1;
			}
			else if (moveDown)
			{
				targetVelocity.y = 1;
			}
			if (moveLeft)
			{
				targetVelocity.x = -1;
			}
			else if (moveRight)
			{
				targetVelocity.x = 1;
			}
			
			targetVelocity.normalize();
		}
		
		/**
		 *  Update camera origin based on player's position.
		 */
		public function moveCamera(camera:Camera):void
		{
			var margin :Number = 300; // pixels
			
			if (worldPos.x < camera.origin.x + margin)
			{
				camera.origin.x = worldPos.x - margin;
			}
			else if (worldPos.x > camera.origin.x + camera.width - margin)
			{				
				camera.origin.x = worldPos.x - camera.width + margin;
			}
			
			if (worldPos.y < camera.origin.y + margin)
			{
				camera.origin.y = worldPos.y - margin;
			}
			else if (worldPos.y > camera.origin.y + camera.height - margin)
			{
				camera.origin.y = worldPos.y - camera.height + margin;
			}
		}
		
		private function handleKeyUp(keyEvent:KeyboardEvent):void
		{
			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				case 38: // up arrow key
				case 87: // W key
					{
						moveUp = false;
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						moveDown = false;
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{
						moveLeft = false;						
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						moveRight = false;
					}
					break;
			}
		}

		private function handleKeyDown(keyEvent:KeyboardEvent):void
		{
			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				case 38: // up arrow key
				case 87: // W key
					{
						moveUp = true;
					}
					break;
					
				case 40: // down arrow key
				case 83: // S key
					{
						moveDown = true;
					}
					break;
					
				case 37: // left arrow
				case 65: // A key
					{
						moveLeft = true;						
					}
					break;
					
				case 39: // right arrow
				case 68: // D key
					{
						moveRight = true;
					}
					break;
			}
		}
	}

}
