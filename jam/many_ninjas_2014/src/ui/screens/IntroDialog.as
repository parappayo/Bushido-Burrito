package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.*;

	import starling.utils.*;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class IntroDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _caption :TextField;
		
		public function IntroDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var width :Number = Settings.ScreenWidth;
			var height :Number = 452;
			
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);

			_caption = new TextField(width - 40, height, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			_caption.x = 40;
			_caption.y = -10;
			_caption.hAlign = HAlign.CENTER;
			_caption.vAlign = VAlign.TOP;
			_sprite.addChild(_caption);

			_sprite.x = 0;
			_sprite.y = 134;
			
			_caption.text = Settings.IntroCaption;
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
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

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_timeElapsedInState > MinScreenDuration &&
				(signal == Signals.ACCEPT_KEYUP || signal == Signals.TOUCH_BEGAN) )
			{
				_parent.handleChildDone();
				return true;
			}
			
			return super.handleSignal(signal, sender, args);
		}

	} // class

} // package
