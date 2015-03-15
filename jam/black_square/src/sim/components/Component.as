package sim.components 
{
	import sim.actors.Actor;
	public interface Component 
	{
		function update(game :Game, actor :Actor, elapsed :Number) :void;
		function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void;
	}
}