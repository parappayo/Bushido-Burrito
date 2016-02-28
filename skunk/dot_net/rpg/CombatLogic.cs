
namespace Game.Sim
{
	public class CombatLogic
	{
		public void EvaluateCombat(Party party1, Party party2, CombatLog log)
		{
			EvaluateCombatRound(party1, party2, log);
			EvaluateCombatRound(party1, party2, log);
		}

		private void EvaluateCombatRound(Party party1, Party party2, CombatLog log)
		{
			
		}
	}
}