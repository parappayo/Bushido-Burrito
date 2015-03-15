package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.*;
	
	public class MessageDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		
		public function MessageDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var box :Image = new Image(Assets.DialogueScreenTexture);
			_sprite.addChild(box);
			
			var width :Number = Settings.ScreenWidth * Settings.ScreenScaleX;
			var height :Number = Settings.ScreenHeight * Settings.ScreenScaleY;
			
			_caption = new TextField(width, height, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			_caption.hAlign = HAlign.CENTER;
			_caption.vAlign = VAlign.CENTER;
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
			if (signal == Signals.ACTION_KEYUP)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return false;
		}

	} // class

} // package
