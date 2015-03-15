package ui.flows 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import ui.screens.*;
	
	public class FrontEndFlow extends Flow
	{
		private var _legalScreen :LegalScreen;
		private var _titleScreen :TitleScreen;
		private var _introDialog :IntroDialog;
		
		public function FrontEndFlow(parent :Flow, game :Game) 
		{
			super(parent);
			
			_legalScreen = new LegalScreen(this, game);
			_titleScreen = new TitleScreen(this, game);
			_introDialog = new IntroDialog(this, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			switch (newState)
			{
				case FlowStates.LEGAL_SCREEN:
					{
						if (Settings.SkipUi)
						{
							_parent.changeState(FlowStates.IN_GAME_FLOW);
							return;
						}
						
						_child = _legalScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;
					
				case FlowStates.TITLE_SCREEN:
					{
						_child = _titleScreen;
						_child.changeState(FlowStates.ACTIVE);
					}
					break;

				case FlowStates.INTRO_DIALOG:
					{
						_child = _introDialog;
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
						changeState(FlowStates.TITLE_SCREEN);
					}
					break;
					
				case FlowStates.TITLE_SCREEN:
					{
						changeState(FlowStates.INTRO_DIALOG);
					}
					break;
					
				case FlowStates.INTRO_DIALOG:
					{
						_parent.changeState(FlowStates.IN_GAME_FLOW);
					}
					break;
			}
		}
		
	} // class

} // package
