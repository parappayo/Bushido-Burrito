package sim.actors 
{
	import starling.textures.TextureAtlas;
	import sim.components.*;
	import sim.components.animstates.*;

	public class Turret extends Enemy
	{
		protected var animation:Animation;

		public function Turret() 
		{
			var bank:AnimationBank = new AnimationBank();
			bank.add(Animations.IDLE, new AnimStateSingle(Assets.ElementsTextures, "barrel_idle", false, 1));
			bank.add(Animations.DIE, new AnimStateSingle(Assets.ElementsTextures, "barrel_die", false, 2));
			bank.add(Animations.DEAD, new AnimStateSingle(Assets.ElementsTextures, "barrel_dead", false, 1));
			animation = new Animation(bank);
			animation.play(Animations.IDLE);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			animation.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			animation.handleSignal(game, this, signal, args);
		}
		
	} // class
	
} // package
