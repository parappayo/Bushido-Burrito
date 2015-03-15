package sim.actors.props 
{
	import sim.actors.Prop;
	import sim.components.*;
	import sim.components.action.*;
	import sim.components.animation.*;
	import starling.display.Image;
	import resources.*;
	public class Cat extends Prop
	{
		private var action:Action;
		private var animation:Animation;
		
		public function Cat()
		{
			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.WAIT, new ActionStateWait(2, Animations.STRETCH));
			action = new Action(actionBank);
			action.execute(Actions.WAIT);
			
			var animBank:AnimationBank = new AnimationBank();
			animBank.add(Animations.STRETCH, new AnimStateSingle(Atlases.PropsTextures, "stretch"));
			animBank.add(Animations.SLEEPING, new AnimStateSingle(Atlases.PropsTextures, "sleeping"));
			animation = new Animation(animBank);
			animation.play(Animations.SLEEPING);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			action.update(game, this, elapsed);
			animation.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			action.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
		}
		
		override public function onInteractStart():void
		{
			var purrzillas:Array = [Audio.vo_cat_disapproving_01, Audio.vo_cat_dull_01];
			SoundPlayer.playRandom(purrzillas, Settings.VolumeSfx - 0.2);
		}
		
		override public function onInteractStop():void 
		{
		}
		
		override public function canInteract():Boolean
		{
			return true;
		}
		override public function getInteractOffsetX():Number
		{
			return 0;
		}
		override public function getInteractOffsetY():Number
		{
			return -150;
		}
		override public function getInteractOffsetDrop():Number
		{
			return -50 + 2;
		}		
	} // class
} // package