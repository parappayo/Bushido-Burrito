package sim.actors 
{
	import resources.*;
	import sim.*;
	import sim.components.*;
	import sim.components.action.*;
	import sim.components.animation.*;
	
	public class Player extends SpriteActor
	{
		private var input:Input;
		private var movement:Movement;
		private var pickup:PickUp;
		private var action:Action;
		private var animation:Animation;
		
		public function Player()
		{
			input = new Input();
			movement = new Movement(200);
			pickup = new PickUp(32);
			
			var actionBank:ActionBank = new ActionBank();
			actionBank.add(Actions.GRAB, new ActionStateGrab(0.08));
			action = new Action(actionBank);
			
			var animBank:AnimationBank = new AnimationBank();
			var footsteps:Array = [Audio.Footstep_tile_dry_1, Audio.Footstep_tile_dry_2];
			animBank.add(Animations.IDLE, new AnimState4Way(Atlases.CollegeGirlTextures, "idle"));
			animBank.add(Animations.HOLD, new AnimState2WayH(Atlases.CollegeGirlTextures, "hold"));
			animBank.add(Animations.WALK, new AnimState4Way(Atlases.CollegeGirlTextures, "walk", new SoundEvent(footsteps, 0.249)));
			animBank.add(Animations.CARRY, new AnimState2WayH(Atlases.CollegeGirlTextures, "carry", new SoundEvent(footsteps, 0.249)));
			animBank.add(Animations.PICKUP, new AnimState2WayH(Atlases.CollegeGirlTextures, "pickup"));
			animation = new Animation(animBank);
		}
		
		public function clear() :void
		{
			input.reset();
			movement.reset();
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			input.update(game, this, elapsed);
			movement.update(game, this, elapsed);
			pickup.update(game, this, elapsed);
			action.update(game, this, elapsed);
			animation.update(game, this, elapsed);
		}
		
		override public function handleSignal(game :Game, signal :int, args :Object) :void
		{	
			input.handleSignal(game, this, signal, args);
			movement.handleSignal(game, this, signal, args);
			pickup.handleSignal(game, this, signal, args);
			action.handleSignal(game, this, signal, args);
			animation.handleSignal(game, this, signal, args);
		}
		
		override public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			if (ignore == this) { return false; }
			if (pos.boxCollide(worldPosition))
			{
				return true;
			}
			return false;
		}
		
		override public function isCarrying() :Boolean
		{
			return pickup.hasProp();
		}
		
		// Update camera origin based on player's position
		public function moveCamera(camera :Camera) :void
		{
			var horizMargin :Number = Settings.ScreenWidth/8;
			var vertMargin :Number = Settings.ScreenHeight/3;
			if (getWorldInteract().x < camera.worldPosition.x + horizMargin)
			{
				camera.worldPosition.x = getWorldInteract().x - horizMargin;
			}
			else if (getWorldInteract().x > camera.worldPosition.x + Settings.ScreenWidth - horizMargin)
			{				
				camera.worldPosition.x = getWorldInteract().x - Settings.ScreenWidth + horizMargin;
			}
			if (getWorldInteract().y < camera.worldPosition.y + vertMargin)
			{
				camera.worldPosition.y = getWorldInteract().y - vertMargin;
			}
			else if (getWorldInteract().y > camera.worldPosition.y + Settings.ScreenHeight - vertMargin)
			{
				camera.worldPosition.y = getWorldInteract().y - Settings.ScreenHeight + vertMargin;
			}
		}		
	}
}
