package  
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.*;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class Game extends starling.display.Sprite
	{
		private var _play :Play;
		private var _portrait :Sprite;
		private var _dialogue :TextField;
		
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);

			Assets.init();
			
			_portrait = new Sprite();
			_portrait.x = 16;
			_portrait.y = 100;
			addChild(_portrait);
			
			_dialogue = new TextField(Settings.ScreenWidth - _portrait.x, Settings.ScreenHeight / 3, "");
			_dialogue.x = _portrait.x;
			_dialogue.y = _portrait.y + 400;
			_dialogue.vAlign = VAlign.TOP;
			_dialogue.hAlign = HAlign.LEFT;
			addChild(_dialogue);
			
			_play = new Play();
			_play.init(Assets.HamletXML);
			_play.setActorPortrait("BERNARDO", "default", Assets.BernardoTexture);
			_play.setActorPortrait("FRANCISCO", "default", Assets.FranciscoTexture);
			_play.run("1", "1", _portrait, _dialogue);
			
			// menu test
			/*
			var numSlots :int = 3;			
			mainMenu = new Menu(numSlots);
			mainMenu.addItem(new MenuItem("New Game"));
			mainMenu.addItem(new MenuItem("Continue"));
			mainMenu.refresh();
			addChild(mainMenu);
			*/
		}
		
		private function handleAddedToStage() :void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleRemovedFromStage() :void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}

		private function handleKeyDown(keyEvent :KeyboardEvent) :void
		{
			switch (keyEvent.keyCode)
			{
				// note: find AS3 key codes here, http://www.dakmm.com/?p=272
				
				case 32: // space bar
					{
						_play.runNextLine();
					}
					break;
			}
		}
	}

} // package
