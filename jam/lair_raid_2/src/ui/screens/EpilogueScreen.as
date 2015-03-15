package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class EpilogueScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		
		public function EpilogueScreen(parent :Flow, game :Game) 
		{
			super(parent, game);

			_sprite = new Sprite();
			
			var box :Image = new Image(Assets.CreditsScreenTexture);
			box.x = (Settings.ScreenWidth - box.width) * 0.5;
			box.y = (Settings.ScreenHeight - box.height) * 0.5;
			_sprite.addChild(box);
			
			var width :Number = 660;
			var height :Number = 800;
			_caption = new TextField(width, height, Settings.EpilogueCaption, Settings.DefaultFont, 18, 0xffffff);
			_caption.x += 50;
			_caption.x = (Settings.ScreenWidth - width) * 0.5;
			_caption.y = (Settings.ScreenHeight - height) * 0.5;
			_caption.hAlign = HAlign.CENTER;
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
			if (signal == Signals.ACTION_KEYUP || signal == Signals.TOUCH_BEGAN)
			{
				_parent.handleChildDone();
				return true;
			}
			return false;
		}

	} // class

} // package
