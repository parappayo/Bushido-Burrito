package ui.screens 
{
	import starling.display.Image;
	import starling.utils.*;
	import ui.flows.*;
	import starling.display.Sprite;
	import starling.text.TextField;
	import resources.*;
	import flash.media.SoundChannel;
	
	public class IntroDialog extends Screen
	{
		private var _sprite :Sprite;
		private var _bg :Image;
		private var _bg2 :Image;
		private var _bears :Image;
		private var _caption :TextField;
		private var _textTotal :String;
		private var _soundChannel :SoundChannel;
		private var _scroll1 :Number;
		private var _scroll2 :Number;
		
		public function IntroDialog(parent :Flow, game :Game) 
		{
			super(parent, game);

			_bg = new Image(Screens.IntroTexture);
			_bg2 = new Image(Screens.Intro2Texture);
			
			_bears = new Image(Screens.BearsTexture);
			
			_caption = new TextField(450, 200, "", "fortress", 18, 0xffffff);
			_caption.x = 330;
			_caption.y = 180;
			_caption.hAlign = HAlign.LEFT;
			_caption.vAlign = VAlign.TOP;
			
			_sprite = new Sprite();
			_sprite.addChild(_bg);
//			_sprite.addChild(_bears);
			_sprite.addChild(_bg2);
//			_sprite.addChild(_caption);
			_sprite.x = 0;
			_sprite.y = 0;
			
			_caption.text = "";
			_textTotal = "I entered the pillow fortress and saw that all of my toys had come to life. What was this strange new world?";
			_soundChannel = null;
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);

			const lettersPerSecond :Number = 30;
			const lettersCurrent :uint = Math.min(lettersPerSecond * _timeElapsedInState, _textTotal.length);
			const textCurrent :String = _textTotal.substr(0, lettersCurrent);
			_caption.text = textCurrent;
			
			if (_bg.y < 0)
			{
				_bg.y += _scroll1;
				_bears.y += _scroll1;
			}
			
			_bears.x += 50 * elapsed;
			_bears.scaleX += 0.02 * elapsed;
			_bears.scaleY += 0.02 * elapsed;
			
			if (_timeElapsedInState > 9)
			{
				_parent.handleChildDone();
			}
		}

		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_bears.x = 0;
				_bears.y = 480;
				_bears.scaleX = 1;
				_bears.scaleY = 1;
				
				_bg.width = Settings.ScreenWidth * 1.2;
				_bg.height = Settings.ScreenHeight * 1.2;
				_bg.x = -(_bg.width - Settings.ScreenWidth) / 2;
				_bg.y -= 0.2 * Settings.ScreenHeight;

				_scroll1 = 0.4;
				_scroll2 = 0;
				
				_game.UISprite.addChild(_sprite);
				
				_soundChannel = SoundPlayer.play(Audio.Song_Title, Settings.VolumeMusic);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
				_soundChannel.stop();
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
