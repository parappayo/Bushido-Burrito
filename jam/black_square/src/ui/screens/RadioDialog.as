package ui.screens 
{
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import sim.Settings;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class RadioDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _caption :TextField;
		private static const MessageDuration :Number = 2.5; // seconds
		
		public function RadioDialog(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var box :Image = new Image(Assets.DialogueScreenTexture);
			_sprite.addChild(box);
			
			var width :Number = 500;
			var height :Number = 300;
			_caption = new TextField(width - 100, height, "", "blacksquare", 18, 0xffffff);
			_caption.x += 50;
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
				SoundPlayer.play(Audio.radio, Audio.VOLUME_SFX_LOUD);
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

			if (_timeElapsedInState > MessageDuration) // advance automatically
			{
				_parent.handleChildDone();
			}
		}

	} // class

} // package
