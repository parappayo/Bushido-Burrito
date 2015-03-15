package sim.components.action 
{
	import sim.Bank;
	import sim.components.action.ActionState;
	public class ActionBank extends Bank 
	{
		public function find(id:int):ActionState
		{
			return _find(id) as ActionState;
		}
	}
}