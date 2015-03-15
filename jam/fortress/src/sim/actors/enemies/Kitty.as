package sim.actors.enemies
{
	import sim.actors.*;
	import sim.actors.Enemy;
	import sim.WorldPosition;
	import starling.textures.TextureAtlas;
	import sim.components.*;
	import sim.components.animstates.*;
	import resources.*;
	
	public class Kitty extends Enemy
	{
		public static const STATE_LIVE			:int = 0;
		public static const STATE_EXPLODING		:int = 1;
		public static const STATE_DEAD			:int = 2;

		protected var animation:Animation;
		private var _state:int;
		private var _timeInState:Number;
		
		public function Kitty() 
		{
			_state = STATE_LIVE;
			_timeInState = 0;
			
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(Atlases.ElementsTextures, "kitty_idle", true, Settings.SpriteFramerate/2));
			bank.add(Animations.DIE, new AnimStateSingle(Atlases.ElementsTextures, "kitty_explode"));
			bank.add(Animations.DEAD, new AnimStateSingle(Atlases.ElementsTextures, "kitty_explode", true));
			animation = new Animation(bank);
			animation.play(Animations.IDLE);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			_timeInState += elapsed;

			if (_state == STATE_EXPLODING)
			{
				animation.play(Animations.DEAD);
				_state = STATE_DEAD;
				_timeInState = 0;
			}
			else if (_state == STATE_DEAD)
			{
				if (_timeInState > 1.0)
				{
					animation.play(Animations.IDLE);
					_state = STATE_LIVE;
					_timeInState = 0;
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
			_state = STATE_EXPLODING;
			animation.play(Animations.DIE);
			game.handleActorSignal(Signals.EXPLOSION_EVENT, this);
			game.checkExplosion(worldPosition, 128);
			SoundPlayer.playRandom([Audio.sfx_en_cat_01, Audio.sfx_en_cat_03], Settings.VolumeSfxLoud);
		}
		
	} // class

} // package
