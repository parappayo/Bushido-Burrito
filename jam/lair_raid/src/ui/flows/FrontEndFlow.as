package ui.flows 
{
	import ui.screens.*;
	
	public class FrontEndFlow extends Flow
	{
		private var _legalScreen :LegalScreen;
		private var _splashScreen :SplashScreen;
		private var _titleScreen :TitleScreen;
		
		public function FrontEndFlow(parent :Flow, game :Game) 
		{
			super(parent);
			
			_legalScreen = new LegalScreen(this, game);
			_splashScreen = new SplashScreen(this, game);
			_titleScreen = new TitleScreen(this, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.LEGAL_SCREEN:
					{
						if (Settings.SkipUI)
						{
							_parent.changeState(FlowStates.IN_GAME_FLOW);
							return;
						}
						
						_child = _legalScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.SPLASH_SCREEN:
					{
						_child = _splashScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.TITLE_SCREEN:
					{
						_child = _titleScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
			}
		}
		
		override public function handleChildDone() :void
		{
			switch (_state)
			{
				case FlowStates.LEGAL_SCREEN:
					{
						changeState(FlowStates.SPLASH_SCREEN);
					}
					break;
					
				case FlowStates.SPLASH_SCREEN:
					{
						changeState(FlowStates.TITLE_SCREEN);
					}
					break;
					
				case FlowStates.TITLE_SCREEN:
					{
						_parent.changeState(FlowStates.IN_GAME_FLOW);
					}
					break;					
			}
		}
		
	} // class

} // package
