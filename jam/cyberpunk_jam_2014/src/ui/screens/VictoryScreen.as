package ui.screens 
{
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class VictoryScreen extends Screen
	{
		private var _sprite :Sprite;
		private var _img :Image;
		private var _caption :TextField;
		
		public static const IntroCaption :String = (<![CDATA[
Looks like you made it, this time.
With the cash on hand, you clear your debt with Gladwell.
Live to fight another day, eh chum?
]]> ).toString();

		public function VictoryScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			ScreenDuration = 5.0;

			_sprite = new Sprite();
			
			_img = new Image(Assets.VictoryScreenTexture);
			_sprite.addChild(_img);

			var width :Number = 600;
			var height :Number = 400;
			_caption = new TextField(width, height, IntroCaption, Settings.DefaultFont, Settings.FontSize, 0xffffff);
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
			if (signal == Signals.ACTION_KEYUP && _timeElapsedInState > ScreenDuration)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return super.handleSignal(signal, sender, args);
		}

	} // class

} // package
