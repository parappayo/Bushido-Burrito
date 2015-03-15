package actors
{
	import flash.media.SoundTransform;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	
	/**
	 *  Agent that chases the player.
	 */
	public class Ghost extends Actor
	{
		public static const IDLE_STATE:int = 0;
		public static const CHASE_STATE:int = 1;
		public static const DEAD_STATE:int = 2;
		
		/// follow the player from this far
		public static const chaseRadius:Number = 600;
		
		/// killed by the fireplace from this far
		public static const deathRadius:Number = 80;
		
		private var movieClip:MovieClip;
		private var state:int;
		private var speed:Number;
		private var acceleration:Number;
		private var velocity:Vector2D;
		private var targetVelocity:Vector2D;
		private var framesSinceLastScream:int;
		
		public function Ghost(texture:String) 
		{
			movieClip = new MovieClip(Assets.TA.getTextures(texture), 6);
			movieClip.pivotX = movieClip.width * 0.5;
			movieClip.pivotY = movieClip.height * 0.5;
			movieClip.alpha = 0.8;
			addChild(movieClip);
			Starling.juggler.add(movieClip);
			
			state = IDLE_STATE;
			speed = 10;
			acceleration = 0.02;
			velocity = new Vector2D();
			targetVelocity = new Vector2D();
			framesSinceLastScream = 0;
		}
		
		override public function update(game:Game):void
		{
			super.update(game);
			
			if (state == IDLE_STATE)
			{
				velocity.x = 0;
				velocity.y = 0;
				
				// if the player gets into range, chase
				if (game.player.worldPos.distance(worldPos) < chaseRadius)
				{
					state = CHASE_STATE;
					scream(game, true);
				}
			}
			else if (state == CHASE_STATE)
			{
				if (game.fireplace.worldPos.distance(worldPos) < deathRadius)
				{
					state = DEAD_STATE;
					velocity.x = 0;
					velocity.y = 0;
					onDeathStarted(game);
				}
				else if (game.player.worldPos.distance(worldPos) > chaseRadius)
				{
					// if the player gets out of range, stop
					state = IDLE_STATE;
					velocity.x = 0;
					velocity.y = 0;
				}
				else
				{	
					scream(game);
					
					targetVelocity.x = game.player.worldPos.x - worldPos.x;
					targetVelocity.y = game.player.worldPos.y - worldPos.y;
					targetVelocity.normalize();
					targetVelocity.multiplyScalar(speed);
			
					if (velocity.length() < 0.2)
					{
						// hack: make starts more sudden
						velocity.x = targetVelocity.x / 5;
						velocity.y = targetVelocity.y / 5;
					}

					// how quickly should we approach the target velocity?
					velocity.blend(targetVelocity, acceleration);
				}
			}
			else if (DEAD_STATE)
			{
				movieClip.alpha -= 0.1;
			}
		
			worldPos.x += velocity.x;
			worldPos.y += velocity.y;
		}
		
		public function isChasing():Boolean
		{
			return state == CHASE_STATE;
		}
		
		public function isDead():Boolean
		{
			return state == DEAD_STATE;
		}
		
		private function scream(game:Game, force:Boolean = false):void
		{
			framesSinceLastScream++;
			const framesThreshold:int = 150 + (100 * Math.random());
			if (framesSinceLastScream > framesThreshold || force)
			{
				const distanceToPlayer:Number = game.player.worldPos.distance(worldPos);
				const distanceRatio:Number = Math.min(distanceToPlayer / chaseRadius, 1);
				const volume:Number = 0.5 + (1 - distanceRatio) * 0.3;
				const index:int = Math.random() * (Audio.ghostSoundList.length-1);
				Audio.ghostSoundList[index].play(0, 0, new SoundTransform(volume));
				framesSinceLastScream = 0;
			}
		}
		
		private function onDeathStarted(game:Game):void
		{
			var ex:Explosion = new Explosion();
			ex.emitterX = x;
			ex.emitterY = y;
			ex.start(0.1);
			game.addChild(ex);
			Starling.juggler.add(ex);
			ex.addEventListener(Event.COMPLETE, onDeathComplete);
			
			Audio.fireBlast.play(0, 0, new SoundTransform(0.5));
		}
		
		private function onDeathComplete(event:Event):void
		{
			var ex:Explosion = event.currentTarget as Explosion;
			Starling.juggler.remove(ex);
			ex.removeFromParent(true);
			
			const index:int = Math.random() * (Audio.deathSoundList.length-1);
			Audio.deathSoundList[index].play(0, 0, new SoundTransform(0.2));
		}
	}
}
