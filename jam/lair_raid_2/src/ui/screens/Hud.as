package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Sprite;
	
	public class Hud extends Screen 
	{
		private var _sprite :Sprite;

		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
		}
		
		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);
		}
		
	} // class
	
} // package
