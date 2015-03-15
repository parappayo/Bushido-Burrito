package sim.components.animation 
{
	import sim.Bank;
	import sim.components.animation.AnimState;
	
	public class AnimationBank extends Bank
	{
		public function find(id:int):AnimState
		{
			return _find(id) as AnimState;
		}
	}
}