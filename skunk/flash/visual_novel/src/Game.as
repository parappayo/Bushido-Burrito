package  
{
	import starling.display.Sprite;

	public class Game extends starling.display.Sprite
	{
		
		public function Game() 
		{
			Assets.init();
			
			var hamlet :Play = new Play();
			hamlet.init(Assets.HamletXML);
			hamlet.runScene(1, 1, this);
			
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
		
	}

} // package
