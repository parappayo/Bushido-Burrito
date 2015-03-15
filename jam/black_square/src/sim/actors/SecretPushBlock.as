package sim.actors 
{
	import starling.display.Image;
	import starling.display.Quad;
	import sim.*;
	
	public class SecretPushBlock extends PushBlock
	{
		public function SecretPushBlock() 
		{
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			if (_state != STATE_USED)
			{
				super.update(game, elapsed);
				
				if (_state == STATE_USED)
				{
					game.handleActorSignal(Signals.SECRET_PUSH_BLOCK_USED, this);
				}
			}
		}
		
		override public function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void
		{
			// only allowed to push vertically up
			if (dir.y < 0 && dir.x == 0)
			{
				super.checkPush(game, pos, dir);
			}
		}
		
	} // class

} // package
