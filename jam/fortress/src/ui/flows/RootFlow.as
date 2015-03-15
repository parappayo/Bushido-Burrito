package ui.flows 
{
	import sim.Level;
	
	public class RootFlow extends Flow
	{
		private var _frontEndFlow :FrontEndFlow;
		private var _inGameFlow :InGameFlow;
		
		public function RootFlow(game :Game)
		{
			_frontEndFlow = new FrontEndFlow(this, game);
			_inGameFlow = new InGameFlow(this, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.FRONT_END_FLOW:
					{
						_child = _frontEndFlow;
						
						if (oldState == FlowStates.INIT)
						{
							// first time entry
							_child.changeState(FlowStates.LEGAL_SCREEN);
						}
						else
						{
							_child.changeState(FlowStates.TITLE_SCREEN);
						}
					}
					break;

				case FlowStates.IN_GAME_FLOW:
					{
						_child = _inGameFlow;
						//_inGameFlow.startingLevel = _frontEndFlow.getSelectedStartingLevel();
						_inGameFlow.changeState(FlowStates.LOADING);
					}
					break;
			}
		}
		
		override public function handleChildDone() :void
		{
			switch (_state)
			{
				case FlowStates.IN_GAME_FLOW:
					{
						changeState(FlowStates.FRONT_END_FLOW);
					}
					break;
			}
		}
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (signal == Signals.APP_EXIT)
			{
				changeState(FlowStates.EXIT);
			}
		}
		
	} // class

} // package
