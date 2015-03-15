package ui.screens 
{
	import flash.display.Sprite;
	import ui.flows.Flow;
	
	public class Screen extends Flow
	{
		protected var _game :Game;
		
		protected var MinScreenDuration :Number = 0.5; // seconds
		protected var ScreenDuration :Number = 3.0; // seconds
		
		public function Screen(parent :Flow, game :Game) 
		{
			super(parent);
			_game = game;
		}
	}

} // package
