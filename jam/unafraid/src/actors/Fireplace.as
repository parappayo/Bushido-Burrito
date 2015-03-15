package actors 
{
	public class Fireplace extends Actor
	{
		import flash.media.SoundTransform;
		import starling.core.Starling;
		import starling.display.Image;
		import starling.display.Quad;
		import starling.display.Sprite;
		import starling.events.Event;
		import starling.extensions.PDParticleSystem;
		
		private static const INIT_STATE:int = 0;
		private static const UNDISCOVERED_STATE:int = 1;
		private static const DISCOVERED_STATE:int = 2;
		private static const OBLITERATING_STATE:int = 3;
		
		private var state:int;
		private var campfire:PDParticleSystem;
		
		public function Fireplace() 
		{
			var img:Image = new Image(Assets.TA.getTexture("shrine"));
			img.pivotX = img.width * 0.5;
			img.pivotY = img.height * 0.5;
			addChild(img);
			
			campfire = new PDParticleSystem(XML(new Particles.CampfireXML()), Assets.TA.getTexture("campfire"));
			campfire.emitterY = 40;
			Starling.juggler.add(campfire);
			addChild(campfire);
			campfire.start();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}

		private function init():void
		{
			state = UNDISCOVERED_STATE;
			Audio.fireplaceLoopChannel.soundTransform.volume = 0;
		}
		
		private function handleRemovedFromStage():void
		{
			state = INIT_STATE;
			Audio.fireplaceLoopChannel.soundTransform.volume = 0;
		}		
		
		override public function update(game:Game):void
		{
			switch (state)
			{
				case UNDISCOVERED_STATE:
				{
					if (game.player.worldPos.distance(worldPos) <= 200)
					{
						state = DISCOVERED_STATE;
					}
				}
				break;
			}
			
			const distanceToPlayer:Number = game.player.worldPos.distance(worldPos);
			const distanceRatio:Number = Math.min(distanceToPlayer / 600, 1);
			const volume:Number = (1 - distanceRatio) * 0.7;
			Audio.fireplaceLoopChannel.soundTransform = new SoundTransform(volume);
		}
		
		public function isDiscovered():Boolean
		{
			return (state == DISCOVERED_STATE);
		}
	}

}