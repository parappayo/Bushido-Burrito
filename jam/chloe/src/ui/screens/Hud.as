package ui.screens 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import resources.Screens;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	
	public class Hud extends Screen 
	{
		private var _sprite :Sprite;
		
		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			const safeZone:Number = 20;
			var logo:Image = new Image(Screens.imagamerTexture);
			logo.x = Settings.ScreenWidth - logo.width - safeZone;
			logo.y = safeZone;
			_sprite.addChild(logo);
			
			var posY:Number = 0;
			var height:Number = 85;
			var chloe:TextField = new TextField(135, height, "Chloe", "default", 48);
			chloe.x = safeZone;
			chloe.y = safeZone;
			_sprite.addChild(chloe);
			posY += height;
			
			height = 25;
			var move:TextField = new TextField(280, height, "move with arrows, interact with shift", "default", 14);
			move.x = safeZone;
			move.y = posY;
			_sprite.addChild(move);
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
		}
		
		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);
		}
	}
}