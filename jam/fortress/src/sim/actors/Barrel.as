package sim.actors 
{
	import sim.WorldPosition;
	import starling.textures.TextureAtlas;
	import sim.components.*;
	import sim.components.animstates.*;
	import resources.*;
	
	public class Barrel extends Prop
	{
		public static const STATE_LIVE			:int = 0;
		public static const STATE_EXPLODING		:int = 1;
		public static const STATE_DEAD			:int = 2;

		protected var animation:Animation;
		private var _state:int;
		
		public function Barrel() 
		{
			_state = STATE_LIVE;
			
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "barrel_idle"));
			bank.add(Animations.DIE, new AnimStateSingle(Atlases.ElementsTextures, "barrel_die", false, 2));
			bank.add(Animations.DEAD, new AnimStateSingle(Atlases.ElementsTextures, "barrel_dead"));
			animation = new Animation(bank);
			animation.play(Animations.IDLE);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_state == STATE_EXPLODING)
			{
				if (animation.isDone())
				{
					animation.play(Animations.DEAD);
					_state = STATE_DEAD;
				}
			}

			animation.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			animation.handleSignal(game, this, signal, args);
		}
		
		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (ignore == this || _state != STATE_LIVE) { return false; }

			if (pos.boxCollide(worldPosition))
			{
				explode(game);
				return true;
			}
			
			return false;
		}
		
		override public function checkExplosion(game :Game, pos :WorldPosition, radius :Number):void
		{
			if (_state != STATE_LIVE) { return; }
			
			if (worldPosition.distance(pos) < radius)
			{
				explode(game);
			}
		}
		
		private function explode(game :Game):void
		{
			var e1:Effect = new Effect(Particles.ring, "ring", worldPosition.x+width/2, worldPosition.y+height/2, 0.1);
			game.handleSignal(Signals.EFFECT_ADD, e1);		
			animation.play(Animations.DIE);

			_state = STATE_EXPLODING;
			game.handleActorSignal(Signals.EXPLOSION_EVENT, this);
			game.checkExplosion(worldPosition, 60);
		}
		
	} // class

} // package
