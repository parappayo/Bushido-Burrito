package sim.components 
{
	import sim.Bank;
	import sim.components.animstates.AnimState;
	
	public class AnimationBank extends Bank
	{
		public function find(id:int):AnimState
		{
			return _find(id) as AnimState;
		}
	}
}