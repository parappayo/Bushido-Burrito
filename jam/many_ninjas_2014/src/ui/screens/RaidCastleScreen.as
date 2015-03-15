package ui.screens 
{
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.events.*;
	import feathers.controls.Button;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import sim.*;
	
	public class RaidCastleScreen extends Screen
	{
		private var _sprite :Sprite;

		private var _NinjaPool :NinjaPool;
		private var _RicePool :RicePool;
		private var _CastlePool :CastlePool;

		public function RaidCastleScreen(parent :Flow, game :Game) 
		{
			super(parent, game);

			_sprite = new Sprite();
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);

				_NinjaPool = _game.SimEntity.getComponent(NinjaPool) as NinjaPool;
				_RicePool = _game.SimEntity.getComponent(RicePool) as RicePool;
				_CastlePool = _game.SimEntity.getComponent(CastlePool) as CastlePool;

				var backingQuad :Quad = new Quad(Settings.ScreenWidth, Settings.ScreenHeight, 0xcccccc);
				backingQuad.alpha = 0.9;
				_sprite.addChild(backingQuad);

				var layoutX :int = Settings.ScreenWidth * 0.5;
				var layoutY :int = Settings.ScreenHeight * 0.25;

				var header :TextField = new TextField(Settings.ScreenWidth / 3, 50, "", Settings.DefaultFont, Settings.FontSize);
				header.text = "Next Target";
				header.x = layoutX - header.width * 0.5;
				header.y = layoutY;
				_sprite.addChild(header);
				layoutY += 50;

				var castleName :TextField = new TextField(Settings.ScreenWidth / 3, 50, "", Settings.DefaultFont, 24);
				castleName.text = _CastlePool.CurrentCastleName;
				castleName.x = layoutX - castleName.width * 0.5;
				castleName.y = layoutY;
				_sprite.addChild(castleName);
				layoutY += 60;
				
				var power :TextField = new TextField(Settings.ScreenWidth / 3, 50, "", Settings.DefaultFont, Settings.FontSize);
				power.text = "Power Level " + Utils.formatNumber(_CastlePool.CurrentCastlePower);
				power.x = layoutX - power.width * 0.5;
				power.y = layoutY;
				_sprite.addChild(power);
				layoutY += 100;

				var attackButton :Button = new Button();
				attackButton.label = "Attack!";
				attackButton.addEventListener(Event.TRIGGERED, raidCastle);
				attackButton.width = 100;
				attackButton.x = layoutX - attackButton.width * 0.5;
				attackButton.y = layoutY;
				_sprite.addChild(attackButton);
				layoutY += 50;
				
				var exitButton :Button = new Button();
				exitButton.label = "Back";
				exitButton.addEventListener(Event.TRIGGERED, function() :void { _parent.handleChildDone(); } );
				exitButton.width = 100;
				exitButton.x = layoutX - exitButton.width * 0.5;
				exitButton.y = layoutY;
				_sprite.addChild(exitButton);
				layoutY += 50;
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			
				_sprite.removeChildren();
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ACTION_KEYUP ||
				signal == Signals.BACK_KEYUP)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return false;
		}
		
		private function raidCastle() :void
		{
			_parent.handleChildDone();
			_NinjaPool.raidCastle();
		}
		
	} // class

} // package
