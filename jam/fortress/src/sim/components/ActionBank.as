package sim.components 
{
	import sim.Bank;
	import sim.components.actionstates.ActionState;
	public class ActionBank extends Bank 
	{
		public function find(id:int):ActionState
		{
			return _find(id) as ActionState;
		}
	}
}