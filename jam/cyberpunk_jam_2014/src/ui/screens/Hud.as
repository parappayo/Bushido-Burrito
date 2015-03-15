package ui.screens 
{
	import starling.text.TextField;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Sprite;
	
	import sim.TimeOfDay;

	public class Hud extends Screen 
	{
		private var _sprite :Sprite;
		
		private var _timeOfDay :TimeOfDay;
		private var _tfTimeLeft :TextField;

		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			_tfTimeLeft = new TextField(200, 30, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			_tfTimeLeft.x = Settings.ScreenWidth * Settings.ScreenScaleX - 200;
			_tfTimeLeft.y = 10;
			_sprite.addChild(_tfTimeLeft);
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
		}
		
		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			var hours :Number = Math.floor(minutesLeft() / 60);
			var minutes :Number = minutesLeft() % 60;
			var extraZero :String = "";
			if (minutes < 10) { extraZero = "0"; }
			_tfTimeLeft.text = "Time Left " + hours + ":" + extraZero + minutes.toFixed(0);
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.LEVEL_LOAD_COMPLETE)
			{
				_timeOfDay = _game.gameSim.getComponent(TimeOfDay) as TimeOfDay;
			}
			
			return super.handleSignal(signal, sender, args);
		}
		
		private function minutesLeft() :Number
		{
			if (!_timeOfDay) { return 0; }
			return _timeOfDay.minutesLeft;
		}
		
	} // class
	
} // package
