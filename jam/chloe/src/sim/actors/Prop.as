package sim.actors 
{
	import sim.actors.SpriteActor;
	import sim.Vector2D;
	
	public class Prop extends SpriteActor
	{
		public static const TYPE_NONE				:int = 0;
		public static const TYPE_GENERIC			:int = 1;
		public static const TYPE_CAT				:int = 2;
		public static const TYPE_RADIO				:int = 3;
		public static const TYPE_STAIRS				:int = 4;
		
		public function onInteractStart():void
		{			
		}
		
		public function onInteractStop():void 
		{
		}
		
		public function canInteract():Boolean
		{
			return false;
		}
		public function getInteractOffsetX():Number
		{
			return 0;
		}
		public function getInteractOffsetY():Number
		{
			return 0;
		}
		public function getInteractOffsetDrop():Number
		{
			return 0;
		}			
		
	} // class

} // package
