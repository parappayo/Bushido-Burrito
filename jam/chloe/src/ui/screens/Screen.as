package ui.screens 
{
	import flash.display.Sprite;
	import ui.flows.Flow;
	
	public class Screen extends Flow
	{
		protected var _game :Game;
		
		public function Screen(parent :Flow, game :Game) 
		{
			super(parent);
			_game = game;
		}
	}

}