package entities 
{
	import wyverntail.core.*;
	import common.*;
	import sim.NinjaPool;

	public class Ninja extends Component
	{
		private var _pos :Position2D;
		private var _clip :MovieClip;		
		private var _movement :DarknutMovement;
		
		public var _Rank :int = -1;
		public function get Rank() :int { return _Rank; }
		public function set Rank(value :int) :void
		{
			var newRank :int = Math.min(value, NinjaPool.NUM_NINJA_RANKS - 1);
			if (_Rank == newRank) { return; }
			_Rank = newRank;
			
			_clip.addAnimation("idle", Assets.Sprites.getTextures(NinjaPool.ninjaTextureName(Rank, "idle")), Settings.SpriteFramerate);
			_clip.addAnimation("walk", Assets.Sprites.getTextures(NinjaPool.ninjaTextureName(Rank, "walk")), Settings.SpriteFramerate);
			_clip.play("walk", true);
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_pos = getComponent(Position2D) as Position2D;
			_clip = getComponent(MovieClip) as MovieClip;
			_movement = getComponent(DarknutMovement) as DarknutMovement;

			_clip.setParent(prefabArgs.parentSprite);
			_clip.scaleX = prefabArgs.scaleX ? prefabArgs.scaleX : 1;
			_clip.scaleY = prefabArgs.scaleY ? prefabArgs.scaleY : 1;
			
			Rank = 0; // sets up animations

			_clip.enabled = false;
			_movement.enabled = false;
		}
		
		override public function update(elapsed :Number) :void
		{
			_clip.enabled = enabled;
			_movement.enabled = enabled;
			
			if (!enabled) { return; }
		}
		
	} // class

} // package
