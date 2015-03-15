package sim.components.animstates 
{
	import sim.actors.SpriteActor;
	public interface AnimState 
	{
		function enter(actor:SpriteActor):Boolean;
		function update(actor:SpriteActor, elapsed:Number):void;
		function exit(actor:SpriteActor, force:Boolean = false):Boolean;
		function isDone():Boolean;
	}
}