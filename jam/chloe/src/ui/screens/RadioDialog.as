package ui.screens 
{
	import flash.media.SoundTransform;
	import resources.*;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class RadioDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _quad :Quad;
		private var _caption :TextField;
		
		private const ScreenDuration :Number = 3.0; // seconds
		
		public function RadioDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			var width :Number = 500;
			var height :Number = 300;
			
			_sprite = new Sprite();
			
			_quad = new Quad(width, height, 0x8c8c8c);
			_sprite.addChild(_quad);
			
			_caption = new TextField(width, height, "", "default", 18, 0xffffff);
			_sprite.addChild(_caption);

			_sprite.x = (Settings.ScreenWidth - width) / 2;
			_sprite.y = (Settings.ScreenHeight - height) / 2;
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

		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);

			if (_timeElapsedInState > ScreenDuration) // advance automatically
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
