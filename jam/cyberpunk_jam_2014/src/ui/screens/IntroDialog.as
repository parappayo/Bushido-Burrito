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
		
		public static const IntroCaption :String = (<![CDATA[
It's a bitch of a way to start the week.
Gladwell's calling in debts, and you owe big.
His ultimatum: you pay $50k in 48 hours, or else.
]]> ).toString();

		public function IntroDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var width :Number = Settings.ScreenWidth * Settings.ScreenScaleX;
			var height :Number = Settings.ScreenHeight * Settings.ScreenScaleY;
			
			_quad = new Quad(width, height, 0x000000);
			_sprite.addChild(_quad);

			_caption = new TextField(width, height, IntroCaption, Settings.DefaultFont, Settings.FontSize, 0xffffff);
			_caption.y = -10;
			_caption.hAlign = HAlign.CENTER;
			_caption.vAlign = VAlign.CENTER;
			_sprite.addChild(_caption);
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
			if (signal == Signals.ACTION_KEYUP && _timeElapsedInState > MinScreenDuration)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return super.handleSignal(signal, sender, args);
		}

	} // class

} // package
