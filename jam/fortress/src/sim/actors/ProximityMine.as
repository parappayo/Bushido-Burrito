package sim.actors 
{
	import sim.WorldPosition;
	import starling.textures.TextureAtlas;
	import sim.components.*;
	import sim.components.animstates.*;
	import resources.*;
	
	public class ProximityMine extends Prop
	{
		public static const STATE_RIG			:int = 0;
		public static const STATE_LIVE			:int = 1;
		public static const STATE_TRIPPED		:int = 2;
		public static const STATE_EXPLODING		:int = 3;
		public static const STATE_DEAD			:int = 4;

		protected var animation:Animation;
		private var _state:int;
		private var _timeInState:Number;
		
		public const TriggerDistance :Number = 30.0;
		public const TriggerDelay :Number = 1;
		public const ExplosionTime :Number = 0.8;

		public function ProximityMine() 
		{
			_state = STATE_RIG;
			_timeInState = 0;
			
			var explodeAnim :AnimStateSingle = new AnimStateSingle(Atlases.ElementsTextures, "explode", true);
			
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "mine"));
			bank.add(Animations.DIE, explodeAnim);
			animation = new Animation(bank);
			animation.play(Animations.IDLE);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			_timeInState += elapsed;
			
			switch (_state)
			{
				case STATE_RIG:
					{
						_state = STATE_LIVE;
						_timeInState = 0;
					}
					break;
				
				case STATE_LIVE:
					{
						if (distanceToPlayer(game) < TriggerDistance)
						{
							trip(game);
						}
					}
					break;
					
				case STATE_TRIPPED:
					{
						if (_timeInState >= TriggerDelay)
						{
							explode(game);						
						}
					}
					break;
					
				case STATE_EXPLODING:
					{
						if (_timeInState > ExplosionTime)
						{
							_state = STATE_DEAD;
							_timeInState = 0;
							animation.exit(this);
						}
						else if (animation.isDone())
						{
							animation.play(Animations.DIE);
						}
					}
					break;
			}

			animation.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			animation.handleSignal(game, this, signal, args);
		}
		
		private function distanceToPlayer(game :Game) :Number
		{
			return game.getPlayer().worldPosition.distance(worldPosition);
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (_state != STATE_LIVE) { return; }
			
			if (worldPosition.distance(pos) < radius)
			{
				trip(game);
			}
		}
		
		private function trip(game:Game):void
		{
			_state = STATE_TRIPPED;
			_timeInState = 0;
		}
		
		private function explode(game:Game):void
		{
			_state = STATE_EXPLODING;
			_timeInState = 0;
			animation.play(Animations.DIE);
			game.handleActorSignal(Signals.EXPLOSION_EVENT, this);
			game.checkExplosion(worldPosition, 50);
		}

	} // class

} // package
