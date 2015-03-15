package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class MessageDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		
		public function MessageDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var backingQuad :Quad = new Quad(Settings.ScreenWidth, Settings.ScreenHeight, 0xcccccc);
			backingQuad.alpha = 0.9;
			_sprite.addChild(backingQuad);
			
			var width :Number = 400;
			var height :Number = 200;
			_caption = new TextField(width, height, "", Settings.DefaultFont, Settings.FontSize);
			_caption.x += 50;
			_caption.x = (Settings.ScreenWidth - width) * 0.5;
			_caption.y = (Settings.ScreenHeight - height) * 0.5;
			_caption.hAlign = HAlign.CENTER;
			_sprite.addChild(_caption);
		}
		
		public function setCaption(caption :String) :void
		{
			_caption.text = caption;
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
			if (signal == Signals.ACTION_KEYUP ||
				signal == Signals.BACK_KEYUP ||
				signal == Signals.TOUCH_BEGAN)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return false;
		}

	} // class

} // package
