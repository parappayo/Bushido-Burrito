package ui.screens 
{
	import starling.utils.*;
	import ui.flows.*;
	import sim.Settings;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class IntroDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _caption :TextField;
		private var _textTotal :String;
		
		public function IntroDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			var width :Number = Settings.ScreenWidth;
			var height :Number = 452;
			
			_sprite = new Sprite();
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);

			_caption = new TextField(width - 40, height, "", "blacksquare", 18, 0xffffff);
			_caption.x = 40;
			_caption.y = -10;
			_caption.hAlign = HAlign.LEFT;
			_caption.vAlign = VAlign.TOP;
			_sprite.addChild(_caption);

			_sprite.x = 0;
			_sprite.y = 134;
			
			_caption.text = "";
			_textTotal = "";
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);

			const lettersPerSecond :Number = 60;
			const lettersCurrent :uint = Math.min(lettersPerSecond * _timeElapsedInState, _textTotal.length);
			const textCurrent :String = _textTotal.substr(0, lettersCurrent);
			_caption.text = textCurrent;
		}

		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				var feParent :FrontEndFlow = _parent as FrontEndFlow;
				_textTotal = Settings.MissionIntros[feParent.getMissionIndex()];
				_textTotal = _textTotal.replace("AcceptButton", Settings.AcceptButton);
				_game.UISprite.addChild(_sprite);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			}
		}

		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (_timeElapsedInState > MinScreenDuration && signal == Signals.ACCEPT_KEYUP)
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
