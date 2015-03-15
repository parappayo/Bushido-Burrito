package sim.components 
{
	import sim.actors.Actor;
	
	public class IdleComponent implements Component
	{
		public function update(game :Game, actor :Actor, elapsed :Number) :void {}
		public function handleSignal(game :Game, actor :Actor, signal :int, args :Object) :void {}
	}

}