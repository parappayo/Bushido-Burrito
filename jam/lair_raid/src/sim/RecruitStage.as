package sim 
{
	public class RecruitStage extends SimStage
	{
		public static const MaxPartySize :int = 10;
		
		public function RecruitStage() 
		{
			
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			super.update(game, elapsed);
			
			if (!_isActive) { return; }
		}
		
		override public function handleSignal(game :Game, signal :int) :void
		{
			super.handleSignal(game, signal);
		}
		
		override public function end(game :Game) :void
		{			
			for each (var chara :Character in Party)
			{
				chara.startCombat();
			}
		}
		
	} // class

} // package
