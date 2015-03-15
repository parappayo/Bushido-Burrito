package sim.components.action 
{
	import sim.actors.SpriteActor;
	public interface ActionState 
	{
		function enter(game:Game, actor:SpriteActor):void;
		function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean;
		function exit(game:Game, actor:SpriteActor):void;
	}	
}